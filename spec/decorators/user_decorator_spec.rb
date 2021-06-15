require "rails_helper"

describe UserDecorator do
  let(:user) { User.new(
    first_name: 'Foo',
    last_name: 'Bar',
    company_name: 'Umbrella Corporation'
  )}

  let(:subject) { UserDecorator.decorate(user) }


  describe "#general_info" do
    it 'returns company name and full name' do
      expect(subject.general_info).to eq("#{user.company_name}: #{user.full_name}")
    end

  end

  describe "#general_info_print" do
    context 'when company name is present' do
      it 'returns a HTML b tag with company name and full name in capital letters' do
        expect(subject.general_info_print).to eq("<b>#{user.company_name.upcase}:</b> #{user.full_name.upcase}")
      end
    end

    context 'without company name' do
      it 'returns user full_name' do
        user.company_name = nil
        subject = UserDecorator.decorate(user)
        expect(subject.general_info_print).to eq(user.full_name.upcase)
      end
    end
  end

  describe "#applicant_info_print" do
    context 'without company name' do
      it 'returns user full name' do
        user.company_name = nil
        subject = UserDecorator.decorate(user)
        expect(subject.applicant_info_print).to eq(user.full_name)
      end
    end

    context 'with company name present' do
      it 'returns company name value' do
        expect(subject.applicant_info_print).to eq(user.company_name)
      end
    end
  end

  describe "#confirmation_status" do
    context 'when not confirmed' do
      it 'returns pending' do
        expect(subject.confirmation_status).to eq(' (Pending)')
      end
    end

    context 'when already confirmed' do
      it 'returns false' do
        user.confirmed_at = Time.now
        subject = UserDecorator.decorate(user)
        expect(subject.confirmation_status).to be_falsy
      end
    end
  end

  describe "#full_name_with_status" do
    it 'returns full name and confirmation status' do
      expect(subject.full_name_with_status).to eq("#{user.full_name} (Pending)")
    end
  end

  describe "#company" do
    context 'without company_name' do
      it 'returns a span HTML class with N/A as a content' do
        user.company_name = nil
        subject = UserDecorator.decorate(user)
        expect(subject.company).to eq('<span class="text-muted">N/A</span>'.html_safe)
      end
    end

    context 'with a valid company name' do
      it 'returns company_name value' do
        expect(subject.company).to eq(user.company_name)
      end
    end
  end
end
