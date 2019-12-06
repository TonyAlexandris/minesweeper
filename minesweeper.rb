require_relative "board"
require_relative "tile"
require "byebug"
class Minesweeper
    attr_accessor :board
    def initialize(size)
        @board = Board.new(size)
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
        board.render
        move = self.get_move
        coordinates = self.get_coordinates
        y = coordinates[0]
        x = coordinates[1]
        tile = board.find_tile(y, x)
        if tile.face_value != "*" && tile.face_value != "F"
            puts "Pick an unexplored space"
            self.play_turn
        end
        if move == "f"
            tile.flag
        else
            self.explore(tile)
        end
    end

    def explore(tile)
        tile.reveal
        if tile.value == "@"
            board.reveal_all
            board.render
            abort "You lose"
        else
            if tile.value == "O" && tile.checked == false
                tile.checked = true
                tile.neighbors.each {|neighbor| self.explore(neighbor)}
            else
                tile.reveal
            end
        end
    end

    def get_move
        puts "Enter f to flag or r to reveal"
        choice = gets.chomp
        if choice == "f" || choice == "r"
            return choice
        else
            puts "Invalid move"
            self.get_move
        end
    end

    def get_coordinates
        puts "Enter coordinates separated by comma y,x"
        coordinates = gets.chomp.split(",").map {|coord| coord.to_i}
        return coordinates 
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

game = Minesweeper.new(9)
game.run
