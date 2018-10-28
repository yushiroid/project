class Topic < ApplicationRecord
  # has_many :likes, dependent: :destroy
  belongs_to :user

  attr_accessor :title
  attr_accessor :description
  attr_accessor :image
  attr_accessor :evaluation
  attr_accessor :tag_id
  attr_accessor :tag_list

  VALID_URL_REGEX = /\A#{URI::regexp(%w(http https))}\z/

  validates :user_id, presence: true
  validates :url, presence: true, format: { with: VALID_URL_REGEX }

  # topicにいいねする
  # def fav(user)
  #   likes.create(user_id: user.id)
  # end
  #
  # # topicのいいねを解除する
  # def unfav(user)
  #   likes.find_by(user_id: user.id).destroy
  # end
end
