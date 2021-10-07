require 'rails_helper'

RSpec.describe PalaceInvite, type: :model do
  subject {build(:palace_invite)}

  describe "associations" do
    it { should belong_to(:form_answer) }
    it { should have_many(:palace_attendees) }
  end

  it 'has valid a factory' do
    expect(subject).to be_valid
  end
end
