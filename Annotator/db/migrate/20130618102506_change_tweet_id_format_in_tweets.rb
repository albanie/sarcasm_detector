class ChangeTweetIdFormatInTweets < ActiveRecord::Migration
  def change
    change_column :tweets, :tweetId, :string
  end
end
