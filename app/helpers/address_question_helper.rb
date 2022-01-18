module AddressQuestionHelper
  def add_required_class?(question, sub_field_key)
    question.required_sub_fields.any? { |f| f[sub_field_key] } ? " required" : " not-required"
  end
end
