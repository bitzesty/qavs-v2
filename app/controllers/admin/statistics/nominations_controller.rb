class Admin::Statistics::NominationsController < Admin::BaseController
  def index
    authorize :statistics, :index?

    @search = NominationStatsSearch.new(FormAnswer.all).search(permitted_params)
  end

  def create
    authorize :statistics, :send?

    @search = NominationStatsSearch.new(FormAnswer.all).search(permitted_params)
    
    data = generate_csv(@search.results)
    file = current_admin.protected_files.create_from_raw_data(data, "nomination-statistics-export.csv")

    Admin::Statistics::NominationMailer.notify(current_admin.id, file.id).deliver_now

    redirect_to admin_statistics_nominations_path(search: permitted_params), success: "CSV with nomination statistics has been sent to #{current_admin.email}."
  end

  private

  def permitted_params
    params.fetch(:search, NominationStatsSearch.default_search).permit!
  end

  def generate_csv(data)
    CSV.generate(encoding: "UTF-8", force_quotes: true) do |csv|
      csv << csv_mapping.map { |m| m[:label] }
      data.each do |row|
        csv << csv_mapping.map do |m|
          func = m[:method]
          row[func]
        end
      end

      csv << csv_mapping.map do |m|
        func = m[:method]

        if func == :ceremonial_county_name
          "Total"
        else
          data.sum(&func)
        end
      end
    end
  end

  def csv_mapping
    [
      {
        label: "Lieutenancy",
        method: :ceremonial_county_name
      },
      {
        label: "Nominations submitted",
        method: :submitted_count
      },
      {
        label: "Eligiblity - Admin eligible",
        method: :admin_eligible_count
      },
      {
        label: "Eligiblity - Not eligible nominator",
        method: :admin_not_eligible_nominator_count
      },
      {
        label: "Eligiblity - Not eligible group",
        method: :admin_not_eligible_group_count
      },
      {
        label: "Eligiblity - Withdrawn",
        method: :withdrawn_count
      },
      {
        label: "Local Assessment - Not recommended",
        method: :local_assessment_not_recommended_count
      },
      {
        label: "Local Assessment - Recommended",
        method: :local_assessment_recommended_count
      },
      {
        label: "National Assessment - Not recommended",
        method: :not_recommended_count
      },
      {
        label: "National Assessment - Recommended",
        method: :shortlisted_count
      },
      {
        label: "Royal Approval - Awarded",
        method: :awarded_count
      },
      {
        label: "Total",
        method: :total_count
      }
    ]
  end
end
