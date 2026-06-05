class Users::FormAnswersController < Users::BaseController
  include FormAnswersPdf

  # Override parent callback since this controller only has :show action
  skip_before_action :restrict_access_if_admin_in_read_only_mode!

  expose(:form_answer) do
    current_user.account
                .form_answers
                .find(params[:id])
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
      AuditLog.create!(subject: current_admin, action_type: "download_form_answer", auditable: form_answer)
    end
  end

  def resource
    form_answer
  end
end
