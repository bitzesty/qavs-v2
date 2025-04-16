require 'rails_helper'

RSpec.describe 'Content Security Policy', type: :request do
  it 'sets the expected CSP headers' do
    get '/test'

    csp_header = response.headers['Content-Security-Policy']
    expect(csp_header).to be_present

    # Check default-src
    expect(csp_header).to include("default-src 'self'")

    # Check script-src
    expect(csp_header).to include("script-src 'self' 'strict-dynamic' 'unsafe-inline'")

    # Check style-src
    expect(csp_header).to include("style-src 'self' 'unsafe-inline'")

    # Check object-src
    expect(csp_header).to include("object-src 'none'")

    # Check img-src
    expect(csp_header).to include("img-src 'self' https: data:")

    # Check connect-src
    expect(csp_header).to include("connect-src 'self' https:")

    # Check frame-src
    expect(csp_header).to include("frame-src 'self'")
  end

  if Rails.env.development?
    it 'sets report-only mode in development' do
      get '/test'
      expect(response.headers['Content-Security-Policy-Report-Only']).to be_present
    end
  else
    it 'enforces CSP in non-development environments' do
      get '/test'
      expect(response.headers['Content-Security-Policy']).to be_present
      expect(response.headers['Content-Security-Policy-Report-Only']).to be_nil
    end
  end
end
