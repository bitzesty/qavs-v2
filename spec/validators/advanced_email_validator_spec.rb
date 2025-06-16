require 'rails_helper'

RSpec.describe AdvancedEmailValidator do
  let :subject do
    AdvancedEmailValidator.new
  end

  let! :model do
    User.new
  end

  context "with bad e-mail address" do
    it "doesn't allow for a borked e-mail address" do
      expect {
        model.email = '@bad-email'
        subject.validate(model)
      }.to change { model.errors.empty? }
    end

    it "doesn't allow an empty e-mail address" do
      expect {
        model.email = ''
        subject.validate(model)
      }.to change { model.errors.empty? }
    end

    it "doesn't allow an address with a local part only" do
      expect {
        model.email = 'jimmy.harris'
        subject.validate(model)
      }.to change { model.errors.empty? }
    end

    it "doesn't allow domains with a dot at the end" do
      expect {
        model.email = 'feedback@domain.com.'
        subject.validate(model)
      }.to change { model.errors.empty? }
    end

    it "doesn't allow domains with a dot at the beginning" do
      expect {
        model.email = 'feedback@.domain.com'
        subject.validate(model)
      }.to change { model.errors.empty? }
    end
  end

  it "allows correct e-mail addresses", skip: "Sendgrid checks are disabled for now" do
    # Setup validator to skip DNS/bounce checks
    allow(subject).to receive(:validate_dns_records).and_return(false)
    allow(subject).to receive(:validate_bounced).and_return(false)

    expect {
      model.email = 'feedback@lol.biz.info'
      subject.validate(model)
    }.not_to change { model.errors.empty? }
  end

  context "DNS checks for domain" do
    it "checks for the existence of an MX record for the domain", skip: "Sendgrid checks are disabled for now" do
      allow_any_instance_of(Resolv::DNS).to receive(:getresource).and_raise(Resolv::ResolvError)

      expect {
        model.email = 'test@gmail.co.uk'
        subject.validate(model)
      }.to change { model.errors.empty? }
    end

    it "doesn't return an error when the MX lookup timed out", skip: "Sendgrid checks are disabled for now" do
      allow_any_instance_of(Resolv::DNS).to receive(:getresource).and_raise(Resolv::ResolvTimeout)
      allow(subject).to receive(:validate_bounced).and_return(false)

      expect {
        model.email = 'test@irrelevant.com'
        subject.validate(model)
      }.not_to change { model.errors.empty? }
    end
  end

  # context "spam reporters" do
  #   it "prevents validation on an e-mail address marked as a spam reporter in sendgrid" do
  #     expect(subject).to receive(:validate_dns_records).and_return(false)
  #     expect(SendgridHelper).to receive(:spam_reported?).and_return(true)
  #     expect {
  #       model.email = 'test@irrelevant.com'
  #       subject.validate(model)
  #     }.to change { model.errors.empty? }
  #     expect(model.errors.first).to eq([:email, "cannot receive messages from this system"])
  #   end
  # end

  context "bounced addresses" do
    it "prevents validation on an e-mail address marked as bounced in sendgrid", skip: "Sendgrid checks are disabled for now" do
      allow(subject).to receive(:validate_dns_records).and_return(false)
      allow(SendgridHelper).to receive(:bounced?).and_return(true)

      expect {
        model.email = 'test@irrelevant.com'
        subject.validate(model)
      }.to change { model.errors.empty? }
      expect(model.errors.first).to eq([:email, "cannot receive messages from this system"])
    end
  end
end
