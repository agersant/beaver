require( "src/utils/OOP" );
local Log = require( "src/dev/Log" );
local Colors = require( "src/resources/Colors" );
local MathUtils = require( "src/utils/MathUtils" );
local TableUtils = require( "src/utils/TableUtils" );

local Map = Class( "Map" );



-- IMPLEMENTATION

-- Returns the following values, in pixels:
-- Width of the map bounding box
-- Height of the map bounding box
-- X position within the bounding box of the top-left of the tile located at (0, 0)
-- Y position within the bounding box of the top-left of the tile located at (0, 0)
local getPixelDimensions = function( self, mapData )
	local layers = mapData.content.layers;
	local tileHeight = self._tileset:getTileHeight();

	local w = ( self._width + self._height ) * self._tileWidth / 2;
	local h = ( self._width + self._height ) * self._tileHeight / 2;
	h = h + tileHeight - self._tileHeight;
	local yPadding = 0;
	for _, layerData in ipairs( layers ) do
		if layerData.type == "tilelayer" then
			yPadding = yPadding - layerData.offsety;
		end
	end
	assert( w % 2 == 0 );
	assert( h % 2 == 0 );
	assert( yPadding % 2 == 0 );
	return w, h + yPadding, w / 2 - self._tileWidth / 2, yPadding;
end

local initSpriteBatch = function( self, mapData )

	local layers = mapData.content.layers;
	local maxTiles = #layers * self._width * self._height;
	local tilesetImage = self._tileset:getImage();
	local quad = love.graphics.newQuad( 0, 0, 0, 0, tilesetImage:getDimensions() );
	local tilesetWidth = self._tileset:getWidthInTiles();
	local tileWidth = self._tileset:getTileWidth();
	local tileHeight = self._tileset:getTileHeight();
	local firstGID = self._tileset:getFirstGID();

	assert( tileWidth == self._tileWidth );
	assert( tileHeight >= self._tileHeight );

	self._batch = love.graphics.newSpriteBatch( tilesetImage, maxTiles );
	for _, layerData in ipairs( layers ) do
		if layerData.type == "tilelayer" then
			for tileNum, tileID in ipairs( layerData.data ) do
				if tileID >= firstGID then
					local tx, ty = MathUtils.indexToXY( tileID - firstGID, tilesetWidth );
					quad:setViewport( tx * tileWidth, ty * tileHeight, tileWidth, tileHeight );
					local x, y = MathUtils.indexToXY( tileNum - 1, self._width );
					local px = ( x - y ) * self._tileWidth / 2;
					local py = layerData.offsety + ( x + y ) * self._tileHeight / 2;
					self._batch:add( quad, px, py );
				end
			end
		end
	end

end

local initZBuffer = function( self, mapData )

	local layers = mapData.content.layers;
	local tilesetImage = self._tileset:getImage();
	local quad = love.graphics.newQuad( 0, 0, 0, 0, tilesetImage:getDimensions() );
	local tilesetWidth = self._tileset:getWidthInTiles();
	local tileWidth = self._tileset:getTileWidth();
	local tileHeight = self._tileset:getTileHeight();
	local firstGID = self._tileset:getFirstGID();

	love.graphics.reset();

	local flatShader = love.graphics.newShader( [[
		vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
        {
			vec4 texturecolor = Texel(texture, texture_coords);
			if (texturecolor.a == 0)
			{
				discard;
			}
            return color;
        }
		]] );
	love.graphics.setShader( flatShader );
	love.graphics.setBlendMode( "replace", "premultiplied" );

	local canvas = love.graphics.newCanvas( self._pixelWidth, self._pixelHeight, "rgba8" );
	love.graphics.setCanvas( canvas );

	for z, layerData in ipairs( layers ) do
		if layerData.type == "tilelayer" then
			for tileNum, tileID in ipairs( layerData.data ) do
				if tileID >= firstGID then
					local tx, ty = MathUtils.indexToXY( tileID - firstGID, tilesetWidth );
					quad:setViewport( tx * tileWidth, ty * tileHeight, tileWidth, tileHeight );
					local x, y = MathUtils.indexToXY( tileNum - 1, self._width );
					local px = self._pixelX + layerData.offsetx + ( x - y ) * self._tileWidth / 2 ;
					local py = self._pixelY + layerData.offsety + ( x + y ) * self._tileHeight / 2;
					local flags = 0;
					local tileData = self._tileset:getTileData( tileID );
					if tileData then
						flags = tileData.flags;
					end
					love.graphics.setColor( x, y, z, flags );
					love.graphics.draw( tilesetImage, quad, px, py );
				end
			end
		end
	end

	self._zBufferData = canvas:newImageData();
	self._zBuffer = love.graphics.newImage( self._zBufferData );
	self._zBuffer:setFilter( "nearest", "nearest", 0 );

end



-- PUBLIC API

Map.init = function( self, mapData, tileset )

	self._tileset = tileset;
	self._width = mapData.content.width;
	self._height = mapData.content.height;
	self._tileWidth = mapData.content.tilewidth;
	self._tileHeight = mapData.content.tileheight;
	self._pixelWidth, self._pixelHeight, self._pixelX, self._pixelY = getPixelDimensions( self, mapData );
	initSpriteBatch( self, mapData );
	initZBuffer( self, mapData );

	self._outlineShader = love.graphics.newShader( [[
		#extension GL_EXT_gpu_shader4 : enable

		const int slopeSW = 1 << 0;
		const int slopeSE = 1 << 1;
		const int slopeNW = 1 << 2;
		const int slopeNE = 1 << 3;

		extern float vDelta;
		vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
        {
			vec4 local = Texel(texture, texture_coords);
			vec4 down = Texel(texture, texture_coords + vec2( 0, vDelta ));
			if ( local.z >= down.z )
			{
				discard;
			}

			bool slopeNW = ( int( down.a * 255 ) & slopeNW ) != 0;
			if ( slopeNW && ( 1 + int( local.x * 255 ) ) == int( down.x * 255 ) )
			{
				discard;
			}

			bool slopeNE = ( int( down.a * 255 ) & slopeNE ) != 0;
			if ( slopeNE && ( 1 + int( local.y * 255 ) ) == int( down.y * 255 ) )
			{
				discard;
			}

			return color;
        }
	]] );
	self._outlineShader:send( "vDelta", 1 / self._zBuffer:getHeight() );
end

Map.getTileset = function( self )
	return self._tileset;
end

Map.draw = function( self )
	-- TMP
	love.graphics.clear( 0, 200, 160 );
	love.graphics.translate( self._pixelX, self._pixelY );

	love.graphics.draw( self._batch );

	love.graphics.translate( -self._pixelX, -self._pixelY );
	love.graphics.setColor( 0, 40, 100 );
	love.graphics.setShader( self._outlineShader );
	love.graphics.draw( self._zBuffer );
end



return Map;