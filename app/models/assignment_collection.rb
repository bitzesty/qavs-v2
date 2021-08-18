class AssignmentCollection
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :form_answer_ids, String

  attr_accessor :subject

  def persisted?
    false
  end

  private

  def form_answers
    @form_answers ||= FormAnswer.where(id: ids)
  end

  def ids
    form_answer_ids.split(",").select { |i| i =~ /\A\d+\z/ }
  end
end
