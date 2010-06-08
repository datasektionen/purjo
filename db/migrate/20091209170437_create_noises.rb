class CreateNoises < ActiveRecord::Migration
  def self.up
    create_table :noises do |t|
	t.integer :post_id
	t.integer :person_id
	t.text :message
      t.timestamps
    end
  end

  def self.down
    drop_table :noises
  end
end
