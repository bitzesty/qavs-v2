class SupportLetterAttachment < ApplicationRecord
  mount_uploader :attachment, FormAnswerAttachmentUploader
  scan_file :attachment

  include ::InfectedFileCleaner
  clean_after_scan :attachment

  begin :associations
    belongs_to :user
    belongs_to :form_answer
    belongs_to :support_letter, optional: true
  end

  begin :validations
    validates :form_answer, :user, presence: true
    validates :attachment, presence: true,
                           on: :create,
                           file_size: {
                             maximum: 5.megabytes.to_i
                           }
  end

  begin :callbacks
    before_save :assign_original_filename, if: :will_save_change_to_attachment?
  end

  private

  def assign_original_filename
    self.original_filename = self&.attachment&.identifier
  end
end
