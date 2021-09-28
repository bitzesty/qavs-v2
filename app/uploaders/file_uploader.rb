class FileUploader < CarrierWave::Uploader::Base
  POSSIBLE_IMG_EXTENSIONS = %w(jpg jpeg png)
  POSSIBLE_DOC_EXTENSIONS = %w(doc docx odt pdf txt)

  def extension_allowlist
    POSSIBLE_IMG_EXTENSIONS + POSSIBLE_DOC_EXTENSIONS
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
