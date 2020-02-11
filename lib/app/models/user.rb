class User < ActiveRecord::Base
  has_many :bets

  # after_initialize :defaults, unless: :persisted?

  # attr_accessor :balance

  # def defaults
  #   self.balance ||= 10000000
  # end

  def has_budget(amount)
    self.balance > amount
  end

  def take_funds(amount)
    if self.has_budget(amount)
      self.update(balance: self.balance - amount)
    end
  end

end
