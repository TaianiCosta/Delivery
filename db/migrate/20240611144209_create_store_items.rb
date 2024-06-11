class CreateStoreItems < ActiveRecord::Migration[7.1]
  def change
    create_table :store_items do |t|

      t.timestamps
    end
  end
end
