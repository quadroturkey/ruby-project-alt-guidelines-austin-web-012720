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

  def spacer(left, right, middle)
    l = left.to_s
    r = right.to_s
    m = middle.to_s
    spacers = pipe + l.ljust(24) + m.center(11) + r.rjust(24) + pipe
  end

  def pipe
    "|".colorize(:yellow)
  end

  def display_upcoming_games

    all_games = Game.all
    game_index = 0
    nav_input = nil

    until nav_input == "b"
      
      t = all_games[game_index]

      prev = "PREVIOUS (p)".colorize(:light_red)
      bt = "(b) BET (b)".colorize(:light_green)
      nxt = "(n) NEXT".colorize(:cyan)

      
      line_break
      puts spacer(t.home, t.away, "@")
      puts spacer(" #{t.h_spread}", "#{t.a_spread} ", "date/time")
      line_break
      puts "#{prev}             #{bt}                 #{nxt}"
      

      nav_input = gets.chomp.downcase
      case nav_input
      when "n"
        game_index += 1
      when "p"
        game_index -= 1
      end

    end

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
      display_upcoming_games
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
    star_count =  "-" * 61
    puts star_count.colorize(:yellow)
  end

end


