class User < ActiveRecord::Base
    has_many :bets

    after_initialize :defaults, unless: :persisted?
    def defaults
      self.balance ||= 10000000
    end



end
