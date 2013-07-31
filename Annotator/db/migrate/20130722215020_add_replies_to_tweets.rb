class AddRepliesToTweets < ActiveRecord::Migration
  def change
  	 add_column :tweets, :sarcastic, :string
     add_column :tweets, :reply_1, :string
     add_column :tweets, :reply_2, :string
     add_column :tweets, :reply_3, :string
     add_column :tweets, :reply_4, :string
     add_column :tweets, :reply_5, :string
  end
end
