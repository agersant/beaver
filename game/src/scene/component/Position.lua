require( "src/utils/OOP" );

local Position = Class( "Position" );



-- PUBLIC API

Position.init = function( self )
	self._tx = 0;
	self._ty = 0;
end

Position.getInTiles = function( self )
	return self._tx, self._ty;
end

Position.setInTiles = function( self, x, y )
	self._tx = x;
	self._ty = y;
end


return Position;
