
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
      login
    when "n" || "N"
      create_new_user
    else
      puts "Invalid Entry. Type Y for yes or N for no."
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
      puts "Username: #{self.user.name}".colorize(:blue)
      puts "Balance : #{self.user.balance}".colorize(:green)
      homescreen
  end

  def display_upcoming_games(game_index)
      selected = nil
      ap Game.all[game_index]
      puts "PREVIOUS (p) .......BET (b).......... NEXT (n)".colorize(:red)
      selected = gets.chomp
      case selected
      when "n"
          game_index += 1
          display_upcoming_games(game_index)
      when "p"
          game_index -= 1
          display_upcoming_games(game_index)
      when "b"
          puts "make bet"
      else
          puts "will not accept that input"
          display_upcoming_games(game_index)
      end
  end

  def place_bet(user, game)

  end

  def display_current_bets(user)

  end

  def display_all_bets(user)

  end

  def homescreen(user = self.user)
    self.user = user
    puts "Welcome, #{user.name}"
    puts "Please select an option:\n1. Account Info\n2. Upcoming Games\n3. Current Bets\n4. Bet History\n5. EXIT\n"

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
end
