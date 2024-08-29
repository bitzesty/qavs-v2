class Reports::Nomination

  attr_reader :obj,
              :answers,
              :award_form,
              :assessments,
              :year

  def initialize(form_answer, year = nil)
    @obj = form_answer
    @answers = ActiveSupport::HashWithIndifferentAccess.new(obj.document)
    @award_form = form_answer.award_form.decorate(answers: answers)

    @assessments = form_answer.assessor_assignments.select(&:submitted?).sort_by(&:id).map do |a|
      Reports::Assessment.new(form_answer, a, year)
    end
  end

  def call_method(method_name)
    return "not implemented" if method_name.blank?

    if respond_to?(method_name, true)
      send(method_name)
    elsif obj.respond_to?(method_name)
      obj.send(method_name)
    # national assessment methods
    elsif method_name.starts_with?("na_")
      if @assessments[assessment_index(method_name)]
        @assessments[assessment_index(method_name)].fetch(method_name.gsub(/(^na_)|(_\d$)/, ''))
      else
        ""
      end
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

  def nominee_website
    doc["nominee_website"]
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
    obj.nominee_activity.presence && NomineeActivityHelper.lookup_label_for_activity(obj.nominee_activity.to_sym)
  end

  def secondary_activity
    obj.secondary_activity.presence && NomineeActivityHelper.lookup_label_for_activity(obj.secondary_activity.to_sym)
  end

  def nominee_established_date
    doc["nominee_established_date"]
  end

  def group_activities
    doc["group_activities"]
  end

  def beneficiaries
    doc["beneficiaries"]
  end

  def benefits
    doc["benefits"]
  end

  def volunteers
    doc["volunteers"]
  end

  def ceremonial_county
    obj.ceremonial_county.try(:name)
  end

  def region
    region_by_lieutenancy(ceremonial_county)
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

  def region_by_lieutenancy(lieutenancy)
    {
      "Derbyshire" => "East Midlands",
      "Leicestershire" => "East Midlands",
      "Lincolnshire" => "East Midlands",
      "Northamptonshire" => "East Midlands",
      "Nottinghamshire" => "East Midlands",
      "Rutland" => "East Midlands",
      "Bedfordshire" => "East of England",
      "Cambridgeshire" => "East of England",
      "Hertfordshire" => "East of England",
      "Norfolk" => "East of England",
      "Suffolk" => "East of England",
      "County Durham" => "North East",
      "Northumberland" => "North East",
      "Tyne and Wear" => "North East",
      "Cheshire" => "North West",
      "Cumbria" => "North West",
      "Greater Manchester" => "North West",
      "Lancashire" => "North West",
      "Merseyside" => "North West",
      "Berkshire" => "South East",
      "Buckinghamshire" => "South East",
      "East Sussex" => "South East",
      "Essex" => "South East",
      "Greater London" => "South East",
      "Hampshire" => "South East",
      "Kent" => "South East",
      "Oxfordshire" => "South East",
      "Surrey" => "South East",
      "the Isle of Wight" => "South East",
      "West Sussex" => "South East",
      "Cornwall" => "South West",
      "Devon" => "South West",
      "Gloucestershire" => "South West",
      "Somerset" => "South West",
      "The City and County of Bristol" => "South West",
      "Wiltshire" => "South West",
      "Dorset" => "South West",
      "Herefordshire" => "West Midlands",
      "Shropshire" => "West Midlands",
      "Staffordshire" => "West Midlands",
      "the West Midlands" => "West Midlands",
      "Warwickshire" => "West Midlands",
      "Worcestershire" => "West Midlands",
      "North Yorkshire" => "Yorkshire and the Humber",
      "South Yorkshire" => "Yorkshire and the Humber",
      "The East Riding of Yorkshire" => "Yorkshire and the Humber",
      "West Yorkshire" => "Yorkshire and the Humber",
      "Guernsey" => "Islands",
      "Isle of Man" => "Islands",
      "Jersey" => "Islands",
      "County Antrim" => "Northern Ireland",
      "County Armagh" => "Northern Ireland",
      "The County Borough of Belfast" => "Northern Ireland",
      "The County Borough of Londonderry" => "Northern Ireland",
      "County Down" => "Northern Ireland",
      "County Fermanagh" => "Northern Ireland",
      "County Tyrone" => "Northern Ireland",
      "County Londonderry" => "Northern Ireland",
      "Aberdeenshire" => "Scotland",
      "Angus" => "Scotland",
      "Argyll and Bute" => "Scotland",
      "Ayrshire and Arran" => "Scotland",
      "Banffshire" => "Scotland",
      "Berwickshire" => "Scotland",
      "Caithness" => "Scotland",
      "Clackmannanshire" => "Scotland",
      "Dumfries" => "Scotland",
      "Dunbartonshire" => "Scotland",
      "East Lothian" => "Scotland",
      "Fife" => "Scotland",
      "Inverness" => "Scotland",
      "Kincardineshire" => "Scotland",
      "Lanarkshire" => "Scotland",
      "Midlothian" => "Scotland",
      "Moray" => "Scotland",
      "Nairn" => "Scotland",
      "Orkney" => "Scotland",
      "Perth and Kinross" => "Scotland",
      "Renfrewshire" => "Scotland",
      "Ross and Cromarty" => "Scotland",
      "Roxburgh Ettrick and Lauderdale" => "Scotland",
      "Shetland" => "Scotland",
      "Stirling and Falkirk" => "Scotland",
      "Sutherland" => "Scotland",
      "the City of Aberdeen" => "Scotland",
      "the City of Dundee" => "Scotland",
      "the City of Edinburgh" => "Scotland",
      "the City of Glasgow" => "Scotland",
      "the Stewartry of Kirkcudbright" => "Scotland",
      "the Western Isles" => "Scotland",
      "Tweeddale" => "Scotland",
      "West Lothian" => "Scotland",
      "Wigtown" => "Scotland",
      "Clwyd" => "Wales",
      "Dyfed" => "Wales",
      "Gwent" => "Wales",
      "Gwynedd" => "Wales",
      "Mid Glamorgan" => "Wales",
      "Powys" => "Wales",
      "South Glamorgan" => "Wales",
      "West Glamorgan" => "Wales"
    }[lieutenancy]
  end

  def assessment_index(method_name)
    index = method_name.gsub(/^([a-z]+_)+/, '')
    index = index.to_i - 1

    raise ArgumentError, "incorrect index" if index < 0

    index
  end
end
