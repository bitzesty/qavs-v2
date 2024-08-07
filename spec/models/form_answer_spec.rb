require "rails_helper"

RSpec.describe FormAnswer, type: :model do
  let(:award_year) { create(:award_year, year: 2019) }
  let(:form_answer) { build(:form_answer) }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe 'class methods & scopes ' do
    it ".hard_copy_generated should filter correctly" do
      target = FormAnswer.submitted.where("feedback_hard_copy_generated" => true).to_sql
      expect(target).to eq FormAnswer.hard_copy_generated('feedback').to_sql
    end
  end

  describe "#unsuccessful?" do
    it 'should return correct class' do
      allow_any_instance_of(FormAnswer).to receive(:not_recommended?) {true}
      expect(form_answer.unsuccessful?).to be_truthy
    end
  end

  describe "#head_of_business" do
    it 'should return correct result' do
      form_answer = FormAnswer.new(document: { "head_of_business_first_name" => "foo", "head_of_business_last_name" => "bar" })
      expect(form_answer.head_of_business).to eq "foo bar"
    end
  end

  describe "#whodunnit" do
    it 'should return correct result' do
      user = build(:user)
      request = double(whodunnit: user)
      allow(PaperTrail).to receive(:request) { request }
      expect(form_answer.whodunnit).to eq user
    end
  end

  describe "#shortlisted?" do
    it 'should return correct result' do
      form_answer.state = 'shortlisted'
      expect(form_answer).to be_shortlisted
    end
  end

  describe "#unsuccessful_app?" do
    it 'should return correct result' do
      allow_any_instance_of(FormAnswer).to receive(:awarded?) {false}
      allow_any_instance_of(FormAnswer).to receive(:withdrawn?) {false}
      expect(form_answer.unsuccessful_app?).to be_truthy
    end
  end

  describe "#previous_wins" do
    it 'should return correct result' do
      form_answer.document = { "applied_for_queen_awards_details" => [{ "outcome" => "won", "foo" => "bar" }, { "outcome" => "failed", "lorem" => "ipsum" }] }
      expect(form_answer.previous_wins).to eq [{ "outcome" => "won", "foo" => "bar" }]

      form_answer.document = { "queen_award_holder_details" => "aa" }
      expect(form_answer.previous_wins).to eq "aa"

      form_answer.document = {}
      expect(form_answer.previous_wins).to eq []
    end
  end

  describe "pdf generation" do
    it '#generate_pdf_version! triggers correctly' do
      expect(HardCopyGenerators::FormDataGenerator).to receive_message_chain(:new, :run)
      form_answer.generate_pdf_version!
    end

    it '#generate_pdf_version_from_latest_doc! triggers correctly' do
      expect(HardCopyGenerators::FormDataGenerator).to receive_message_chain(:new, :run)
      form_answer.generate_pdf_version_from_latest_doc!
    end
  end

  describe "validations" do
    %w(user).each do |field_name|
      it {should validate_presence_of field_name}
    end

    it "sets account on creating" do
      form_answer = create(:form_answer)
      expect(form_answer.account).to eq(form_answer.user.account)
    end

    describe "#company_or_nominee_from_document" do
      subject { build(:form_answer, document: doc) }
      let(:c_name) { "nominee name" }

      context "form" do
        let(:doc) { { "nominee_name" => c_name } }

        it "gets the nominee name" do
          expect(subject.company_or_nominee_from_document).to eq(c_name)
        end
      end
    end

    describe "#fill_progress_in_percents" do
      it "returns fill progress as formatted string" do
        form_answer = build(:form_answer, fill_progress: 0.11)
        expect(form_answer.fill_progress_in_percents).to eq("11%")
      end
    end

    describe "#fill_progress" do
      context "100% completed" do
        it "populates correct fill progress for qavs form on save" do
          form_answer = create(:form_answer, award_year: award_year)
          expect(form_answer.fill_progress).to eq(1.0)
        end
      end

      context "not completed" do
        it "populates correct fill progress for qavs form on save" do
          form_answer = create(:form_answer, award_year: award_year)
          form_answer.document = form_answer.document.merge(nominee_name: nil)
          form_answer.save!

          expect(form_answer.fill_progress.round(2)).to eq(0.96)
        end
      end
    end

    describe "state helpers" do
      it "exposes the state as ? method" do
        expect(build(:form_answer, state: "not_awarded")).to be_not_awarded
        expect(build(:form_answer, state: "undecided")).to be_undecided
      end
    end

    describe "unsuccessful_applications" do
      it "excludes awarded form_answers" do
        form_answer = create(:form_answer, :awarded)
        expect(FormAnswer.unsuccessful_applications).not_to include(form_answer)
      end

      it "excludes withdrawn form_answers" do
        form_answer = create(:form_answer, :withdrawn)
        expect(FormAnswer.unsuccessful_applications).not_to include(form_answer)
      end

      it "includes all other form_answers" do
        not_recommended = create(:form_answer, :not_recommended)
        not_awarded = create(:form_answer, :not_awarded)
        reserved = create(:form_answer, :reserved)
        expect(FormAnswer.unsuccessful_applications).to include(not_recommended)
        expect(FormAnswer.unsuccessful_applications).to include(not_awarded)
        expect(FormAnswer.unsuccessful_applications).to include(reserved)
      end
    end
  end

  describe "#active_support_letters" do
    let(:nomination) { create(:form_answer, :submitted) }
    let!(:sl1) { create(:support_letter, user: nomination.user, form_answer: nomination) }
    let!(:sl2) { create(:support_letter, user: nomination.user, form_answer: nomination) }
    let!(:sl3) { create(:support_letter, user: nomination.user, form_answer: nomination) }

    before do
      list = [
        { "support_letter_id" => sl1.id.to_s },
        { "support_letter_id" => sl2.id.to_s }
      ]

      nomination.document = nomination.document.merge("supporter_letters_list" => list)
    end

    it "filters out support letters that are not from the document" do
      expect(nomination.active_support_letters.map(&:id).sort).to eq([sl1.id, sl2.id].sort)
    end
  end
end
