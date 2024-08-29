class Form::SupportLettersController < Form::BaseController
  include FormAnswerSubmissionMixin

  def create
    @form_answer.support_letters_attributes = permitted_params["support_letters_attributes"]
    @form_answer.document = prepare_doc if params[:form].present?
    
    if @form_answer.valid? && @form_answer.save
      add_support_letters_to_document!

      if params[:next_step_id]
        redirect_to edit_form_url(@form_answer, step: params[:next_step_id])
      else
        redirect_to form_form_answer_supporters_path(@form_answer)
      end
    else
      @step = @form.steps.detect { |s| s.opts[:id] == :letters_of_support_step }

      render "form/supporters/index"
    end
  end

  private

  def permitted_params
    params.require(:form_answer).permit(
      support_letters_attributes: [
        :id, 
        :first_name, 
        :last_name, 
        :relationship_to_nominee,
        :user_id,
        :manual, 
        support_letter_attachment_attributes: [
          :id,
          :attachment, 
          :attachment_cache, 
          :form_answer_id, 
          :user_id
        ]
      ]
    )
  end

  def add_support_letters_to_document!
    list = @form_answer.support_letters.each_with_object([]) do |support_letter, memo|
      memo << Hash[].tap do |h|
        h[:support_letter_id] = support_letter.id
        h[:first_name] = support_letter.first_name
        h[:last_name] = support_letter.last_name
        h[:relationship_to_nominee] = support_letter.relationship_to_nominee
        h[:letter_of_support] = support_letter.support_letter_attachment&.id
      end
    end

    @form_answer.document = @form_answer.document.merge(supporter_letters_list: list, manually_upload: "yes")
    @form_answer.save!
  end
end
