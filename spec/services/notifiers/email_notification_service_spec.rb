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

  describe "#reminder_to_submit" do
    let(:kind) { "reminder_to_submit" }
    let(:mailer) { double(deliver_later!: true) }

    context "for not submitted aplications" do
      let(:form_answer) do
        create(:form_answer)
      end

      it "triggers current notification" do
        expect(AccountMailers::ReminderToSubmitMailer).to receive(:notify).with(
          form_answer.id
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
          form_answer.id
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
      doc["nominee_name"] = "Odyssey"
      not_submitted.document = doc
      not_submitted.save!

      doc = submitted.document
      doc["nominee_leader_name"] = "Alice Becket"
      doc["nominee_leader_email"] = "alice@example.com"
      doc["nominee_name"] = "Alpha"
      submitted.document = doc
      submitted.save!

      doc = dup_submitted.document
      doc["nominee_leader_name"] = "Alice Becket"
      doc["nominee_leader_email"] = "alice@example.com"
      doc["nominee_name"] = "Alpha"
      dup_submitted.document = doc
      dup_submitted.save!
    end

    it "sends one notification to the submitted group leader" do
      expect(AccountMailers::GroupLeaderMailer).to receive(:notify).with(submitted.id).once { mailer }

      described_class.run

      expect(current_notification.reload).to be_sent
    end
  end

  describe "#local_assessment_notification" do
    let(:kind) { "local_assessment_notification" }
    let(:mailer) { double(deliver_later!: true) }
    let!(:form_answer) { create(:form_answer, :submitted, ceremonial_county: lieutenant.ceremonial_county) }

    context "for advanced lieutenants" do
      let!(:lieutenant) { create(:lieutenant, :advanced) }

      it "triggers current notification" do
        expect(LieutenantsMailers::LocalAssessmentNotificationMailer).to receive(:notify).with(
                                                                      lieutenant.id
                                                                    ) { mailer }

        described_class.run

        expect(current_notification.reload).to be_sent
      end
    end

    context "for regular lieutenants" do
      let!(:lieutenant) { create(:lieutenant) }

      it "does not send a notification" do
        expect(LieutenantsMailers::LocalAssessmentNotificationMailer).not_to receive(:notify).with(
                                                                      lieutenant.id
                                                                    ) { mailer }

        described_class.run

        expect(current_notification.reload).to be_sent
      end
    end
  end


  describe "#local_assessment_reminder" do
    let(:kind) { "local_assessment_reminder" }
    let(:mailer) { double(deliver_later!: true) }
    let!(:form_answer) { create(:form_answer, :submitted, ceremonial_county: lieutenant.ceremonial_county) }

    context "for advanced lieutenants" do
      let!(:lieutenant) { create(:lieutenant, :advanced) }

      it "triggers current notification" do
        expect(LieutenantsMailers::LocalAssessmentReminderMailer).to receive(:notify).with(
                                                                      lieutenant.id
                                                                    ) { mailer }

        described_class.run

        expect(current_notification.reload).to be_sent
      end
    end

    context "for regular lieutenants" do
      let!(:lieutenant) { create(:lieutenant) }

      it "does not send a notification" do
        expect(LieutenantsMailers::LocalAssessmentReminderMailer).to_not receive(:notify).with(
                                                                      lieutenant.id
                                                                    ) { mailer }

        described_class.run

        expect(current_notification.reload).to be_sent
      end
    end
  end

  describe "winners_head_of_organisation_notification" do
    let(:kind) { "winners_head_of_organisation_notification" }
    let(:mailer) { double(deliver_later!: true) }

    context "winning nominations" do
      let!(:form_answer) { create(:form_answer, :awarded) }
      it "triggers current notification" do
        expect(GroupLeadersMailers::WinnersHeadOfOrganisationMailer).to receive(:notify) { mailer }

        expect {
          described_class.run
        }.to change {
          GroupLeader.count
        }

        expect(form_answer.citation).to be

        expect(current_notification.reload).to be_sent
      end
    end

    context "unsuccessful nominations" do
      let!(:form_answer) { create(:form_answer, :not_awarded) }
      it "does not trigger notification" do
        expect(GroupLeadersMailers::WinnersHeadOfOrganisationMailer).to_not receive(:notify) { mailer }

        expect {
          described_class.run
        }.to_not change {
          GroupLeader.count
        }
      end
    end
  end

  describe "unsuccessful_group_leaders_notification" do
    let(:kind) { "unsuccessful_group_leaders_notification" }
    let(:mailer) { double(deliver_later!: true) }

    context "winning nominations" do
      let!(:form_answer) { create(:form_answer, :awarded) }
      it "does not trigger notification" do
        expect(GroupLeadersMailers::NotifyUnsuccessfulNominationsMailer).to_not receive(:notify).with(
                                                                      form_answer.id
                                                                    ) { mailer }
      end
    end

    context "winning nominations" do
      let!(:form_answer) { create(:form_answer, :not_awarded) }
      it "triggers current notification" do
        expect(GroupLeadersMailers::NotifyUnsuccessfulNominationsMailer).to receive(:notify).with(
                                                                      form_answer.id
                                                                    ) { mailer }
        described_class.run

        expect(current_notification.reload).to be_sent
      end
    end
  end

  describe "winners_notifier" do
    let(:kind) { "winners_notification" }
    let(:mailer) { double(deliver_later!: true) }

    context "winning nominations" do
      let!(:form_answer) { create(:form_answer, :awarded) }
      it "triggers current notification" do
        expect(AccountMailers::NotifySuccessfulNominationsMailer).to receive(:notify) { mailer }

        described_class.run

        expect(current_notification.reload).to be_sent
      end
    end

    context "unsuccessful nominations" do
      let!(:form_answer) { create(:form_answer, :awarded) }
      it "does not trigger notification" do
        expect(AccountMailers::NotifySuccessfulNominationsMailer).to_not receive(:notify) { mailer }
      end
    end
  end

  describe "unsuccessful_notification" do
    let(:kind) { "unsuccessful_notification" }
    let(:mailer) { double(deliver_later!: true) }

    context "winning nominations" do
    let(:form_answer) { create(:form_answer, :awarded) }
      it "does not trigger notification" do
        expect(AccountMailers::NotifyUnsuccessfulNominationsMailer).to_not receive(:notify).with(
          form_answer.id
        ) { mailer }
      end
    end

    context "unsuccessful nominations" do
      let(:form_answer) { create(:form_answer, :not_awarded) }
      it "triggers current notification" do
        expect(AccountMailers::NotifyUnsuccessfulNominationsMailer).to receive(:notify).with(
          form_answer.id
        ) { mailer }

        described_class.run

        expect(current_notification.reload).to be_sent
      end
    end
  end

  describe "buckingham_palace_invite" do
    let(:kind) { "buckingham_palace_invite" }
    let(:mailer) { double(deliver_later!: true) }

    context "winning nomination" do
      let!(:form_answer) { create(:form_answer, :awarded) }
      it "triggers current notification" do
        group_leader = GroupLeader.find_by_form_answer_id(form_answer.id)
        expect(GroupLeadersMailers::BuckinghamPalaceInviteMailer).to receive(:invite).with(
          form_answer.id, group_leader.id
        ) { mailer }

        described_class.run

        expect(current_notification.reload).to be_sent
      end
    end

    context "unsuccessful nomination" do
      let!(:form_answer) { create(:form_answer, :not_awarded) }
      it "does not trigger notification" do
        expect(GroupLeadersMailers::BuckinghamPalaceInviteMailer).to_not receive(:invite) { mailer }
      end
    end
  end
end
