local Piece = require 'piece'

_G.IPiece = class('IPiece', Piece)
_G.OPiece = class('OPiece', Piece)
_G.TPiece = class('TPiece', Piece)

function IPiece:initialize(x, y)
    Piece.initialize(self, x, y, 1, 4)
    self.grid = {
        {0, 0, 0, 0},
        {1, 1, 1, 1},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
    }
end

function OPiece:initialize(x, y)
    Piece.initialize(self, x, y, 4, 2)
    self.grid = {
        {1, 1},
        {1, 1},
    }
end

function TPiece:initialize(x, y)
    Piece.initialize(self, x, y, 6, 3)
    self.grid = {
        {0, 1, 0},
        {1, 1, 1},
        {0, 0, 0},
    }
end
