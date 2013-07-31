class ChangeColumnTypeToStringInTweets < ActiveRecord::Migration
  def change
  	change_column :tweets, :content, :text
  end
end
