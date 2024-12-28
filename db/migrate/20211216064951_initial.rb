class Initial < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.integer :plan, null: false, default: 0    # enum for the plan level (none, free, base, multisite)

      t.timestamps
    end

    create_table :subscriptions do |t|
      t.datetime :current_period_start
      t.datetime :current_period_end
      t.string :stripe_subscription_id

      t.timestamps
    end

    create_table :accounts do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :subscription, foreign_key: true # TODO: add a null: false here
      t.string :name
      t.boolean :is_main, default: false

      t.timestamps
    end

    create_table :notes do |t|
      t.references :account, null: false, foreign_key: true
      t.string :title
      t.string :background_color
      t.text :content

      t.timestamps
    end

    create_table :users do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :password_digest
      t.string :provider

      t.timestamps
    end

    create_table :user_account_members do |t|
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.boolean :is_default, default: false

      t.timestamps

      t.index [:user_id, :account_id]
      t.index [:account_id, :user_id]
    end

    create_table :user_account_member_roles do |t|
      t.references :user_account_member, null: false, foreign_key: true
      t.integer :role, null: false, default: 0  # enum for the role

      t.timestamps
    end
  end
end
