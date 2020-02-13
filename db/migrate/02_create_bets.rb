class CreateBets < ActiveRecord::Migration[4.2]
    def change
        create_table :bets do |t|
            t.integer :user_id
            t.integer :game_id
            t.string :bet_type
            t.integer :bet_amount
            t.string :team_selected
            t.string :status
        end
    end
end