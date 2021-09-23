require "rails_helper"

describe MailRenderer do
  describe "#submission_started_notification" do
    let(:login_link) do
      "https://apply.qavs.dcms.gov.uk/users/sign_in"
    end

    let(:user_full_name) do
      "Jon Doe"
    end

    let(:rendered_email) do
      described_class.new.submission_started_notification
    end

    it "renders e-mail" do
      expect(rendered_email).to match(user_full_name)
      expect(rendered_email).to match(login_link)
    end
  end

  describe "#shortlisted_notifier" do
    it "renders e-mail" do
      rendered = described_class.new.shortlisted_notifier
      expect(rendered).to match("Jon Doe")
    end
  end

  describe "#not_shortlisted_notifier" do
    it "renders e-mail" do
      rendered = described_class.new.not_shortlisted_notifier
      expect(rendered).to match("Jon Doe")
    end
  end

  describe "#reminder_to_submit" do
    it "renders e-mail" do
      Settings.current_submission_deadline.update(trigger_at: 10.days.ago)
      link = "https://apply.qavs.dcms.gov.uk/form/0"
      rendered = described_class.new.reminder_to_submit
      expect(rendered).to match(link)
    end
  end

  describe "#group_leader_notification" do
    it "renders e-mail" do
      rendered = described_class.new.group_leader_notification
      expect(rendered).to match("Jane Campton")
    end
  end

  describe "#local_assessment_notification" do
    it "renders e-mail" do
      link = "https://apply.qavs.dcms.gov.uk/lieutenant/form_answers"
      rendered = described_class.new.local_assessment_notification
      expect(rendered).to match(link)
    end
  end

  describe "#local_assessment_reminder" do
    it "renders e-mail" do
      Settings.current_local_assessment_submission_deadline.update(trigger_at: 10.days.ago)
      link = "https://apply.qavs.dcms.gov.uk/lieutenant/form_answers"
      rendered = described_class.new.local_assessment_reminder
      expect(rendered).to match(link)
    end
  end

  describe "#unsuccessful_notification" do
    it "renders e-mail" do
      rendered = described_class.new.unsuccessful_notification
      expect(rendered).to match("Mr Smith")
      expect(rendered).to match("QA0001/16I")
    end
  end

  describe "#unsuccessful_ep_notification" do
    it "renders e-mail" do
      rendered = described_class.new.unsuccessful_ep_notification
      expect(rendered).to match("Jon Doe")
      expect(rendered).to match("Nominee Name")
    end
  end

  describe "#winners_notification" do
    it "renders e-mail" do
      rendered = described_class.new.winners_notification
      expect(rendered).to match("Jane Doe")
      expect(rendered).to match("Everyday Charity")
      expect(rendered).to include("https://apply.qavs.dcms.gov.uk/group_leaders/password/edit?reset_password_token=tpscrttkn")

      # expect(rendered).to match(deadline_str("%A %d %B %Y"))
    end
  end

  describe "#winners_head_of_organisation_notification" do
    it "renders e-mail" do
      rendered = described_class.new.winners_head_of_organisation_notification
      expect(rendered).to match("Congratulations on winning a Queen's Award")
    end
  end

  def deadline_str(format="%d/%m/%Y")
    DateTime.new(Date.current.year, 9, 21, 10, 30)
            .strftime(format)
  end
end
