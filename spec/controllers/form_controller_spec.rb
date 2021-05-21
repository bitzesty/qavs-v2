require 'rails_helper'

describe FormController do
  let!(:award_year) { AwardYear.current }
  let(:user) { create :user, :completed_profile, role: "account_admin" }
  let(:account) { user.account }
  let!(:collaborator) { create :user, :completed_profile, role: "regular", account: account }
  let(:form_answer) do
    create :form_answer,
           user: user,
           account: account,
           award_year: award_year
  end

  let!(:settings) { create(:settings, :submission_deadlines) }

  before do
    create :basic_eligibility, account: account

    sign_in user
    described_class.skip_before_action :check_basic_eligibility, :check_award_eligibility, :check_account_completion, raise: false
  end

  it 'sends email after submission' do
    expect_any_instance_of(FormAnswer).to receive(:eligible?).at_least(:once).and_return(true)
    notifier = double
    expect(notifier).to receive(:run)
    expect(Notifiers::Submission::SuccessNotifier).to receive(:new).with(form_answer) { notifier }

    post :save, params: {
      id: form_answer.id,
      form: form_answer.document,
      current_step_id: form_answer.award_form.steps.last.title.parameterize,
      submit: "true"
    }
  end

  describe '#new_qavs_form' do
    it 'allows to open mobility form' do
      expect(get :new_qavs_form).to redirect_to(edit_form_url(FormAnswer.last))
    end
  end

  context "individual deadlines" do
    describe '#new_social_mobility_form' do
      it "allows to create an application if deadline has passed" do
        expect(get :new_qavs_form).to redirect_to(edit_form_url(FormAnswer.last))
      end

      it "does not allow to create an application if start deadline has not passed" do
        Settings.current.deadlines.submission_start.update_column(:trigger_at, Time.zone.now + 1.day)
        expect(get :new_qavs_form).to redirect_to(dashboard_url)
      end
    end
  end
end
