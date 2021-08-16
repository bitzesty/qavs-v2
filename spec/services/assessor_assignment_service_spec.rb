require "rails_helper"

describe AssessorAssignmentService do
  let(:form_answer) { create(:form_answer) }
  let(:primary) { form_answer.assessor_assignments.primary }
  let!(:assessor) { create(:assessor, :lead_for_all) }

  before do
    st = allow_any_instance_of(described_class).to receive(:update_params)
    st.and_return(params[:assessor_assignment])
  end

  subject { described_class.new(params, assessor) }

  # adding assessment to the case
  context "assessment request" do
    let(:params) do
      {
        assessor_assignment: {
          corporate_social_responsibility_desc: "",
          verdict_desc: "this is a verdict"

        },
        id: primary.id
      }.with_indifferent_access
    end

    it "removes the keys with blank value" do
      expect(subject.update_params[:corporate_social_responsibility_desc]).to be_blank
    end

    it "sets the assessed_at" do
      subject.save
      expect(subject.resource.assessed_at).to be_present
    end

    it "stores the assessment data in db" do
      subject.save
      expect(subject.resource.reload.verdict_desc).to eq("this is a verdict")
    end

    context "updated section is commercial_success_desc" do
      let(:params) do
        {
          assessor_assignment: {
            corporate_social_responsibility_desc: "I am description",
            whatever_desc: "asd"
          },
          updated_section: "corporate_social_responsibility_desc",
          id: primary.id
        }.with_indifferent_access
      end

      it "removes the whatever_desc from relevant attrs" do
        subject.save
        expect(subject.update_params).to eq("corporate_social_responsibility_desc" => "I am description")
      end
    end

    context "updated section is commercial_rate" do
      let(:params) do
        {
          assessor_assignment: {
            corporate_social_responsibility_rate: "negative",
            another_rate: "negative",
            strategy_desc: "asd",
            created_at: "text"
          },
          updated_section: "corporate_social_responsibility_rate",
          id: primary.id
        }.with_indifferent_access
      end

      it "removes the not relevant _rate and _desc" do
        subject.save
        expect(subject.update_params).to eq(
          "corporate_social_responsibility_rate" => "negative", "created_at" => "text")
      end
    end

    context "updated section is in invalid attr" do
      let(:params) do
        {
          assessor_assignment: {
            corporate_social_responsibility_desc: "I am description",
            mobility_impact_of_the_programme_desc: "should be saved"
          },
          updated_section: "asd",
          id: primary.id
        }.with_indifferent_access
      end

      it "ignores the updated section attr" do
        subject.save
        expect(subject.update_params).to eq(
          "corporate_social_responsibility_desc" => "I am description",
          "mobility_impact_of_the_programme_desc" => "should be saved")
      end
    end
  end
end
