class Tag < ApplicationRecord
  has_many :topic_tag
  has_many :tag, through: :topic_tag
end
