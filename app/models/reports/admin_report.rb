class Reports::AdminReport
  attr_reader :id, :year, :params

  def initialize(id, year, params = {})
    @id = id
    @year = year
    @params = params
  end

  def as_csv
    case id
    when "registered-users"
      Reports::RegisteredUsers.new(year).build
    when "press-book-list"
      Reports::PressBookList.new(year).build
    when "cases-status"
      Reports::CasesStatusReport.new(year).build
    when "entries-report"
      Reports::AllEntries.new(year).build
    when "discrepancies_between_primary_and_secondary_appraisals"
      Reports::DiscrepanciesBetweenPrimaryAndSecondaryAppraisals.new(year, "qavs").build
    when /assessors-progress/
      Reports::AssessorsProgressReport.new(year, "qavs").build
    end
  end

  def as_pdf
    pdf_klass = case id
    when "feedbacks"
      FeedbackPdfs::Base
    when "case_summaries"
      CaseSummaryPdfs::Base
    end

    attachment = year.send("#{id.singularize}_#{category}_hard_copy_pdf")

    # Render dynamically
    ops = {category: category, award_year: year}

    data = pdf_klass.new("all", nil, ops)

    OpenStruct.new(
      data: data.render,
      filename: pdf_filename
    )
  end

  private

  def category
    "qavs"
  end

  def pdf_filename
    pdf_timestamp = Time.zone.now.strftime("%e_%b_%Y_at_%-l:%M%P")
    "qavs_award_#{id}_#{pdf_timestamp}.pdf"
  end
end
