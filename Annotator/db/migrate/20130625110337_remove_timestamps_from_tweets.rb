class RemoveTimestampsFromTweets < ActiveRecord::Migration
  def up
    remove_column :tweets, :created_at
    remove_column :tweets, :updated_at
  end

  def down
    add_column :tweets, :created_at
    add_column :tweets, :updated_at
  end
end
