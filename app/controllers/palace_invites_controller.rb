class PalaceInvitesController < ApplicationController
  before_action :load_invite
  before_action :require_palace_invite_to_be_not_submitted_and_proper_stage!

  def update
    if palace_invite_attributes.present? &&
      @invite_form.update(palace_invite_attributes.to_h.merge({ submitted: params[:submit].present? }))
      log_event
      if @invite.submitted?
        flash[:success] = "Palace Attendees details are successfully submitted!"
        redirect_to group_leader_root_path
      else
        flash[:success] = "Attendee details have been successfully updated"
        redirect_to group_leader_root_path
      end
    else
      render :edit
    end
  end

  private

  def load_invite
    @invite = PalaceInvite.find(params[:id]) or raise ActionController::RoutingError.new("Not Found")
    @invite_form = PalaceInviteForm.new(@invite)
  end

  def palace_invite_attributes
    if params[:palace_invite].present?
      params.require(:palace_invite).permit(
        :attendees_consent,
        palace_attendees_attributes: [
          :relationship,
          :title,
          :first_name,
          :last_name,
          :post_nominals,
          :address_1,
          :address_2,
          :address_3,
          :address_4,
          :postcode,
          :disabled_access,
          :preferred_date,
          :alternative_date,
          :id,
          :_remove
        ]
      )
    end
  end

  def require_palace_invite_to_be_not_submitted_and_proper_stage!
    if !Settings.buckingham_palace_invites_stage?(@invite.form_answer.award_year.settings)
      flash.notice = "Access denied!"
      redirect_to group_leader_root_path

      return
    end
  end

  def action_type
    params[:submit] ? "palace_attendee_submit" : "palace_attendee_update"
  end

  def form_answer
    @invite.form_answer
  end
end
