class Game < ActiveRecord::Base
    has_many :bets

    # def started    
    #     false   # Use this to see if bets can be altered
    #     # if current_time > game_time
    #     #     true
    #     # else
    #     #     false
    #     # end
    # end

    def display_upcoming_games
        pp Game.all
    end

end