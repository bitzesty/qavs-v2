class AssessorAssignmentCollection < AssignmentCollection
  NOT_ASSIGNED = "not assigned"

  attribute :sub_group, String


  def save
    return unless valid?

    form_answers.update_all(sub_group: sub_group)
  end

  def notice_message
    if ids.length > 1
      "Groups have"
    else
      "Group has"
    end.concat " been assigned to the national assessor sub-group."
  end
end
