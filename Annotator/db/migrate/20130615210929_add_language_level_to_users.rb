class AddLanguageLevelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :language_level, :integer
  end
end
