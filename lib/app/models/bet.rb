class Bet < ActiveRecord::Base
    belongs_to :user
    belongs_to :game

    

    def edit_amount(new_bet_amt)
        if game.started
            puts "sorry, the game has started."
        else
            if balance_check(new_bet_amt)
                self.bet_amount = new_bet_amt
                puts "your bet on #{team_selected} has been changed to #{self.bet_amount}"
            end
        end
    end

    def balance_check(amt)
        if self.User.balance < amt
            puts "Sorry you are missing funds to make this bet, please enter a different amount"
            false
        else
            true
        end
    end

end