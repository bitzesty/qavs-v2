class Admin::CitationsController < Admin::BaseController
  def index
    authorize :citation, :index?

    respond_to do |format|
      format.csv do
        report = Reports::CitationReport.new(@award_year)

        send_data report.build, type: "text/csv", disposition: 'attachment'
      end
    end
  end
end
