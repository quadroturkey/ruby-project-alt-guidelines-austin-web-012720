class User < ActiveRecord::Base
    has_many :bets

    after_initialize :defaults, unless: :persisted?

    def defaults
      self.balance ||= 10000000
    end

    def budget-=(amount)
      self.budget = self.budget -amount
    end

    def has_budget(amount)
      self.balance > amount
    end

    def take_funds(amount)
      if self.has_budget(amount)
        self.budget -= (amount)
      end
    end

    def balance+=(amount)
      self.budget = self.budget + amount
    end




end
