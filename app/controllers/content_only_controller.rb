class ContentOnlyController < ApplicationController
  before_action :authenticate_user!, unless: -> { admin_signed_in? || assessor_signed_in? },
                except: [
                  :home,
                  :awards_for_organisations,
                  :how_to_apply,
                  :timeline,
                  :additional_information_and_contact,
                  :privacy,
                  :cookies,
                  :apply_for_queens_award_for_enterprise,
                  :sign_up_complete,
                  :submitted_nomination_successful,
                  :pre_sign_in
                ]

  before_action :get_current_form,
                only: [
                  :award_info_qavs
                ]

  before_action :restrict_access_if_admin_in_read_only_mode!,
                only: [:dashboard]

  before_action :clean_flash, only: [:sign_up_complete]

  expose(:form_answer) do
    current_user.form_answers.find(params[:id])
  end

  expose(:past_applications) do
    current_account.form_answers.submitted.past.group_by(&:award_year)
  end

  expose(:target_award_year) do
    if params[:award_year_id].present?
      AwardYear.find(params[:award_year_id])
    else
      AwardYear.current
    end
  end

  def dashboard
    @user_award_forms = user_award_forms
    @user_award_forms_submitted = @user_award_forms.submitted

    set_unsuccessful_business_applications if Settings.unsuccessful_stage?
  end

  def award_winners_section
    @user_award_forms_submitted = user_award_forms.submitted

    render "content_only/award_winners_section/#{target_award_year.year}"
  end

  private

  def user_award_forms
    current_account.form_answers
                   .where(award_year: target_award_year)
  end

  def get_current_form
    @form_answer = current_account.form_answers.find(params[:form_id])
    @form = @form_answer.award_form.decorate(
      answers: HashWithIndifferentAccess.new(@form_answer.document)
    )
  end

  def clean_flash
    flash.clear
  end

  def set_unsuccessful_business_applications
    @unsuccessful_business_applications = @user_award_forms.unsuccessful_applications
  end
end
