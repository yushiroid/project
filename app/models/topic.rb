class Topic < ApplicationRecord
  # has_many :likes, dependent: :destroy
  belongs_to :user

  attr_accessor :title
  attr_accessor :description
  attr_accessor :image
  attr_accessor :evaluation
  attr_accessor :tag_id
  attr_accessor :tag_list

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
