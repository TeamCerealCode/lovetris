local Piece = require 'piece'

_G.IPiece = class('IPiece', Piece)
_G.JPiece = class('TJiece', Piece)
_G.LPiece = class('LPiece', Piece)
_G.OPiece = class('OPiece', Piece)
_G.SPiece = class('SPiece', Piece)
_G.ZPiece = class('ZPiece', Piece)
_G.TPiece = class('TPiece', Piece)

function _G.getPiece(t)
    if t == 1 then
        return IPiece
    elseif t == 2 then
        return JPiece
    elseif t == 3 then
        return LPiece
    elseif t == 4 then
        return OPiece
    elseif t == 5 then
        return SPiece
    elseif t == 6 then
        return ZPiece
    elseif t == 7 then
        return TPiece
    end
end


function IPiece:initialize(x, y)
    Piece.initialize(self, x, y, 1, 4)
    self.grid = {
        {0, 0, 0, 0},
        {1, 1, 1, 1},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
    }
end

function JPiece:initialize(x,y)
    Piece.initialize(self, x, y, 2, 3);
    self.grid = {
        {1, 0, 0},
        {1, 1, 1},
        {0, 0, 0},
    }
end

function LPiece:initialize(x,y)
    Piece.initialize(self, x, y, 3, 3)
    self.grid = {
        {0, 0, 1},
        {1, 1, 1},
        {0, 0, 0},
    }
end

function OPiece:initialize(x, y)
    Piece.initialize(self, x, y, 4, 2)
    self.grid = {
        {1, 1},
        {1, 1},
    }
end

function SPiece:initialize(x,y)
    Piece.initialize(self, x, y, 5, 3)
    self.grid = {
        {0, 1, 1},
        {1, 1, 0},
        {0, 0, 0},
    }
end

function ZPiece:initialize(x,y)
    Piece.initialize(self, x, y, 6, 3)
    self.grid = {
        {1, 1, 0},
        {0, 1, 1},
        {0, 0, 0},
    }
end

function TPiece:initialize(x, y)
    Piece.initialize(self, x, y, 7, 3)
    self.grid = {
        {0, 1, 0},
        {1, 1, 1},
        {0, 0, 0},
    }
end
