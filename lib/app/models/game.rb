class Game < ActiveRecord::Base
  has_many :bets

  after_initialize :defaults, unless: :persisted?

  def defaults
    self.h_score ||= 0
    self.a_score ||= 0
  end

end
