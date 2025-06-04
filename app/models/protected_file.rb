class ProtectedFile < ApplicationRecord
  mount_uploader :file, ProtectedFileUploader

  belongs_to :entity, polymorphic: true

  validates :entity_type, inclusion: { in: %w(Admin Assessor GroupLeader Lieutenant User) }, presence: true
  validates :entity_id, presence: true

  before_create :generate_uuid
  after_create :cleanup_tempfile

  def mark_as_downloaded!
    touch(:last_downloaded_at)
  end

  def self.build_from_raw_data(data, filename, **attrs)
    @file = Tempfile.new([get_basename(filename), get_extname(filename)])
    @file.write(data)
    @file.close

    self.build(
      file: @file,
      **attrs
    )
  end

  def self.create_from_raw_data(data, filename, **attrs)
    build_from_raw_data(data, filename, **attrs).tap do |record|
      record.save
    end
  end

  private

  def generate_uuid
    self.id = SecureRandom.uuid if id.blank?
  end

  def cleanup_tempfile
    @file.unlink if @file
  end

  def self.get_basename(filename)
    File.basename(filename, get_extname(filename))
  end
  private_class_method :get_basename


  def self.get_extname(filename)
      File.extname(filename)
  end
  private_class_method :get_extname
end
