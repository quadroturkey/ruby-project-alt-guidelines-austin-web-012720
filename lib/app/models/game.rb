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
    response = Unirest.get "https://sportspage-feeds.p.rapidapi.com/games",
    headers:{
      "X-RapidAPI-Host" => "sportspage-feeds.p.rapidapi.com",
      "X-RapidAPI-Key" => "38b0c02487msh5a80be578fae7b6p10eeeajsnc8497830dbd2"
    }
    games = response.body.dig("results")
    i = 0
    until i == games.count
      if games[i].dig("odds") != nil
        Game.all.find_or_create_by(sports_page_id: games[i].dig("gameId")).update(
          home: games[i].dig("teams", "home", "team"),
          away: games[i].dig("teams", "away", "team"),
          h_spread: games[i].dig("odds")[0].dig("spread", "open",  "home"),
          a_spread: games[i].dig("odds")[0].dig("spread", "open",  "away"),
          start_time: games[i].dig("schedule", "date"),
          sports_page_id: games[i].dig("gameId"),
          status: games[i].dig("status")
        )
      end
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
