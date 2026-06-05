class Users::SupportLetterAttachmentsController < Users::BaseController
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [:create]

  expose(:form_answer) do
    if current_user
      current_user.account.
        form_answers.
        find(params[:form_answer_id])
    elsif current_admin
      FormAnswer.find(params[:form_answer_id])
    end
  end

  expose(:support_letter_attachment) do
    form_answer.support_letter_attachments.new(
      support_letter_attachment_params.merge({
        user_id: current_user.try(:id) || form_answer.user_id,
        original_filename: original_filename
      })
    )
  end

  skip_before_action :authenticate_user!, if: :current_admin

  def create
    if support_letter_attachment.save
      # text/plain content type is needed for jquery.fileupload
      render json: support_letter_attachment,
             status: :created,
             content_type: "text/plain"
    else
      render json: { errors: support_letter_attachment.errors.full_messages }.to_json,
             status: :unprocessable_entity
    end
  end

  private

  def support_letter_attachment_params
    {
      attachment: params[:form][:supporter_letters_list].to_unsafe_h.first[1][:letter_of_support]
    }
  end

  def original_filename
    support_letter_attachment_params[:attachment].try(:original_filename)
  end

  def humanized_errors
    support_letter_attachment.errors
      .full_messages
      .reject { |m| m == "Attachment This field cannot be blank" }
      .join(", ")
      .gsub("Attachment ", "")
  end
end
