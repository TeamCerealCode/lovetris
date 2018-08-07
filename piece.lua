local Piece = class('Piece')

function Piece:initialize(x, y, type, size)
    self.x = x
    self.y = y
    self.type = type
    self.size = size
    self.grid = {}
    for i = 0, size-1 do
        row = {}
        for j = 0, size-1 do
            row[j] = 0
        end
        self.grid[i] = row
    end
end



return Piece