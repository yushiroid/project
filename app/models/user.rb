class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :group_users
  has_many :groups, through: :group_users

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true

  mount_uploader :image, ImageUploader
end
