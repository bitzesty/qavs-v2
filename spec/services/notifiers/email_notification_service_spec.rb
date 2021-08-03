require "rails_helper"

describe Notifiers::EmailNotificationService do
  let!(:sent_notification) do
    create(:email_notification, trigger_at: Time.now - 1.day, sent: true, kind: kind)
  end

  let!(:current_notification) do
    create(:email_notification, trigger_at: Time.now - 1.day, kind: kind)
  end

  let!(:future_notification) do
    create(:email_notification, trigger_at: Time.now + 1.day, kind: kind)
  end

  let(:user) do
    form_answer.user
  end

  context "not_shortlisted_notifier" do
    let(:kind) { "not_shortlisted_notifier" }
    let(:form_answer) { create(:form_answer, state: "not_recommended") }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(AccountMailers::NotifyNonShortlistedMailer).to receive(:notify).with(
        form_answer.id,
        user.id
      ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "shortlisted_notifier" do
    let(:kind) { "shortlisted_notifier" }
    let(:form_answer) { create(:form_answer, state: "recommended") }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(AccountMailers::NotifyShortlistedMailer).to receive(:notify).with(
        form_answer.id,
        user.id
      ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "winners_notifier" do
    let(:kind) { "winners_notification" }
    let(:form_answer) { create(:form_answer, :awarded) }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(AccountMailers::BusinessAppsWinnersMailer).to receive(:notify).with(
        form_answer.id,
        user.id
      ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  describe "#reminder_to_submit" do
    let(:kind) { "reminder_to_submit" }
    let(:mailer) { double(deliver_later!: true) }

    context "for not submitted aplications" do
      let(:form_answer) do
        create(:form_answer)
      end

      it "triggers current notification" do
        expect(AccountMailers::ReminderToSubmitMailer).to receive(:notify).with(
          form_answer.id,
          user.id
        ) { mailer }

        described_class.run

        expect(current_notification.reload).to be_sent
      end
    end

    context "for submitted aplications" do
      let(:form_answer) do
        create(:form_answer, :submitted)
      end

      it "does not send email notification" do
        expect(AccountMailers::ReminderToSubmitMailer).not_to receive(:notify).with(
          form_answer.id,
          user.id
        ) { mailer }

        described_class.run

        expect(current_notification.reload).to be_sent
      end
    end
  end

  describe "#group_leader_notification" do
    let!(:not_submitted) { create(:form_answer) }
    let!(:submitted) { create(:form_answer, :submitted) }
    let!(:dup_submitted) { create(:form_answer) }

    let(:kind) { "group_leader_notification" }
    let(:mailer) { double(deliver_later!: true) }


    before do
      doc = not_submitted.document
      doc["nominee_leader_name"] = "Rob Becket"
      doc["nominee_leader_email"] = "rob@example.com"
      not_submitted.document = doc
      not_submitted.save!

      doc = submitted.document
      doc["nominee_leader_name"] = "Alice Becket"
      doc["nominee_leader_email"] = "alice@example.com"
      submitted.document = doc
      submitted.save!

      doc = dup_submitted.document
      doc["nominee_leader_name"] = "Alice Becket"
      doc["nominee_leader_email"] = "alice@example.com"
      dup_submitted.document = doc
      dup_submitted.save!
    end

    it "sends one notification to the submitted group leader" do
      expect(AccountMailers::GroupLeaderMailer).to receive(:notify).with("alice@example.com", "Alice Becket").once { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  describe "#local_assessment_notification" do
    let(:kind) { "local_assessment_notification" }
    let(:mailer) { double(deliver_later!: true) }

    let!(:lieutenant) { create(:lieutenant) }
    let!(:form_answer) { create(:form_answer, :submitted, ceremonial_county: lieutenant.ceremonial_county) }

    it "triggers current notification" do
      expect(LieutenantMailers::LocalAssessmentNotificationMailer).to receive(:notify).with(
                                                                    lieutenant.id
                                                                  ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end


  describe "#local_assessment_reminder" do
    let(:kind) { "local_assessment_reminder" }
    let(:mailer) { double(deliver_later!: true) }

    let!(:lieutenant) { create(:lieutenant) }

    it "triggers current notification" do
      expect(LieutenantMailers::LocalAssessmentReminderMailer).to receive(:notify).with(
                                                                    lieutenant.id
                                                                  ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "unsuccessful_notification" do
    let(:kind) { "unsuccessful_notification" }

    let(:form_answer) { create(:form_answer, :submitted, state: "not_awarded") }

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(AccountMailers::UnsuccessfulFeedbackMailer).to receive(:notify).with(
        form_answer.id,
        user.id
      ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  context "winners_head_of_organisation_notification" do
    let(:kind) { "winners_head_of_organisation_notification" }
    let(:user) { create(:user) }

    let(:form_answer) do
      create(:form_answer, :awarded)
    end

    it "triggers current notification" do
      mailer = double(deliver_later!: true)
      expect(Users::WinnersHeadOfOrganisationMailer).to receive(:notify).with(
        form_answer.id
      ) { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end
end
