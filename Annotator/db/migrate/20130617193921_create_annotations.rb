class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.string :tweetId
      t.string :email
      t.string :value

      t.timestamps
    end
  end
end
