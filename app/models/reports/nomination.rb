class Reports::Nomination

  attr_reader :obj,
              :answers,
              :award_form

  def initialize(form_answer)
    @obj = form_answer
    @answers = ActiveSupport::HashWithIndifferentAccess.new(obj.document)
    @award_form = form_answer.award_form.decorate(answers: answers)
  end

  def call_method(method_name)
    return "not implemented" if method_name.blank?

    if respond_to?(method_name, true)
      send(method_name)
    elsif obj.respond_to?(method_name)
      obj.send(method_name)
    else
      "missing method"
    end
  end

  private

  def award_year
    obj.award_year.year
  end

  def group_leader_name
    doc["nominee_leader_name"]
  end

  def group_leader_phone
    doc["nominee_leader_telephone"]
  end

  def group_leader_email
    doc["nominee_leader_email"]
  end

  def group_address_building
    doc["nominee_address_building"]
  end

  def group_address_street
    doc["nominee_address_street"]
  end

  def group_address_city
    doc["nominee_address_city"]
  end

  def group_address_county
    doc["nominee_address_county"]
  end

  def group_address_postcode
    doc["nominee_address_postcode"]
  end

  def nominee_activity
    NomineeActivityHelper.lookup_label_for_activity(obj.nominee_activity.to_sym)
  end

  def secondary_activity
    NomineeActivityHelper.lookup_label_for_activity(obj.secondary_activity.to_sym)
  end

  def ceremonial_county
    obj.ceremonial_county.try(:name)
  end

  def region
    "region???"
  end

  def primary_assessor_name
    # E 1.1
    doc["assessor_details_primary_assessor_name"]
  end

  def secondary_assessor_name
    doc["assessor_details_secondary_assessor_name"]
  end

  def la_nominee_name
    # E 1.2
    doc["nomination_local_assessment_form_nominee_name"]
  end

  # E 1.3
  def la_group_leader
    doc["local_assessment_group_leader"]
  end

  # E 1.4
  def la_group_leader_position
    doc["local_assessment_group_leader_position"]
  end

  def la_group_address_building
    doc["local_assessment_group_address_building"]
  end

  def la_group_address_street
    doc["local_assessment_group_address_street"]
  end

  def la_group_address_city
    doc["local_assessment_group_address_city"]
  end

  def la_group_address_county
    doc["local_assessment_group_address_county"]
  end

  def la_group_address_postcode
    doc["local_assessment_group_address_postcode"]
  end

  def la_group_leader_email
    doc["local_assessment_group_leader_email"]
  end

  def la_group_leader_phone
    doc["local_assessment_group_leader_phone"]
  end

  def la_group_details_confirmed
    doc["group_details_confirmed"]
  end

  def la_group_eligibility_confirmed
    doc["group_eligibility_confirmed"]
  end

  def la_eligibility_comment
    doc["local_assessment_eligibility_comment"]
  end

  def la_citation_summary
    doc["l_citation_summary"]
  end

  def la_work_of_the_group
    doc["nomination_local_assessment_form_provided_services"]
  end

  def la_full_citation_full
    doc["nomination_local_assessment_form_citation_full"]
  end

  def la_form_member_worthy_of_honour
    doc["nomination_local_assessment_form_member_worthy_of_honour"]
  end

  def la_worthy_of_honour_name
    doc["nomination_local_assessment_worthy_of_honour_name"]
  end

  def la_worthy_of_honur_reasons
    doc["nomination_local_assessment_worthy_of_honur_reasons"]
  end

  def la_nominating_member_worthy_of_honour_full_name
    doc["assessor_nominating_member_worthy_of_honour_full_name"]
  end

  def la_nominating_member_worthy_of_honour_email
    doc["assessor_nominating_member_worthy_of_honour_email"]
  end

  def la_nominating_member_worthy_of_honour_phone
    doc["assessor_nominating_member_worthy_of_honour_phone"]
  end

  def doc
    obj.document
  end

  def bool(var)
    var ? "Yes" : "No"
  end
end
