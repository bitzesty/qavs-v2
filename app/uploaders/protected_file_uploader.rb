class ProtectedFileUploader < FileUploader
  def extension_allowlist
    super + %w(csv)
  end
end
