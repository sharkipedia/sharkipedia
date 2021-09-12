class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :validatable

  has_many :imports
  has_many :observations
  has_many :trends

  scope :admins, -> { where(user_level: "admin") }
  scope :editors, -> { where(user_level: "editors") }
  scope :contributors, -> { where(user_level: "contributor") }

  validates :name, :token, presence: true
  validates :token, uniqueness: true

  before_validation :ensure_token

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

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private

  def ensure_token
    self.token ||= SecureRandom.hex(10)
  end
end
