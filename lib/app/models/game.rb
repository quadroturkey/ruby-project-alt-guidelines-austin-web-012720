class Game < ActiveRecord::Base
  has_many :bets

  def started
    if self.start_time != nil
      Time.now.to_datetime < self.start_time
    else
      puts "game has no start_time"
      false
    end
  end

  def winner
    if self.a_score != nil && self.h_score !=nil
      if self.a_score > self.h_score
        return self.a_score
      elseif self.a_score < self.h_score
        return self.h_score
      else return "TIE"
      end
    else return "SCORES ARE NIL"
    end
  end

  def change_a_score(score)
    self.update(a_score: score)
  end

  def change_h_score(score)
    self.update(h_score: score)
  end

  def change_start_time(time)
    self.update(start_time: time)
  end

end
