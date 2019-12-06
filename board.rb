require_relative "tile"
require "byebug"
class Board
    attr_reader :size
    def initialize(size)
        @grid = Array.new(size) {Array.new(size) {Tile.new}}
        @size = size
    end

    def place_mines
        mine_count = size
        while mine_count > 0
            y = rand(0...size)
            x = rand(0...size)
            if grid[y][x].mine == false
                grid[y][x].mine = true
                grid[y][x].value = "@"
                mine_count -= 1
            end
        end
    end

    def find_neighbors
        grid.each_with_index do |row, y|
            row.each_with_index do |tile, x|
                tile.neighbors << grid[y][x + 1] if x + 1 < size
                tile.neighbors << grid[y][x - 1] if x - 1 >= 0
                tile.neighbors << grid[y + 1][x] if y + 1 < size
                tile.neighbors << grid[y - 1][x] if y - 1 >= 0
                tile.neighbors << grid[y + 1][x + 1] if y + 1 < size && x + 1 < size
                tile.neighbors << grid[y + 1][x - 1] if y + 1 < size && x - 1 >= 0
                tile.neighbors << grid[y - 1][x + 1] if y - 1 >= 0 && x + 1 < size
                tile.neighbors << grid[y - 1][x - 1] if y - 1 >= 0 && x - 1 >= 0
            end
        end
    end

    def place_numbers
        grid.each do |row|
            row.each do |tile|
                #debugger
                adjacent_mines = 0
                tile.neighbors.each {|neighbor| adjacent_mines += 1 if neighbor.mine == true}
                tile.value = adjacent_mines.to_s if adjacent_mines > 0 && tile.mine == false
            end
        end
    end

    def render
        puts "  " + (0...size).to_a.join(" ")
        grid.each_with_index do |row, i|
            puts i.to_s + " " + row.map {|tile| tile.face_value}.join(" ")
        end
        puts
    end
    
    def find_tile(y, x)
        grid[y][x]
    end

    def reveal_all
        grid.each do |row|
            row.each {|tile| tile.reveal}
        end
    end

    attr_accessor :grid
end
