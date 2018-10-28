class User < ApplicationRecord
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :authentications, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

  mount_uploader :image, ImageUploader

  #Facebook Login
  #attr_accessible :email, :password, :password_confirmation, :authentications_attributes
  accepts_nested_attributes_for :authentications
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end
end
