class AddHostnameAndStatusToEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :entries, :hostname, :string
    add_column :entries, :status, :string
  end
end
