class Group < ApplicationRecord

  has_many :group_users
  has_many :users, through: :group_users

  validates :name, presence: true, length: { minimum: 3 }
end
