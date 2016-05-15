require_relative 'player'
require_relative 'board'

class Play
  def initialize
    @board = Board.new
  end

  def start
    message
    play
  end

  def play
    while true
      player_turn(@player1)
      if check_game_won?(@player1)
        break
      end
      player_turn(@player2)
      if check_game_won?(@player2)
        break
      end
    end
    play_again?
  end

  def player_turn(player)
    player_prompt(player)
    move = get_player_move
    player_move(player, move)
  end

  def message
    puts "Welcome to Ruby Connect Four!"
    puts ""
    player_setup
    puts ""
    @board.print_board
    puts ""
  end

  def player_setup
    puts "Player 1, please enter your name: "
    name1 = gets.chomp
    @player1 = Player.new(name1,"X")
    puts "Player 1 is #{@player1.name} and will be #{@player1.type}."
    puts ""
    puts "Player 2 please enter your name"
    name2 = gets.chomp
    @player2 = Player.new(name2, "O")
    puts "Player 2 is #{@player2.name} and will be #{@player2.type}."
  end

  def player_prompt(player)
    puts "#{player.name} select a column to place your piece: "
  end

  def get_player_move_choice
    gets.chomp
  end

  def player_move(player, move)
    @board.drop_piece(move.to_i, player.type)
    @board.print_board
  end

  def get_player_move
    @move = get_player_move_choice
    if !(/\A[0-6]\z/.match(@move)) || @move == ''
      puts "Invalid choice, please select a column again: "
      get_player_move
    elsif @board.column_full?(@move)
      puts "Column full, please select a column again: "
      get_player_move
    end
    return @move
  end

  def player_wins(player)
    puts "#{player.name} Wins!"
    true
  end

  def stalemate_end
    puts "Stalemate! No more available moves!"
    true
  end

  def check_game_won?(player)
    if @board.game_won?
      return player_wins(player)
    elsif @board.stalemate?
      return stalemate_end
    end
  end

  def play_again?
    puts "Would you like to play again? (y/n?)"
    result = gets.chomp.downcase
    if result == "y"
      @board = Board.new
      @board.print_board
      play
    elsif result == "n"
      puts "Thanks for playing!"
    else
      puts "Please enter y/n:"
      play_again?
    end
  end
end

play = Play.new
play.start
