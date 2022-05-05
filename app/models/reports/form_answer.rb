class Reports::FormAnswer
  include Reports::DataPickers::UserPicker
  include Reports::DataPickers::FormDocumentPicker
  include FormAnswersBasePointer
  include ActionView::Helpers::SanitizeHelper

  attr_reader :obj,
              :answers,
              :award_form

  def initialize(form_answer, limited_access=false)
    @obj = form_answer
    @answers = ActiveSupport::HashWithIndifferentAccess.new(obj.document)
    @award_form = form_answer.award_form.decorate(answers: answers)

  end

  def question_visible?(question_key)
    question = award_form[question_key.to_sym]
    question.blank? || question.visible?(answers)
  end

  def call_method(methodname)
    return "not implemented" if methodname.blank?

    if respond_to?(methodname, true)
      send(methodname)
    elsif obj.respond_to?(methodname)
      obj.send(methodname)
    else
      "missing method"
    end
  end

  private

  def case_withdrawn
    bool obj.withdrawn?
  end

  def percentage_complete
    obj.fill_progress_in_percents
  end

  def section1
    obj.form_answer_progress.try(:section, 1)
  end

  def section2
    obj.form_answer_progress.try(:section, 2)
  end

  def section3
    obj.form_answer_progress.try(:section, 3)
  end

  def section4
    obj.form_answer_progress.try(:section, 4)
  end

  def section5
    obj.form_answer_progress.try(:section, 5)
  end

  def section6
    obj.form_answer_progress.try(:section, 6)
  end

  def category
    "QAVS"
  end

  def bool(var)
    var ? "Yes" : "No"
  end

  def overall_status
    obj.state.humanize
  end

  def citation
    @citation = obj.citation
  end

  def group_leader_name
    obj.document["local_assessment_group_leader"]
  end

  def gl_email
    obj.group_leader.try(:email)
  end

  def ll_citation
    sanitize(obj.document["l_citation_summary"], tags: [])
  end

  def citation_group_name
    citation.group_name
  end

  def citation_body
    citation.body
  end

  def year
    obj.award_year.year
  end

  def lieutenancy
    obj.ceremonial_county.try(:name)
  end
end
