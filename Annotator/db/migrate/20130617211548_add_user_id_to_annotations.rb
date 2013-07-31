class AddUserIdToAnnotations < ActiveRecord::Migration
  def change
    add_column :annotations, :user_id, :integer
  end
end
