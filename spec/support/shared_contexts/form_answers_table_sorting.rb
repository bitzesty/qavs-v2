require "rails_helper"

shared_context "form answers table sorting" do |header_position|
  context "Company/Nominee" do
    let(:asc_company_names) do
      FormAnswer.pluck(:company_or_nominee_name).sort
    end

    context "by default" do
      it "sorts by Company column ascending" do
        expect(column_values(header_position)).to eq(asc_company_names)
      end
    end

    it "sorts by Company/Nominee header" do
      click_header("Group name")
      expect(column_values(header_position)).to eq(asc_company_names.reverse)

      click_header("Group name")
      expect(column_values(header_position)).to eq(asc_company_names)
    end
  end
end

def column_values(column_number)
  within ".applications-table" do
    all("tbody tr").map do |tr|
      tr.all("th, td")[column_number].text
    end
  end
end

def click_header(name)
  find("th.sortable", text: name).find("a").click
end
