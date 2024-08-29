class Users::SupportLettersController < Users::BaseController
  expose(:form_answer) do
    if current_user
      current_user.account.
        form_answers.
        find(params[:form_answer_id])
    elsif current_admin
      FormAnswer.find(params[:form_answer_id])
    end
  end

  expose(:support_letter) do
    form_answer.support_letters.new(
      support_letter_params.merge({
        user_id: current_user&.id || form_answer.user_id,
        manual: true,
        support_letter_attachment: attachment
      })
    )
  end

  expose(:attachment) do
    SupportLetterAttachment.find_by_id(support_letter_params[:attachment])
  end

  skip_before_action :authenticate_user!, if: :current_admin

  def create
    if support_letter.save
      attachment.support_letter = support_letter
      attachment.save!

      render json: { 
        id: support_letter.id, 
        form_answer_id: form_answer.id, 
        update_url: users_form_answer_support_letter_path(form_answer, support_letter) 
      }, status: :created
    else
      render json: support_letter.errors.messages.to_json, status: :unprocessable_entity
    end
  end

  def update
    @support_letter = form_answer.support_letters.find(params[:id])

    if @support_letter.update(support_letter_params)
      attachment.support_letter = @support_letter
      attachment.save!

      SupportLetterAttachment
        .where(support_letter: @support_letter)
        .where.not(id: attachment.id)
        .destroy_all

      render json: { 
        id: @support_letter.id, 
        form_answer_id: form_answer.id, 
        update_url: users_form_answer_support_letter_path(form_answer, @support_letter) 
      }, status: :ok
    else
      render json: @support_letter.errors.messages.to_json, status: :unprocessable_entity
    end
  end

  def show
    @support_letter = form_answer.support_letters.find(params[:id])
  end

  def destroy
    @support_letter = form_answer.support_letters.find(params[:id])
    @support_letter.destroy

    if request.xhr?
      head :ok
    else
      flash[:notice] = "Support letter have been successfully destroyed"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def support_letter_params
    params.require(:support_letter).permit(
      :first_name,
      :last_name,
      :relationship_to_nominee,
      :attachment
    )
  end
end
