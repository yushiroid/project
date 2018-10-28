class TopicTag < ApplicationRecord
  belongs_to :topic
  belongs_to :tag

  validates :topic_id, presence: true
  validates :tag_id, presence: true

end
