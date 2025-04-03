class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.integer :rating
      t.text :comment
      t.boolean :is_favorite

      t.timestamps
    end
  end
end
