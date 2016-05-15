require_relative 'space'

class Board
  attr_accessor :game_board

  def initialize
    @game_board = build_game_board
  end

  def build_game_board
    rows_and_columns = []
    6.times do
      row = []
      7.times do
        row << Space.new
      end
      rows_and_columns << row
    end
    rows_and_columns
  end

# faster to check from bottom up
  def check_board
    game_board.reverse
  end

  def drop_piece(column_num, piece)
    check_board.each do |row|
      unless row[column_num].filled?
        return row[column_num].space = piece
      end
    end
  end

  def wins_horizontally?
    check_board.each do |row|
      return true if check_row_for_win(row)
    end
    false
  end

  def check_row_for_win(row)
    row.each_cons(4) do |slice|
      if slice.length == 4 && slice.map(&:space).uniq.length == 1 && slice.first.space != nil
        return true
      end
    end
    false
  end

  def wins_vertically?
    (0...check_board.length).each do |index|
      vert = check_board.map { |row| row[index] }
      return true if check_row_for_win(vert)
    end
    false
  end

  def diagonal_bottom_quadrant?(board)
    master_check = []
    (0...board.length).to_a.reverse.each do |index|
      row_index = 0
      column_index = index
      check_array = []
      while board[column_index] && board[column_index][row_index]
        check_array << board[column_index][row_index]
        row_index += 1
        column_index += 1
      end
      master_check << check_array if check_array.length >= 4
    end
    master_check.each do |array|
      return true if check_row_for_win(array)
    end
    false
  end

  def diagonal_top_quadrant?(board)
    master_check = []
    (0...board.length).to_a.reverse.each do |index|
      row_index = index
      column_index = 0
      check_array = []
      while board[column_index] && board[column_index][row_index]
        check_array << board[column_index][row_index]
        row_index += 1
        column_index += 1
      end
      master_check << check_array if check_array.length >= 4
    end
    master_check.each do |array|
      return true if check_row_for_win(array)
    end
    false
  end

  def diagonal_down_right_bottom_quadrant?
    diagonal_bottom_quadrant?(game_board)
  end

  def diagonal_down_right_top_quadrant?
    diagonal_top_quadrant?(game_board)
  end

  def diagonal_down_left_top_quadrant?
    reversed_board = game_board.map { |row| row.reverse }
    diagonal_top_quadrant?(reversed_board)
  end

  def diagonal_down_left_bottom_quadrant?
    reversed_board = game_board.map { |row| row.reverse }
    diagonal_bottom_quadrant?(reversed_board)
  end

  def wins_diagonally?
    diagonal_down_right_bottom_quadrant? || diagonal_down_right_top_quadrant? ||  diagonal_down_left_bottom_quadrant? || diagonal_down_left_top_quadrant?
  end

  def game_won?
    wins_horizontally? || wins_vertically? || wins_diagonally?
  end

  def stalemate?
    index_array = (0...game_board.first.length).to_a
    index_array.each do |index|
      return false if !column_full?(index)
    end
    true
  end

  def column_full?(player_input)
    row_check = game_board.first
    return false if row_check[player_input.to_i].space.nil?
    true
  end

  def print_board
    numbers_array = [0,1,2,3,4,5,6]
    game_board.map do |row|
      display_array = []
      row.each do |slot|
        empty_string = " "
        if slot.space.nil?
          display_array << empty_string
        else
          display_array << slot.space
        end
        display_array
      end
      puts "|#{display_array.join(" ")}|"
    end.join("\n")
    puts "---------------"
    puts " #{numbers_array.join(' ')}"
  end
end
