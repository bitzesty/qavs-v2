class Form::SupportLetterAttachmentsController < Form::BaseController
  include FormAnswerSubmissionMixin
  before_action :set_support_letter

  def show; end

  def destroy
    attachment = SupportLetterAttachment.find(params[:id])
    form_answer = attachment.form_answer

    if attachment.destroy
      updated_list = form_answer.document['supporter_letters_list'].reject { |letter| letter['letter_of_support'] == attachment.id }
      form_answer.update(document: form_answer.document.merge(supporter_letters_list: updated_list))

      flash[:notice] = 'Attachment successfully deleted.'
    else
      flash[:alert] = 'Failed to delete attachment.'
    end

    redirect_to form_form_answer_supporters_path(form_answer)
  end

  private

  def set_support_letter
    @support_letter = SupportLetter.find(params[:support_letter_id])
    @form_answer = @support_letter.form_answer
  end
end
