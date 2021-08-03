module SoftDelete
  def soft_delete!
    update_column(:deleted, true)
  end
end
