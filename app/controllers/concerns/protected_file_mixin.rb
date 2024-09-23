module ProtectedFileMixin
  extend ActiveSupport::Concern

  def self.included(base)
    base.skip_after_action :verify_authorized
  end

  def show
    file = current_subject.protected_files.find(params[:id])
    file.mark_as_downloaded!
    redirect_to file.file.url, allow_other_host: true
  end
end
