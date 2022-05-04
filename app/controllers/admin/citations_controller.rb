class Admin::CitationsController < Admin::BaseController
  def index
    authorize :citation, :index?

    respond_to do |format|
      format.csv do
        report = Reports::CitationReport.new(@award_year)
        date = Time.zone.now.strftime("%d-%m-%Y")

        send_data report.build,
                  type: "text/csv",
                  disposition: 'attachment',
                  filename: "group_leader_data_#{date}.csv"
      end
    end
  end
end
