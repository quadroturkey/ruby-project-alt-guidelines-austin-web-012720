class Menu
  attr_accessor :user

  def run
    welcome
  end

  def welcome
    puts "Welcome to the game"
    puts "Do you have an existing account? (Y/N)"

    input = gets.chomp

    case input.downcase
    when "y" || "Y"
      line_break
      login
    when "n" || "N"
      line_break
      create_new_user
    else
      puts "Invalid Entry. Type Y for yes or N for no."
      line_break
      welcome
    end
  end

  def login
    puts "Enter your username: "
    input =  gets.chomp
    homescreen(User.find_or_create_by(name: input))
  end

  def create_new_user
    puts "Enter username: "
    input = gets.chomp
    homescreen(User.create(name: input))
  end

  def display_account_info
    line_break
    puts "Username: #{self.user.name}".colorize(:blue)
    puts "Balance : #{self.user.balance}".colorize(:green)
    homescreen
  end

  def display_upcoming_games#(game_index)

    all_games = Game.all
    game = all_games[game_index]

    until input == "b"
      line_break
      puts
    end



    # line_break
    # puts "Team 1               vs          team 2"
    # puts "home spread     ---------------- away spread"
    # puts "PREVIOUS (p) .......BET (b).......... NEXT (n)".colorize(:red)
    # line_break

    # selected = gets.chomp
    # case selected
    # when "n"
    #   game_index += 1
    #   display_upcoming_games(game_index)
    # when "p"
    #   game_index -= 1
    #   display_upcoming_games(game_index)
    # when "b"
    #   bet_prompt(Game.all[game_index])
    # else
    #   puts "will not accept that input"
    #   display_upcoming_games(game_index)
    # end
  end

  def bet_prompt(game)
    puts "#{game.away} are playing @ #{game.home}"
    if game.h_spread > 0
      puts "The #{game.home} are favored by #{game.h_spread}"
    else
      puts "The #{game.away} are favored by #{game.a_spread}"
    end

    puts "Which team do you want to bet on?"
    puts "1. #{game.home}".colorize(:bright_red)
    puts "2. #{game.away}".colorize(:bright_blue)
    puts "3. BACK"

    input = gets.chomp.to_i

    case input
    when 1
      team_selected = game.home
    when 2
      team_selected = game.away
    when 3
      display_upcoming_games
    end

    puts "How much do you want to bet?"

    bet_amt = gets.chomp

    puts "Confirm your bet of #{bet_amt} on #{team_selected}: (Y/N)"

    confirmation = gets.chomp.downcase

    case confirmation
    when "y"
      Bet.create(
        user: self.user,
        game: game,
        bet_amount: bet_amt,
        team_selected: team_selected,
        bet_type: "spread"
      )
    when "n"
      puts "Bet canceled"
      line_break
      bet_prompt
    end

  end



  def display_current_bets(user)

  end

  def display_all_bets(user)

  end

  def homescreen(user = self.user)
    self.user = user
    line_break
    puts "Welcome, #{user.name}".colorize(:blue)
    puts "Please select an option:\n1. Account Info\n2. Upcoming Games\n3. Current Bets\n4. Bet History\n5. EXIT\n"
    line_break

    input = gets.chomp.to_i

    case input
    when 1
      display_account_info
    when 2
      display_upcoming_games(0)
    when 3
      display_current_bets(user)
    when 4
      display_all_bets(user)
    when 5
      puts "Goodbye"
    else
      puts "Invalid Entry."
      homescreen(user)
    end
  end

  def line_break
    puts "******************************************".colorize(:yellow)
  end
end
