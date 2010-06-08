class CreateKthAccounts < ActiveRecord::Migration
  def self.up
    create_table :kth_accounts do |t|
      t.string :ugid
      t.integer :person_id

      t.timestamps
    end
    
    add_index(:kth_accounts, :ugid, :unique => true)
  end

  def self.down
    drop_table :kth_accounts
  end
end
