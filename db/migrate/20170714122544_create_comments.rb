class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
    	t.text :message
    	t.integer :admin_id
    	t.integer :post_id
      t.timestamps
    end
    add_index :comments, :admin_id
    add_index :comments, :post_id
  end
end
