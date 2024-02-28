require 'rails_helper'

RSpec.describe GroupLeader, type: :model do
  subject {build(:group_leader)}

  describe "associations" do
    it { should belong_to(:form_answer).optional }
  end

  it 'has valid a factory' do
    expect(subject).to be_valid
  end
end
