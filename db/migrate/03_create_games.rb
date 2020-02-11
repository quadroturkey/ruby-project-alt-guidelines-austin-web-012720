class CreateGames < ActiveRecord::Migration[4.2]
  def change
    create_table :games do |t|
      t.string :home
      t.string :away
      t.integer :h_score
      t.integer :a_score
      t.float :h_spread
      t.float :a_spread
      t.datetime :start_time
    end
  end
end
