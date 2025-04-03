class CreateRecipes < ActiveRecord::Migration[7.2]
  def change
    create_table :recipes do |t|
      t.string :title
      t.integer :cooking_time
      t.text :ingredients_list
      t.text :dietary_labels
      t.string :image_url

      t.timestamps
    end
  end
end
