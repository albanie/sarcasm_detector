class RemoveLanguageFromUser < ActiveRecord::Migration
  def change
  	remove_column :users, :language_level
  end
end
