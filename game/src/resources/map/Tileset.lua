require( "src/utils/OOP" );
local bit = require("bit");
local MathUtils = require( "src/utils/MathUtils" );

local Tileset = Class( "Tileset" );



-- PUBLIC API

Tileset.init = function( self, tilesetData, image )
	self._image = image;
	self._tileWidth = tilesetData.tilewidth;
	self._tileHeight = tilesetData.tileheight;
	self._widthInPixels = self._image:getDimensions();
	self._widthInTiles = math.floor( self._widthInPixels / self._tileWidth );
	self._firstGID = tilesetData.firstgid;

	self._tiles = {};
	for tileIndex, tileData in ipairs( tilesetData.tiles ) do
		local data = {
			slopeSW = tileData.objectGroup.properties.slopeSW ~= nil,
			slopeSE = tileData.objectGroup.properties.slopeSE ~= nil,
			slopeNW = tileData.objectGroup.properties.slopeNW ~= nil,
			slopeNE = tileData.objectGroup.properties.slopeNE ~= nil,
		};
		data.flags = 0;
		if data.slopeSW then
			data.flags = bit.bor( data.flags, bit.lshift( 1, 0 ) );
		end
		if data.slopeSE then
			data.flags = bit.bor( data.flags, bit.lshift( 1, 1 ) );
		end
		if data.slopeNW then
			data.flags = bit.bor( data.flags, bit.lshift( 1, 2 ) );
		end
		if data.slopeNE then
			data.flags = bit.bor( data.flags, bit.lshift( 1, 3 ) );
		end
		self._tiles[self._firstGID + tileData.id] = data;
	end
end

Tileset.getImage = function( self )
	return self._image;
end

Tileset.getTileData = function( self, tileID )
	return self._tiles[tileID];
end

Tileset.getFirstGID = function( self )
	return self._firstGID;
end

Tileset.getWidthInTiles = function( self )
	return self._widthInTiles;
end

Tileset.getTileWidth = function( self )
	return self._tileWidth;
end

Tileset.getTileHeight = function( self )
	return self._tileHeight;
end


return Tileset;
