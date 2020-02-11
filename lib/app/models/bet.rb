class Bet < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  after_initialize :collect_from_user, unless: :persisted?

  def collect_from_user
    if(self.bet_amount > 0)
    self.user.debit_balance(self.bet_amount)
    end
  end

  def cancel
    self.user.debit_balance(self.bet_amount)
    self.remove
  end

  def change_amount(new_amount)
    if self.game.started
      puts "Sorry, the game has started."
    elsif self.user.has_budget(new_amount)
      self.user.debit_balance(new_amount - self.bet_amount)
      self.update(bet_amount: new_amount)
      puts "Bet updated.\nTeam: #{team_selected}\nAmount: #{self.bet_amount}"
    end
  end

  def change_team(team)
    self.update(team_selected: team)
  end

  # STILL NEED
  # a class method to update and make payouts after game happens
  #
end
