class AddApiKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :apiKey, :string
  end
end
