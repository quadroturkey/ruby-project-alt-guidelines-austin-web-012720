class Menu
  attr_accessor :user

  def welcome_banner
    clear_screan
    puts "Welcome to:"
    puts "
    ██████╗ ██╗ ██████╗     ███╗   ███╗ ██████╗ ███╗   ██╗███████╗██╗   ██╗    ███████╗██████╗  ██████╗ ██████╗ ████████╗███████╗
    ██╔══██╗██║██╔════╝     ████╗ ████║██╔═══██╗████╗  ██║██╔════╝╚██╗ ██╔╝    ██╔════╝██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝██╔════╝
    ██████╔╝██║██║  ███╗    ██╔████╔██║██║   ██║██╔██╗ ██║█████╗   ╚████╔╝     ███████╗██████╔╝██║   ██║██████╔╝   ██║   ███████╗
    ██╔══██╗██║██║   ██║    ██║╚██╔╝██║██║   ██║██║╚██╗██║██╔══╝    ╚██╔╝      ╚════██║██╔═══╝ ██║   ██║██╔══██╗   ██║   ╚════██║
    ██████╔╝██║╚██████╔╝    ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║███████╗   ██║       ███████║██║     ╚██████╔╝██║  ██║   ██║   ███████║
    ╚═════╝ ╚═╝ ╚═════╝     ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝   ╚═╝       ╚══════╝╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
                                                                                                                                 
    ".colorize(:light_green)
    
  end

  def welcome
    welcome_banner

    puts "Do you have an existing account? (Y/N)"
    input = gets.chomp
    
    case input.downcase
    when "y"
      line_break
      login
    when "n"
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
    clear_screan
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

  def nav_bar_top
    options = "OPTIONS (o)".colorize(:light_blue)
    bt = "(b) BET".colorize(:light_green)
    "#{options}                                           #{bt}"
  end

  def nav_bar_bottom
    prev = "PREVIOUS (p)".colorize(:light_red)
    nxt = "(n) NEXT".colorize(:cyan)
    "#{prev}                                         #{nxt}"
  end

  def show_one_game(game)
    clear_screan
    puts nav_bar_top
    line_break
    puts spacer(game.away, game.home, "@")
    puts spacer(" #{game.a_spread}", "#{game.h_spread} ", "date/time")
    line_break
    puts nav_bar_bottom
  end

  def display_upcoming_games
    all_g = Game.all
    index = 0
    input = nil
    until input == "b" || input == "o"
      show_one_game(all_g[index])
      input = gets.chomp.downcase 
      case input
      when "n"
        index += 1
      when "p"
        index -= 1
      when "b"
        display_bet_prompts(all_g[index])
      when "o"
        homescreen
      end
    end
  end

  def display_bet_prompts(game)
    line_break
    wrap_center("#{game.away} are playing @ the #{game.home}")
    if game.h_spread > 0
      wrap_center("The #{game.home} are favored by +#{game.h_spread}")
    else
      wrap_center("The #{game.away} are favored by +#{game.a_spread}")
    end
    wrap_center("Which team do you want to bet on?")
    line_break
    wrap_center("1. #{game.home}")
    wrap_center("2. #{game.away}")
    wrap_center("3. BACK")
    line_break
    bet_team_selection(game)
  end

  def bet_team_selection(game)
    input = gets.chomp.to_i
    case input
    when 1
      display_team_selection(game.home, game)
    when 2
      display_team_selection(game.away, game)
    when 3
      display_upcoming_games
    end
  end

  def bet_valid?(bet_amount)
    if bet_amount =~ /^-?[0-9]+$/
      true
    else
      false
    end
  end

  def display_team_selection(team_sel, game)
    puts "How much do you want to bet?"
    bet_amt = gets.chomp
    if bet_valid?(bet_amt)
      puts "Confirm your bet of #{bet_amt.colorize(:green)} on the #{team_sel}: (Y/N)"
      confirmation = gets.chomp.downcase
      confirm_bet(confirmation, bet_amt, game, team_sel)
    else
      puts "Invalid input".colorize(:light_red)
      sleep (1)
      clear_screan
      display_bet_prompts(game)
      display_team_selection(team_sel, game)
    end
  end

  def confirm_bet(confirm, bet_amt, game, team_selected)
    case confirm
    when "y"
      Bet.create(
        user: self.user, 
        game: game, 
        bet_amount: bet_amt, 
        team_selected: team_selected, 
        bet_type: "spread"
      )
      homescreen(self.user)
    else
      puts "Bet canceled".colorize(:light_red)
      sleep(1)
      clear_screan
      homescreen
    end
  end
  
  def display_current_bets(user)
    clear_screan
    line_break
    wrap_center("    TEAM SELECTED              BET AMOUNT - TO WIN  ")
    line_break
    self.user.bets.map do |b| 
      puts spacer("  #{b.team_selected}", "#{b.bet_amount} - $#{(b.bet_amount*2)}        ","|")
    end
    line_break
    homescreen
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
      clear_screan
      display_account_info
    when 2
      display_upcoming_games
    when 3
      display_current_bets(user)
    when 4
      display_all_bets(user)
    when 5
      puts "Thanks for the cash fish!".colorize(:light_magenta)
    else
      puts "Invalid Entry."
      homescreen(user)
    end
  end

  def line_break
    star_count =  "-" * 61
    puts star_count.colorize(:yellow)
  end

  def clear_screan
    system("cls") || system("clear")
  end
  
end