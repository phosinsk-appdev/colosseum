class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :nickname
      t.date :dob
      t.text :bio
      t.float :event_minimum
      t.string :email
      t.string :phone_number
      t.string :social_one
      t.string :social_two
      t.string :social_three
      t.string :social_four

      t.timestamps
    end
  end
end
