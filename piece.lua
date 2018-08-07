local Piece = class('Piece')

function Piece:initialize(x, y, type)
   self.x = x
   self.y = y
   self.type = type
end



return Piece