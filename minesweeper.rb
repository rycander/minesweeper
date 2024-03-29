require 'yaml'

require './board.rb'
require './tile.rb'

class MineSweeper
  def run
    @continue_game = true
    while @continue_game
      choice = main_menu
      case choice
      when 1
        create_new_board
        turn_loop
      when 2
        load
      when 3
        @continue_game = false
      end


    end
  end


  private

  def turn_loop
    until over?
      @board.display
      display_turn_menu
      case get_user_choice(4)
      when 1
        @board.reveal(get_coordinate)
      when 2
        @board.toggle_flag(get_coordinate)
      when 3
        save
      when 4
        return
      end
    end
    @board.display
    game_over_message
  end

  def get_coordinate
    puts "Input X and Y coordinates (ex. 1 2)"
    input = nil
    until input =~ /\A([1-9]) +([1-9])\z/
      input = gets.chomp
    end
    [($2.to_i)-1,($1.to_i)-1]
  end

  def game_over_message
    if @board.winner?
      puts "A winner is you."
    elsif @board.explode?
      puts "You are dead."
    else
      puts "How did you get here?"
    end
  end

  def save
    puts "Save to which slot? (1-10)"
    slot = get_user_choice(10)
    savefile = File.open("minesweeper#{slot}.sav", "w")
    savefile.write(@board.to_yaml)
    savefile.close
  end

  def load
    puts "Load from which slot? (1-10)"
    slot = get_user_choice(10)

    unless File.exist?("minesweeper#{slot}.sav")
      puts "Save file doesn't exist."
      return
    end

    savefile = File.open("minesweeper#{slot}.sav")
    @board = YAML::load(savefile.read)
    savefile.close
    turn_loop
  end

  def display_turn_menu
    puts '-----------------------'
    puts '|   1. Sweep a Tile   |'
    puts '|   2. Flag a Tile    |'
    puts '|   3. Save Game      |'
    puts '|   4. Main Menu      |'
    puts '-----------------------'
  end

  def over?
    @board.explode? || @board.winner?
  end

  def create_new_board
    puts "How many mines do you want?"
    @board = Board.new(gets.chomp.to_i)
  end

  def main_menu
    display_main_menu
    get_user_choice(3)
  end

  def display_main_menu
    puts 'Welcome to Minesweeper!'
    puts '-----------------------'
    puts '|     1. New game     |'
    puts '|     2. Load         |'
    puts '|     3. Exit         |'
    puts '-----------------------'
  end

  def get_user_choice(n)
    choice = nil
    until (1..n).cover?(choice)
      choice = gets.chomp.to_i
    end
    choice
  end

end

if __FILE__ == $PROGRAM_NAME
  m = MineSweeper.new
  m.run
  #b = Board.new(9)
  #b.display
#  t = Tile.new([0, 1], b)
# p t.neighbors
end
