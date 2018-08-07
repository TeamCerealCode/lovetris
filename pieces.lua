local Piece = require 'piece'

_G.OPiece = class('OPiece', Piece)
_G.TPiece = class('TPiece', Piece)

function OPiece:initialize(x,y)
    Piece.initialize(self, x, y, 4, 2)
    self.grid[0] = {1, 1}
    self.grid[1] = {1, 0} -- for debug purposes
end

function TPiece:initialize(x,y)
    Piece.initialize(self, x, y, 7, 3)
    self.grid[0] = {0, 1, 0}
    self.grid[1] = {1, 1, 1}
    self.grid[2] = {0, 0, 0}
end
