class TestController < ApplicationController
  def index
    @sanitized_content = QavsSanitizer.new.sanitize(params[:content]) if params[:content].present?
    render plain: @sanitized_content || "No content provided"
  end
end
