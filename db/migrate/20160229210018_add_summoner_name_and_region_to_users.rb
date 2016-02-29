class AddSummonerNameAndRegionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :summoner_name, :string
    add_column :users, :region, :string
  end
end
