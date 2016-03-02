class CreateChampions < ActiveRecord::Migration
  def change
    create_table :champions do |t|
      t.integer :champion_id
      t.boolean :ranked_play_enabled
      t.boolean :free_to_play

      t.timestamps null: false
    end
  end
end
