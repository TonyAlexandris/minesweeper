require_relative "board"
require_relative "tile"
require "byebug"
require 'yaml'
class Minesweeper
    attr_accessor :board, :saves
    def initialize(size)
        @board = Board.new(size)
        @saves = 0
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
        if move == "s"
            @saves += 1
            save = []
            board.grid.each do |row|
                row.each {|tile| save << tile}
            end
            File.open("save.yml", "w") {|file| file.write(save.to_yaml)}
            self.get_move
        elsif move == "l"
            load = YAML.load(File.read("save.yml"))
            board.grid.each do |row|
                row.map! {|tile| load.shift}
            end
            board.render
            self.get_move
        end
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
            board.render
            puts "You lose"
            if saves > 0
                load = YAML.load(File.read("save.yml"))    
                board.grid.each do |row|
                    row.map! {|tile| load.shift}
                end
                board.render
                self.get_move            
            else
                abort "Save next time"
            end
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
        puts "Enter f to flag or r to reveal or s to save or l to load"
        choice = gets.chomp
        if choice == "f" || choice == "r" || choice == "s" || choice == "l"
            return choice
        else
            puts "Invalid move"
            self.get_move
        end
    end

    def get_coordinates
        puts "Enter coordinates like 00"
        coordinates = gets.chomp.split("").map {|coord| coord.to_i}
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
