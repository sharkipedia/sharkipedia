class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :validatable

  has_many :imports
  has_many :observations
  has_many :trends

  scope :admins, -> { where(user_level: "admin") }
  scope :editors, -> { where(user_level: "editors") }
  scope :contributors, -> { where(user_level: "contributor") }

  validates :name, presence: true

  def admin?
    user_level == "admin"
  end

  def editor?
    user_level == "editor" || admin?
  end

  def contributor?
    user_level == "contributor" || editor? || admin?
  end

  def user?
    user_level == "user" || editor? || contributor? || admin?
  end

  def self.admin_emails
    User.admins.pluck(:email)
  end
end
