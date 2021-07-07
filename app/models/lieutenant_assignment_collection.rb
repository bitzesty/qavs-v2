class LieutenantAssignmentCollection
  NOT_ASSIGNED = "not assigned"

  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :form_answer_ids, String
  attribute :ceremonial_county_id, String

  attr_accessor :subject

  def persisted?
    false
  end

  def save
    return unless valid?

    form_answers.update_all(ceremonial_county_id: ceremonial_county_id)
  end

  private

  def form_answers
    @form_answers ||= FormAnswer.where(id: ids)
  end

  def ids
    form_answer_ids.split(",").select { |i| i =~ /\A\d+\z/ }
  end
end
