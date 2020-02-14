class Game < ActiveRecord::Base
  has_many :bets

  def started
    self.start_time.past?
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

  def self.update_from_api
    response = Unirest.get "https://sportspage-feeds.p.rapidapi.com/games?status=final",
    headers:{
      "X-RapidAPI-Host" => "sportspage-feeds.p.rapidapi.com",
      "X-RapidAPI-Key" => "1d54e391b9msh2ac664a56fed0d8p1d7913jsn7d463e8a8620"
    }
    games = response.body.dig("results")


    i = 0
    until i == games.count
      Game.all.find_by(sports_page_id: games[i].dig("gameId")).update(
        h_score: games[i].dig("scoreboard", "score", "home"),
        a_score: games[i].dig("scoreboard", "score", "away"),
        status: games[i].dig("status")
      )
      i+=1
      puts "updated"
    end


  end

  def winner
    if a_score > h_score
      away
    else
      home
    end
  end



end
