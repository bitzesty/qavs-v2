class Reports::CitationReport
  attr_reader :award_year, :scope

  include Reports::CSVHelper

  MAPPING = [
    {
      label: "Award Year",
      method: :year
    },
    {
	    label: "Group Leader",
      method: :group_leader_name
    },
    {
	    label: "Email Address",
      method: :gl_email
    },
    {
	    label: "Group name",
      method: :citation_group_name
    },
    {
	    label: "Updated Citation",
	    method: :citation_body
    },
    {
      label: "Original Citation",
      method: :ll_citation
    },
    {
      label: "Lieutenancy",
      method: :lieutenancy
    }
  ]


  def initialize(award_year)
    @award_year = award_year
    @scope = @award_year.form_answers.winners
      .includes(:citation, :group_leader, :ceremonial_county)
      .where.not(citation: { completed_at: nil })
  end

  private

  def mapping
    MAPPING
  end
end
