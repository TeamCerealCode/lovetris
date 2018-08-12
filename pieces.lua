local Piece = require 'piece'

_G.colors = {
    {0.059, 0.608, 0.843}, -- IPiece
    {0.129, 0.255, 0.776}, -- JPiece
    {0.890, 0.357, 0.008}, -- LPiece
    {0.890, 0.624, 0.008}, -- OPiece
    {0.349, 0.694, 0.004}, -- SPiece
    {0.686, 0.161, 0.541}, -- TPiece
    {0.843, 0.059, 0.216}, -- ZPiece
    {0.784, 0.784, 0.784}  -- Garbage blocks
}

_G.wallkicks = {}

wallkicks[2] = { -- J
    [1] = {
        cw = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}},
        ccw = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}
    },
    [2] = {
        cw = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}},
        ccw = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}}
    },
    [3] = {
        cw = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}},
        ccw = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}},
    },
    [4] = {
        cw = {{0, 0}, {-1, 0}, {-1, 1}, {0, 2}, {-1, -2}},
        ccw = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}}
    }
}

wallkicks[3] = wallkicks[2] -- L
wallkicks[5] = wallkicks[2] -- S
wallkicks[6] = wallkicks[2] -- Z
wallkicks[7] = wallkicks[2] -- T

wallkicks[1] = { -- I
    [1] = {
        cw = {{0, 0}, {-2, 0}, {1, 0}, {-2, 1}, {1, -2}},
        ccw = {{0, 0}, {-1, 0}, {2, 0}, {-1, -2}, {2, 1}}
    },
    [2] = {
        cw = {{0, 0}, {-1, 0}, {2, 0}, {-1, -2}, {2, 1}},
        ccw = {{0, 0}, {2, 0}, {-1, 0}, {2, -1}, {-1, 2}}
    },
    [3] = {
        cw = {{0, 0}, {2, 0}, {-1, 0}, {2, -1}, {-1, 2}},
        ccw = {{0, 0}, {1, 0}, {-2, 0}, {1, 2}, {-2, -1}},
    },
    [4] = {
        cw = {{0, 0}, {1, 0}, {-2, 0}, {1, 2}, {-2, -1}},
        ccw = {{0, 0}, {-2, 0}, {1, 0}, {-2, 1}, {1, -2}}
    }
}

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
