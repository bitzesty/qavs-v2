module FormAnswerSubmissionMixin
  def prepare_doc
    allowed_params = updating_step.allowed_questions_params_list(params[:form])
    @form_answer.document.merge(prepare_doc_structures(allowed_params))
  end

  def prepare_doc_structures(doc)
    result = {}

    doc.each do |(k, v)|
      if v.is_a?(Hash)
        if doc[k]["array"] == "true"
          v.values.each do |value|
            result[k] ||= []

            if value.is_a?(Hash)
              result[k] << value
            end
          end
        else
          result[k] = v
        end
      else
        result[k] = v
      end
    end

    result
  end

  def updating_step
    @form_answer.award_form.steps.detect do |s|
      s.title_to_param == params[:current_step_id].gsub("step-", "")
    end.decorate
  end
end
