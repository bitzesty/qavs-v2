class FormAnswer
  class AwardEligibilityBuilder
    attr_reader :form_answer, :account

    def initialize(form_answer)
      @form_answer = form_answer
      @account = form_answer.user.account
    end

    def eligibility
      unless form_answer.form_basic_eligibility
        form_answer.build_form_basic_eligibility(account_id: account.id).save!
      end

      form_answer.form_basic_eligibility
    end

    def basic_eligibility
      @basic_eligibility ||= begin
        if form_answer.form_basic_eligibility.try(:persisted?)
          form_answer.form_basic_eligibility
        else
          form_answer.build_form_basic_eligibility(filter(account.basic_eligibility.try(:attributes) || {}).merge(account_id: account.id)).save!
          form_answer.form_basic_eligibility
        end
      end
    end

    private

    def filter(params)
      params.except("id", "created_at", "updated_at")
    end
  end
end
