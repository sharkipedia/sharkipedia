# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  token                  :string
#  unconfirmed_email      :string
#  user_level             :string           default("user")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_token                 (token) UNIQUE
#
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

  def send_devise_notification(notification, *)
    devise_mailer.send(notification, self, *).deliver_later
  end

  private

  def ensure_token
    self.token ||= SecureRandom.hex(10)
  end
end
