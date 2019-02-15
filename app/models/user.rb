class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  has_many :imports
  has_many :observations
  has_many :trends

  def admin?
    user_level == 'admin'
  end

  def editor?
    user_level == 'editor'
  end

  def contributor?
    user_level == 'contributor'
  end

  def user?
    user_level == 'user'
  end
end
