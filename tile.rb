require "byebug"
class Tile
    attr_accessor :mine, :value, :face_value, :revealed, :neighbors, :checked
    def initialize
        @mine = false
        @face_value = "*"
        @value = "O"
        @neighbors = []
        @revealed = false
        @checked = false
    end

    def flag
        if face_value == "F"
            @face_value = "*"
        else
            @face_value = "F"
        end
    end

    def reveal
        if @face_value == "*"   
            @face_value = ""
            @face_value += value
            @revealed = true
        end
    end
end