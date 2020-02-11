class User < ActiveRecord::Base
    has_many :bets

    def has_budget(amount)
      self.balance > amount
    end

    def debit_balance(amount)
      if self.has_budget(amount)
        self.update(balance: self.balance - amount)
      end
    end

    def credit_balance(amount)
      self.update(balance: self.balance + amount)
    end

end
