class CreateSpells < ActiveRecord::Migration
  def change
    create_table :spells do |t|
      t.string :name
      t.string :description
      t.string :image
      t.references :champion, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
