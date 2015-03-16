class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :authorable, polymorphic: true

  validates :body, presence: true

  delegate :email, to: :authorable, prefix: :author

  # admin comments - Admin only
  # critical comments - shared between Admin/Assessor

  enum section: {
    admin: 0,
    critical: 1
  }

  def author?(subject)
    authorable == subject
  end

  def self.admin
    where(section: 0).order(created_at: :desc)
  end

  def self.critical
    where(section: 1).order(created_at: :desc)
  end

  def self.flagged
    where(flagged: true).order(created_at: :desc)
  end

  def main_for?(subject)
    meth = {
      "Admin" => :admin?,
      "Assessor" => :critical?
    }[subject.class.to_s]
    public_send(meth)
  end
end
