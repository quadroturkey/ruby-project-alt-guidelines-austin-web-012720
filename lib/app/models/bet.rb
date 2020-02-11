class Bet < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  after_initialize :collect_from_user, unless: :persisted?

  def collect_from_user
    if(self.bet_amount > 0)
    self.user.take_funds(self.bet_amount)
    end
  end

  def cancel
    self.user.balance += bet_amount
    self.remove
  end

  def change_amount(amount)
    if game.started
      puts "Sorry, the game has started."
    elsif self.user.has_budget(amount)
      self.bet_amount = amount
      puts "Bet updated.\nTeam: #{team_selected}\nAmount: #{self.bet_amount}"
    end
  end

  def change_team(team)
    self.team_selected = team
  end

  # STILL NEED
  # a class method to update and make payouts after game happens
  #
end
