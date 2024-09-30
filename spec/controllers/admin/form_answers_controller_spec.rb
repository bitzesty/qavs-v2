require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe Admin::FormAnswersController do
  let!(:admin) { create(:admin) }

  before do
    sign_in admin
  end

  describe "GET index" do
    context "search serialisation" do
      it "serializes search params" do
        expect {
          get :index, params: { search: { sort: "company_or_nominee_name.asc" } }
        }.to change {
          NominationSearch.count
        }.by(1)

        q = NominationSearch.order(:id).last.serialized_query

        expect(JSON.parse(q)["sort"]).to eq("company_or_nominee_name.asc")
      end
    end

    context "search deserialisation" do
      it "deserializes search params" do
        search = NominationSearch.create(serialized_query: { sort: "company_or_nominee_name.asc" }.to_json)
        expect {
          get :index, params: { search_id: search.id, year: "all_years" }
        }.not_to change {
          NominationSearch.count
        }

        expect(assigns(:search).ordered_by).to eq("company_or_nominee_name")
        expect(assigns(:search).ordered_desc).to eq(false)
      end

      it "deserializes search params" do
        search = NominationSearch.create(serialized_query: { sort: "company_or_nominee_name.desc" }.to_json)

        expect {
          get :index, params: { search_id: search.id, year: "all_years" }
        }.not_to change {
          NominationSearch.count
        }

        expect(assigns(:search).ordered_by).to eq("company_or_nominee_name")
        expect(assigns(:search).ordered_desc).to eq(true)
      end
    end
  end
end
