require 'rails_helper'

RSpec.describe FormAnswerAttachment, type: :model do

  describe '.validation' do
    it 'should return error' do
      allow(FormAnswerAttachment).to receive_message_chain(:where, :count).and_return(2)
      form_answer_attachment = build(:form_answer_attachment, question_key: "org_chart")
      form_answer_attachment.valid?
      expect(form_answer_attachment.errors[:base]).to eq ["Maximum amount of these kind of files reached."]
    end
  end
end
