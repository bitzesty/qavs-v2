require 'rails_helper'

RSpec.describe Citation, type: :model do
  subject {build(:citation)}

  describe "associations" do
    it { should belong_to(:form_answer) }
  end

  it 'has valid a factory' do
    expect(subject).to be_valid
  end
end
