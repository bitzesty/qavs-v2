require "rails_helper"

describe MailRenderer do
  describe "#submission_started_notification" do
    let(:login_link) do
      "https://apply.kavs.dcms.gov.uk/users/sign_in"
    end

    let(:user_full_name) do
      "Jon Doe"
    end

    let(:rendered_email) do
      described_class.new(AwardYear.current).submission_started_notification
    end

    it "renders e-mail" do
      expect(rendered_email).to match(user_full_name)
      expect(rendered_email).to match(login_link)
    end
  end

  describe "#reminder_to_submit" do
    it "renders e-mail" do
      Settings.current_submission_deadline.update(trigger_at: 10.days.ago)
      link = "https://apply.kavs.dcms.gov.uk/form/0"
      rendered = described_class.new(AwardYear.current).reminder_to_submit
      expect(rendered).to match(link)
    end
  end

  describe "#group_leader_notification" do
    it "renders e-mail" do
      rendered = described_class.new(AwardYear.current).group_leader_notification
      expect(rendered).to match("Jane Campton")
    end
  end

  describe "#local_assessment_notification" do
    it "renders e-mail" do
      link = "https://apply.kavs.dcms.gov.uk/lieutenant/form_answers"
      rendered = described_class.new(AwardYear.current).local_assessment_notification
      expect(rendered).to match(link)
    end
  end

  describe "#local_assessment_reminder" do
    it "renders e-mail" do
      Settings.current_local_assessment_submission_deadline.update(trigger_at: 10.days.ago)
      link = "https://apply.kavs.dcms.gov.uk/lieutenant/form_answers"
      rendered = described_class.new(AwardYear.current).local_assessment_reminder
      expect(rendered).to match(link)
    end
  end

  describe "#winners_head_of_organisation_notification" do
    it "renders e-mail" do
      link = "https://apply.kavs.dcms.gov.uk/group_leaders/password/edit?reset_password_token=securetoken"
      rendered = described_class.new(AwardYear.current).winners_head_of_organisation_notification
      expect(rendered).to match("Jane Doe")
      expect(rendered).to match("Synergy")
      expect(rendered).to include(link)
    end
  end

  describe "#unsuccessful_group_leaders_notification" do
    it "renders e-mail" do
      rendered = described_class.new(AwardYear.current).unsuccessful_group_leaders_notification
      expect(rendered).to match("Massive Dynamic")
    end
  end

  describe "#successful_nominations_notification" do
    it "renders e-mail" do
      link = "https://apply.kavs.dcms.gov.uk/awardees"
      rendered = described_class.new(AwardYear.current).winners_notification
      expect(rendered).to match(link)
      expect(rendered).to match("Synergy")
    end
  end

  describe "#unsuccessful_notification" do
    it "renders e-mail" do
      link = "https://www.gov.uk/honours"
      rendered = described_class.new(AwardYear.current).unsuccessful_notification
      expect(rendered).to match "Massive Dynamic"
      expect(rendered).to match link
    end
  end

  describe "#buckingham_palace_invite" do
    it "renders e-mail" do
      Settings.current_palace_reception_attendee_information_deadline.update(trigger_at: 10.days.from_now)
      link = "https://apply.kavs.dcms.gov.uk/group_leader"
      rendered = described_class.new(AwardYear.current).buckingham_palace_invite
      expect(rendered).to match(link)
      expect(rendered).to match("Jane Doe")
    end
  end

  def deadline_str(format="%d/%m/%Y")
    DateTime.new(Date.current.year, 9, 21, 10, 30)
            .strftime(format)
  end
end
