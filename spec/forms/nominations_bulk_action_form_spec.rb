require "rails_helper"

describe NominationsBulkActionForm do
  include Rails.application.routes.url_helpers

  let(:params) { {} }
  subject { described_class.new(params) }

  describe "#valid?" do
    context "when bulk_action is not present" do
      it "adds a bulk_base error and returns false" do
        expect(subject.valid?).to be_falsey
        expect(subject.errors[:bulk_base]).to include("You must select at least one group from the list below before clicking a bulk action button.")
      end
    end

    context "when kind is lieutenants" do
      let(:params) { { bulk_assign_lieutenants: true, bulk_action: { ids: [1, 2, 3] } } }

      it "returns true if bulk_action is present" do
        expect(subject.valid?).to be_truthy
      end
    end

    context "when kind is assessors" do
      let(:params) { { bulk_assign_assessors: true, bulk_action: { ids: [1, 2, 3] } } }

      it "returns true if bulk_action is present" do
        expect(subject.valid?).to be_truthy
      end
    end

    context "when kind is eligibility" do
      let(:params) { { bulk_assign_eligibility: true, bulk_action: { ids: [1, 2, 3] } } }
      let(:valid_form_answer) { double(:form_answer, state: "submitted") }

      before do
        allow(FormAnswer).to receive(:where).with(id: params[:bulk_action][:ids]).and_return([valid_form_answer])
      end

      it "returns true if form_answers are eligible for state change" do
        expect(subject.valid?).to be_truthy
      end

      it "returns false if form_answers are not eligible for state change" do
        invalid_form_answer = double(:form_answer, state: "Invalid state")
        allow(FormAnswer).to receive(:where).with(id: params[:bulk_action][:ids]).and_return([invalid_form_answer])

        expect(subject.valid?).to be_falsey
        expect(subject.errors[:bulk_base]).to include("To assign the eligibility status, you must only select groups that currently have ‘Nomination submitted’ or ‘Eligibility pending’ status.")
      end
    end
  end

  describe "#base_error_messages" do
    it "returns joined base error messages" do
      subject.errors.add(:bulk_base, "Some error message")
      expect(subject.base_error_messages).to eq("Some error message")
    end
  end

  describe "#redirect_url" do
    context "when kind is lieutenants" do
      let(:params) { { bulk_assign_lieutenants: true, bulk_action: { ids: [1, 2, 3] } } }

      it "returns the lieutenants redirect path" do
        expect(subject.redirect_url).to eq(bulk_assign_lieutenants_admin_form_answers_path(params: params))
      end
    end

    context "when kind is assessors" do
      let(:params) { { bulk_assign_assessors: true, bulk_action: { ids: [1, 2, 3] } } }

      it "returns the assessors redirect path" do
        expect(subject.redirect_url).to eq(bulk_assign_assessors_admin_form_answers_path(params: params))
      end
    end

    context "when kind is eligibility" do
      let(:params) { { bulk_assign_eligibility: true, bulk_action: { ids: [1, 2, 3] } } }

      it "returns the eligibility redirect path" do
        expect(subject.redirect_url).to eq(bulk_assign_eligibility_admin_form_answers_path(params: params))
      end
    end

    context "when kind is invalid" do
      let(:params) { { bulk_action: { ids: [1, 2, 3] } } }

      it "raises an error" do
        expect { subject.redirect_url }.to raise_error("Invalid bulk action type.")
      end
    end
  end

  describe "#determine_kind" do
    context "when bulk_assign_lieutenants is present" do
      let(:params) { { bulk_assign_lieutenants: true } }

      it "returns 'lieutenants'" do
        expect(subject.send(:determine_kind)).to eq("lieutenants")
      end
    end

    context "when bulk_assign_assessors is present" do
      let(:params) { { bulk_assign_assessors: true } }

      it "returns 'assessors'" do
        expect(subject.send(:determine_kind)).to eq("assessors")
      end
    end

    context "when bulk_assign_eligibility is present" do
      let(:params) { { bulk_assign_eligibility: true } }

      it "returns 'eligibility'" do
        expect(subject.send(:determine_kind)).to eq("eligibility")
      end
    end
  end

  describe "#save_search_and_clean_params" do
    context "when search params are present and need to be saved" do
      let(:params) { { search: { search_filter: "custom_filter" } } }
      let(:nomination_search) { double(:nomination_search, id: 1) }

      before do
        allow(NominationSearch).to receive(:create).and_return(nomination_search)
      end

      it "saves the search and removes unnecessary params" do
        cleaned_params = subject.send(:save_search_and_clean_params, params)
        expect(cleaned_params[:search_id]).to eq(1)
        expect(cleaned_params[:search]).to be_nil
      end
    end

    context "when search params are the default search filter" do
      let(:params) { { search: { search_filter: FormAnswerSearch.default_search[:search_filter] } } }

      it "does not save search and returns params unchanged" do
        cleaned_params = subject.send(:save_search_and_clean_params, params)
        expect(cleaned_params).to eq(params)
      end
    end
  end
end
