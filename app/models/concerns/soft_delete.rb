module SoftDelete
  extend ActiveSupport::Concern

  included do
    default_scope { where(deleted: false) }
  end

  def soft_delete!
    update_column(:deleted, true)
  end
end
