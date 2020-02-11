class Menu
  attr_accessor :user

  def run
    welcome
  end

  def welcome
    puts "Welcome to:"
    puts "
    ██████╗ ██╗ ██████╗     ███╗   ███╗ ██████╗ ███╗   ██╗███████╗██╗   ██╗    ███████╗██████╗  ██████╗ ██████╗ ████████╗███████╗
    ██╔══██╗██║██╔════╝     ████╗ ████║██╔═══██╗████╗  ██║██╔════╝╚██╗ ██╔╝    ██╔════╝██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝██╔════╝
    ██████╔╝██║██║  ███╗    ██╔████╔██║██║   ██║██╔██╗ ██║█████╗   ╚████╔╝     ███████╗██████╔╝██║   ██║██████╔╝   ██║   ███████╗
    ██╔══██╗██║██║   ██║    ██║╚██╔╝██║██║   ██║██║╚██╗██║██╔══╝    ╚██╔╝      ╚════██║██╔═══╝ ██║   ██║██╔══██╗   ██║   ╚════██║
    ██████╔╝██║╚██████╔╝    ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║███████╗   ██║       ███████║██║     ╚██████╔╝██║  ██║   ██║   ███████║
    ╚═════╝ ╚═╝ ╚═════╝     ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝   ╚═╝       ╚══════╝╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
                                                                                                                                 
    ".colorize(:light_green)
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
    input = gets.chomp
    if User.exists?(name: input)
      homescreen(User.find_by(name: input))
    else puts "Username not found. Please try again!"
      login
    end
  end

  def create_new_user
    puts "Enter username: "
    input = gets.chomp
    homescreen(User.create(name: input, balance: 10000))
  end

  def display_account_info
    line_break
    puts "Username: #{self.user.name}".colorize(:cyan)
    puts "Balance : #{self.user.balance}".colorize(:green)
    homescreen
  end

  def spacer(left, right, middle)
    l = left.to_s
    r = right.to_s
    m = middle.to_s
    spacers = l.ljust(24) + m.center(11) + r.rjust(24)
    pipe_wrap(spacers)
  end

  def pipe_wrap(str)
    yp = "|".colorize(:yellow)
    new_str = yp + str + yp
  end

  def nav_bar
    prev = "PREVIOUS (p)".colorize(:light_red)
    bt = "(b) BET (b)".colorize(:light_green)
    nxt = "(n) NEXT".colorize(:cyan)
    "#{prev}             #{bt}                 #{nxt}"
  end

  def show_one_game(game)
    line_break
    puts spacer(game.home, game.away, "@")
    puts spacer(" #{game.h_spread}", "#{game.a_spread} ", "date/time")
    line_break
    puts nav_bar
  end

  def display_upcoming_games

    all_g = Game.all
    index = 0
    input = nil

    until input == "b"

      show_one_game(all_g[index])
      input = gets.chomp.downcase
      
      case input
      when "n"
        index += 1
      when "p"
        index -= 1
      when "b"
        bet_prompt(all_g[index])
      end
    end
  end

  def bet_prompt(game)
    puts "#{game.away} are playing @ the #{game.home}"
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
    puts "Confirm your bet of #{bet_amt.colorize(:green)} on #{team_selected}: (Y/N)"
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

  def wrap_center(str)
    str_new = str.center(59)
    puts pipe_wrap(str_new)
  end

  def print_menu(username)
    line_break
    wrap_center("Welcome #{user.name}")
    wrap_center("┌─┐┌─┐┌┬┐┬┌─┐┌┐┌┌─┐")
    wrap_center("│ │├─┘ │ ││ ││││└─┐")
    wrap_center("└─┘┴   ┴ ┴└─┘┘└┘└─┘")
    wrap_center("1. Account Info")
    wrap_center("2. Upcoming Games")
    wrap_center("3. Current Bets")
    wrap_center("4. Bet History")
    wrap_center("5. EXIT")
    line_break
  end

  def homescreen(user = self.user)
    self.user = user
    print_menu(user)
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