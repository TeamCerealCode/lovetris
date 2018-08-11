local Piece = require 'piece'

_G.IPiece = class('IPiece', Piece)
_G.JPiece = class('TJiece', Piece)
_G.LPiece = class('LPiece', Piece)
_G.OPiece = class('OPiece', Piece)
_G.SPiece = class('SPiece', Piece)
_G.ZPiece = class('ZPiece', Piece)
_G.TPiece = class('TPiece', Piece)

function IPiece:initialize(x,y)
    Piece.initialize(self, x, y, 1, 4)
    self.grid[1] = {0, 0, 0, 0}
    self.grid[2] = {1, 1, 1, 1}
    self.grid[3] = {0, 0, 0, 0}
    self.grid[4] = {0, 0, 0, 0}
    
end

function JPiece:initialize(x,y)
    Piece.initialize(self, x, y, 2, 3);
    self.grid[1] = {1, 0, 0}
    self.grid[2] = {1, 1, 1}
    self.grid[3] = {0, 0, 0}
    
end

function LPiece:initialize(x,y)
    Piece.initialize(self, x, y, 3, 3)
    self.grid[1] = {0, 0, 1}
    self.grid[2] = {1, 1, 1}
    self.grid[3] = {0, 0, 0}
    
end

function OPiece:initialize(x,y)
    Piece.initialize(self, x, y, 4, 2)
    self.grid[1] = {1, 1}
    self.grid[2] = {1, 1}
end

function SPiece:initialize(x,y)
    Piece.initialize(self, x, y, 5, 3)
    self.grid[1] = {0, 1, 1}
    self.grid[2] = {1, 1, 0}
    self.grid[3] = {0, 0, 0}
end

function ZPiece:initialize(x,y)
    Piece.initialize(self, x, y, 6, 3)
    self.grid[1] = {1, 1, 0}
    self.grid[2] = {0, 1, 1}
    self.grid[3] = {0, 0, 0}
end

function TPiece:initialize(x,y)
    Piece.initialize(self, x, y, 7, 3)
    self.grid[1] = {0, 1, 0}
    self.grid[2] = {1, 1, 1}
    self.grid[3] = {0, 0, 0}
end
