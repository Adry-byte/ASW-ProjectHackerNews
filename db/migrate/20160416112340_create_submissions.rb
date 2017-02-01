class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.string :title
      t.string :url
      t.string :content

      t.timestamps null: false
    end
  end
end
