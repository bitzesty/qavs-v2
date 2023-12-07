module SoftDelete
  extend ActiveSupport::Concern

  included do
    default_scope { where(deleted: false) }

    scope :deleted, -> { unscoped.where(deleted: true) }
  end

  def soft_delete!
    update_column(:deleted, true)
  end

  def restore!
    update_column(:deleted, false)
  end
end
