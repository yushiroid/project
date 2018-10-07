class AddUseridToTopicTags < ActiveRecord::Migration[5.2]
  def change
    add_column :topic_tags, :user_id, :integer
  end
end
