require_relative "board"
require_relative "tile"

class Minesweeper
    attr_accessor :board
    def initialize(size)
        board = Board.new(size)
    end

    def run
        board.place_mines
        board.find_neighbors
        board.place_numbers
        until self.win?
            self.play_turn
        end
        board.render
        puts "You win! But the future refused to change..."
    end

    def play_turn

    end

    def win?
        board.grid.each do |row|
            row.each do |tile|
                return false if tile.revealed == false && tile.mine == false
            end
        end
        true
    end
end