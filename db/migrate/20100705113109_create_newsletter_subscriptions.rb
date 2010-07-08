class CreateNewsletterSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :newsletter_subscriptions do |t|
      t.integer :person_id
      t.string :state
      t.datetime :subscribed_at
      t.datetime :cancelled_at

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletter_subscriptions
  end
end
