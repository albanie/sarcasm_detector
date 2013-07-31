class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.integer :number_of_annotations

      t.timestamps
    end
  end
end
