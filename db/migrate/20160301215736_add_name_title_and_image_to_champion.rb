class AddNameTitleAndImageToChampion < ActiveRecord::Migration
  def change
    add_column :champions, :name, :string
    add_column :champions, :title, :string
    add_column :champions, :image, :string
  end
end
