class Authentication < ActiveRecord::Base
  #attr_accessible :user_id, :provider, :uid
  belongs_to :user

  validates :user_id, presence: true
  validates :provider, uniqueness: { scope: :uid }
end
