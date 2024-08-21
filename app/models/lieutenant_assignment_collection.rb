class LieutenantAssignmentCollection < AssignmentCollection
  NOT_ASSIGNED = "not assigned"

  attribute :ceremonial_county_id, String

  binding.pry

  def save
    return unless valid?

    form_answers.update_all(ceremonial_county_id: ceremonial_county_id)
  end

  def notice_message
    if ids.length > 1
      "Groups have"
    else
      "Group has"
    end.concat " been assigned to the Lord Lieutenancy office."
  end
end
