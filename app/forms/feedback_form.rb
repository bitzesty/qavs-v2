class FeedbackForm
  def self.fields
    keys = AppraisalForm::SUPPORTED_YEARS.map do |year|
      AppraisalForm.const_get("ALL_FORMS_#{year}").map do |form|
        form.keys
      end.flatten
    end.flatten

    keys = filtered_fields(keys).uniq

    ["overall_summary"] +
    keys.map { |k| ["#{k}_strength", "#{k}_weakness"] }.flatten
  end

  def self.fields_for_award_type(form_answer)
    keys = {}

    year = form_answer.award_year.year
    type = form_answer.award_type

    AppraisalForm.const_get("#{type.upcase}_#{year}").each do |k, v|
      keys[k] = { label: v[:label], type: v[:type] }
    end

    filtered_fields(keys)
  end

  def self.filtered_fields(fields)
    fields.delete_if { |k| k == :verdict }
  end

  def self.strength_options_for(feedback, field)
    year = (feedback.award_year || feedback.form_answer.award_year).year

    options = AppraisalForm.const_get("STRENGTH_OPTIONS_#{year}")

    option = options.detect do |opt|
      opt[1] == feedback.document["#{field}_rate"]
    end || ["Select Key Strengths and Focuses", "blank"]

    OpenStruct.new(
      options: options,
      option: option
    )
  end
end
