require 'rails_helper'

RSpec.describe PalaceInviteForm, type: :model do
  subject { build(:palace_invite_form) }

  it 'has valid a factory' do
    expect(subject).to be_valid
  end
end
