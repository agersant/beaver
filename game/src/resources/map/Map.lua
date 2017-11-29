require( "src/utils/OOP" );
local Log = require( "src/dev/Log" );
local Colors = require( "src/resources/Colors" );
local MathUtils = require( "src/utils/MathUtils" );
local TableUtils = require( "src/utils/TableUtils" );

local Map = Class( "Map" );



-- IMPLEMENTATION

local initWater = function( self, mapData )
	self._waterSources = {};
	self._waterFills = {};
	for _, layerData in ipairs( mapData.content.layers ) do
		if layerData.type == "objectgroup" then
			for _, object in ipairs( layerData.objects ) do
				if object.type == "source" then
					local x = math.floor( object.x / ( self._tileWidth / 2 ) );
					local y = math.floor( object.y / self._tileHeight );
					local flow = 1;
					if object.properties and object.properties.flow then
						flow = object.properties.flow;
					end
					table.insert( self._waterSources, { x = x, y = y, flow = flow } );
				end
				if object.type == "fill" then
					local x = math.floor( object.x / ( self._tileWidth / 2 ) );
					local y = math.floor( object.y / self._tileHeight );
					local height = 1;
					if object.properties and object.properties.height then
						height = object.properties.height or 1;
					end
					table.insert( self._waterFills, { x = x, y = y, height = height } );
				end
			end
		end
	end
end

local initTopography = function( self, mapData )
	self._altitudes = {};
	self._layers = {};

	local tilesetWidth = self._tileset:getWidthInTiles();
	local firstGID = self._tileset:getFirstGID();
	for _, layerData in ipairs( mapData.content.layers ) do
		if layerData.type == "tilelayer" then
			local layer = {};
			if not self._layerHeight or self._layerHeight == 0 then
				self._layerHeight = math.abs( layerData.offsety );
			end
			for tileNum, tileID in ipairs( layerData.data ) do
				local x, y = MathUtils.indexToXY( tileNum - 1, self._width );
				layer[x] = layer[x] or {};
				self._altitudes[x] = self._altitudes[x] or {};
				if tileID >= firstGID then
					layer[x][y] = tileID - firstGID;
					self._altitudes[x][y] = 1 + #self._layers;
				else
					layer[x][y] = -1;
					if not self._altitudes[x][y] then
						self._altitudes[x][y] = 0;
					end
				end
			end
			table.insert( self._layers, layer );
		end
	end

	assert( #self._layers > 0 );
	assert( self._layerHeight > 0 );
end



-- PUBLIC API

Map.init = function( self, mapData, tileset )
	self._tileset = tileset;
	self._width = mapData.content.width;
	self._height = mapData.content.height;
	self._tileWidth = mapData.content.tilewidth;
	self._tileHeight = mapData.content.tileheight;
	initWater( self, mapData );
	initTopography( self, mapData );
end

Map.getTileset = function( self )
	return self._tileset;
end

-- Get pixel position of the center of a tile at position (x, y)
Map.tilesToPixels = function( self, x, y )
	local tileHeight = self._tileset:getTileHeight();

	local tx1 = math.floor( x );
	local tx2 = math.ceil( x );
	local ty1 = math.floor( y );
	local ty2 = math.ceil( y );
	local tz1 = self._altitudes[tx1][ty1];
	local tz2 = self._altitudes[tx2][ty2];

	local x1 = ( tx1 - ty1 ) * self._tileWidth / 2;
	local y1 = ( tx1 + ty1 ) * self._tileHeight / 2;
	local x2 = ( tx2 - ty2 ) * self._tileWidth / 2;
	local y2 = ( tx2 + ty2 ) * self._tileHeight / 2;
	local z1 = tz1 * self._layerHeight;
	local z2 = tz2 * self._layerHeight;

	local t = 0;
	if tx2 ~= tx1 or ty2 ~= ty1 then
		t = ( math.abs( x - tx1 ) + math.abs( y - ty1 ) ) / ( math.abs( tx2 - tx1 ) + math.abs( ty2 - ty1 ) );
	end
	local x = MathUtils.lerp( x1, x2, t );
	local y = MathUtils.lerp( y1, y2, t );
	local z = MathUtils.lerp( z1, z2, t );

	x = x + self._tileWidth / 2;
	y = y + tileHeight - self._tileHeight / 2 - z;
	return x, y;
end

Map.getDimensions = function( self )
	return self._width, self._height, #self._layers;
end

Map.getTileDimensions = function( self )
	return self._tileWidth, self._tileHeight, self._layerHeight;
end

Map.getPixelDimensions = function( self )
	return self._pixelWidth, self._pixelHeight, self._pixelX, self._pixelY;
end

Map.getTileAt = function( self, x, y, z )
	local tileID = self._layers[z][x][y];
	assert( tileID );
	return tileID;
end

Map.getAltitude = function( self, x, y )
	assert( x >= 0 );
	assert( x < self._width );
	assert( y >= 0 );
	assert( y < self._height );
	return self._altitudes[x][y];
end

Map.getWaterSources = function( self )
	return self._waterSources;
end

Map.getWaterFills = function( self )
	return self._waterFills;
end



return Map;
