require "rails_helper"

describe AssessorAssignment do
  let(:form) {AppraisalForm}

  describe "rates" do
    context "rag section" do
      context "with not allowed value" do
        subject do
          build :assessor_assignment,
                :qavs,
                verdict_rate: "invalid"
        end
        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors.attribute_names).to include(:verdict_rate)
        end
      end
    end

    context "with allowed value" do
      subject do
        build :assessor_assignment,
              :qavs,
              verdict_rate: "recommended"
      end
      it "is valid" do
        expect(subject).to be_valid
      end
    end
  end

  describe '#locked?' do
    it 'should return false' do
      expect((build :assessor_assignment, locked_at: nil).locked?).to be_falsey
    end
    it 'should return true' do
      expect((build :assessor_assignment, locked_at: 1.minute.ago).locked?).to be_truthy
    end
  end
end

def build_assignment_with(meth)
  obj = build(:assessor_assignment)
  obj.public_send("#{form.desc(meth)}=", "123")
  obj
end
