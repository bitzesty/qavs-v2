class Users::FormAnswersController < Users::BaseController
  include FormAnswersPdf

  expose(:form_answer) do
    current_user.account
                .form_answers
                .find(params[:id])
  end

  before_action do
    allow_assessor_access!(form_answer)
  end

  before_action :log_download_action, only: :show

  def show
    if can_render_pdf_on_fly?
      respond_to do |format|
        format.pdf do
          pdf = form_answer.decorate.pdf_generator(current_subject, pdf_blank_mode)
          send_data pdf.render,
                    filename: form_answer.decorate.pdf_filename,
                    type: "application/pdf",
                    disposition: 'attachment'
        end
      end
    else
      render_hard_copy_pdf
    end
  end

  private

  def log_download_action
    if admin_in_read_only_mode?
      subject = if admin_signed_in?
        current_admin
      else
        current_assessor
      end

      AuditLog.create!(subject: subject, action_type: "download_form_answer", auditable: form_answer)
    end
  end

  def resource
    form_answer
  end
end
