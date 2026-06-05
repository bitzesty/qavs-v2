class FormAwardEligibilitiesController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_user!
  before_action :set_form_answer
  before_action :set_steps_and_eligibilities, :setup_wizard
  before_action :restrict_access_if_admin_in_read_only_mode!, only: [
    :update
  ]

  def show
    #    if award eligibility is not passed
    #      and there's no basic eligibility
    #      or basic eligibility is not eligible
    #      and there's no step

    if !params[:id] &&
      (@basic_eligibility && (@basic_eligibility.eligible? || @basic_eligibility.answers.none?))

      step = nil

      if @basic_eligibility &&
        (@basic_eligibility.answers.none? ||
         @basic_eligibility.questions.size != @basic_eligibility.answers.size)

        step = @basic_eligibility.questions.first
      end

      if step
        redirect_to action: :show, form_id: @form_answer.id, id: step, skipped: false
        return
      end
    end

    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
  end

  def update
    @eligibility.current_step = step
    @form = @form_answer.award_form.decorate(answers: HashWithIndifferentAccess.new(@form_answer.document))
    if @eligibility.update(eligibility_params)
      if @eligibility.any_error_yet?
        @form_answer.state_machine.perform_simple_transition("not_eligible")
      else
        @form_answer.state_machine.after_eligibility_step_progress
      end

      if step == @eligibility.questions.last
        @eligibility.pass!
      end

      if params[:skipped] == "false"
        set_steps_and_eligibilities
        setup_wizard

        if @eligibility.eligible_on_step?(step)
          redirect_to next_wizard_path(form_id: @form_answer.id, skipped: false)
        else
          redirect_to action: :show, form_id: @form_answer.id
        end
      else
        redirect_to action: :show, form_id: @form_answer.id
      end

      return
    else
      render :show
    end
  end

  def result
    if @form_answer.eligible?
      redirect_to edit_form_url(@form_answer)
    else
      redirect_to public_send("#{@form_answer.award_type}_award_eligible_failure_path", form_id: @form_answer.id)
    end

    return
  end

  private

  def set_form_answer
    @form_answer = current_account.form_answers.find(params[:form_id])
  end

  def set_steps_and_eligibilities
    builder = FormAnswer::AwardEligibilityBuilder.new(@form_answer)
    @basic_eligibility =  builder.basic_eligibility

    @eligibility = @basic_eligibility
    basic_steps = []
    found = false
    @basic_eligibility.questions.each do |question|
      if found || (params[:id] && question == params[:id].to_sym)
        basic_steps << question
        found = true
      end
    end

    basic_steps = @basic_eligibility.questions unless basic_steps.any?

    self.steps = basic_steps
  end

  def eligibility_params
    if params[:eligibility]
      params.require(:eligibility).permit(*@eligibility.questions)
    else
      {}
    end
  end
end
