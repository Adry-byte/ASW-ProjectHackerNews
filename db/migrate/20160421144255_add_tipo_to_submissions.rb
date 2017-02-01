class AddTipoToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :tipo, :string
  end
end
