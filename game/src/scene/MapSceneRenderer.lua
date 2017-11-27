require( "src/utils/OOP" );
local Log = require( "src/dev/Log" );
local GFXConfig = require( "src/graphics/GFXConfig" );
local Assets = require( "src/resources/Assets" );
local MathUtils = require( "src/utils/MathUtils" );

local MapSceneRenderer = Class( "MapSceneRenderer" );


-- SHADERS

local depthSortShader = [[
	extern Image zBuffer;
	extern vec2 screenSize;
	extern int depthThreshold;
	vec4 effect( vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords )
	{
		vec4 zBufferRead = Texel( zBuffer, screenCoords / screenSize );
		if ( int( zBufferRead.x * 255 ) + int( zBufferRead.y * 255 ) > depthThreshold ) {
			return vec4( 0, 0, 0, 0 );
		}
		vec4 local = Texel( texture, textureCoords );
		return local * color;
	}
]];

local silhouetteShader = [[
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
	{
		vec4 texturecolor = Texel(texture, texture_coords);
		if (texturecolor.a == 0)
		{
			discard;
		}
		return color;
	}
]];

local outlineShader = [[
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
]];


-- INIT

-- Returns the following values, in pixels:
-- Width of the map bounding box
-- Height of the map bounding box
-- X position within the bounding box of the top-left corner of the tile located at (0, 0)
-- Y position within the bounding box of the top-left corner of the tile located at (0, 0)
local getPixelDimensions = function( self )
	local map = self._mapScene:getMap();
	local tileset = map:getTileset();
	local tileImageHeight = tileset:getTileHeight();
	local tileWidth, tileHeight, tileAltitude = map:getTileDimensions();
	local mapWidth, mapHeight, mapAltitude = map:getDimensions();

	local w = ( mapWidth + mapHeight ) * tileWidth / 2;
	local h = ( mapWidth + mapHeight ) * tileHeight / 2;
	h = h + tileImageHeight - tileHeight;
	local yPadding = tileAltitude * ( mapAltitude - 1 );

	assert( w % 2 == 0 );
	assert( h % 2 == 0 );
	return w, h + yPadding, ( mapHeight - 1 ) * tileWidth / 2, yPadding;
end

local createTileBatch = function( self )

	local map = self._mapScene:getMap();
	local tileset = map:getTileset();
	local tilesetWidth = tileset:getWidthInTiles();
	local tileImageWidth = tileset:getTileWidth();
	local tileImageHeight = tileset:getTileHeight();
	local tilesetImage = tileset:getImage();
	local quad = love.graphics.newQuad( 0, 0, 0, 0, tilesetImage:getDimensions() );
	local tileWidth, tileHeight, tileAltitude = map:getTileDimensions();
	local mapWidth, mapHeight, mapAltitude = map:getDimensions();

	local maxTiles = mapWidth * mapHeight * mapAltitude;
	local batch = love.graphics.newSpriteBatch( tilesetImage, maxTiles );

	for z = 1, mapAltitude do
		for x = 0, mapWidth - 1 do
			for y = 0, mapHeight - 1 do
				local tileID = map:getTileAt( x, y, z );
				if tileID >= 0 then
					local tx, ty = MathUtils.indexToXY( tileID, tilesetWidth );
					quad:setViewport( tx * tileImageWidth, ty * tileImageHeight, tileImageWidth, tileImageHeight );
					local px = ( x - y ) * tileWidth / 2;
					local py = -( ( z - 1 ) * tileAltitude ) + ( x + y ) * tileHeight / 2;
					batch:add( quad, px, py );
				end
			end
		end
	end

	return batch;
end

local createMapZBuffer = function( self )

	local map = self._mapScene:getMap();
	local tileset = map:getTileset();
	local tilesetWidth = tileset:getWidthInTiles();
	local tileImageWidth = tileset:getTileWidth();
	local tileImageHeight = tileset:getTileHeight();
	local tilesetImage = tileset:getImage();
	local quad = love.graphics.newQuad( 0, 0, 0, 0, tilesetImage:getDimensions() );
	local tileWidth, tileHeight, tileAltitude = map:getTileDimensions();
	local mapWidth, mapHeight, mapAltitude = map:getDimensions();

	love.graphics.reset();

	local flatShader = love.graphics.newShader( silhouetteShader );
	love.graphics.setShader( flatShader );
	love.graphics.setBlendMode( "replace", "premultiplied" );

	local canvas = love.graphics.newCanvas( self._pixelWidth, self._pixelHeight, "rgba8" );
	love.graphics.setCanvas( canvas );

	for z = 1, mapAltitude do
		for x = 0, mapWidth - 1 do
			for y = 0, mapHeight - 1 do
				local tileID = map:getTileAt( x, y, z );
				if tileID >= 0 then
					local tx, ty = MathUtils.indexToXY( tileID, tilesetWidth );
					quad:setViewport( tx * tileImageWidth, ty * tileImageHeight, tileImageWidth, tileImageHeight );
					local h = ( z - 1 ) * tileAltitude;
					local px = self._originX + ( x - y ) * tileWidth / 2 ;
					local py = self._originY - h + ( x + y ) * tileHeight / 2;
					local flags = 0;
					local tileData = tileset:getTileData( tileID );
					if tileData then
						flags = tileData.flags;
					end
					love.graphics.setColor( x, y, z, flags );
					love.graphics.draw( tilesetImage, quad, px, py );
				end
			end
		end
	end

	local zBufferData = canvas:newImageData();
	local zBuffer = love.graphics.newImage( zBufferData );
	zBuffer:setFilter( "nearest", "nearest", 0 );
	return zBuffer;
end


-- PUBLIC API

MapSceneRenderer.init = function( self, mapScene )
	self._mapScene = mapScene;
	self._pixelWidth, self._pixelHeight, self._originX, self._originY = getPixelDimensions( self, mapData );
	self._tilesBatch = createTileBatch( self );
	self._mapZBuffer = createMapZBuffer( self );
	self._outlineShader = love.graphics.newShader( outlineShader );
	self._depthSortShader = love.graphics.newShader( depthSortShader );
	self._screenZBuffer = love.graphics.newCanvas( 1, 1 );
	self._surfaceTile = Assets:getImage( "assets/code/water/surface.png" );
end

MapSceneRenderer.draw = function( self )

	local map = self._mapScene:getMap();

	love.graphics.clear(  120, 120, 120 );

	-- Draw tiles
	love.graphics.draw( self._tilesBatch );

	-- Draw outlines
	love.graphics.push();
	love.graphics.translate( -self._originX, -self._originY );
	love.graphics.setColor( 0, 40, 100 );
	love.graphics.setShader( self._outlineShader );
	self._outlineShader:send( "vDelta", 1 / self._mapZBuffer:getHeight() );
	love.graphics.draw( self._mapZBuffer );
	love.graphics.pop();

	-- Make sure we have a zBuffer canvas to draw too
	local zBufferWidth, zBufferHeight = self._screenZBuffer:getDimensions();
	local windowWidth, windowHeight = GFXConfig:getWindowSize();
	if zBufferWidth ~= windowWidth or zBufferHeight ~= windowHeight then
		Log:info( "Re-allocating MapScene Z Buffer" );
		self._screenZBuffer = love.graphics.newCanvas( windowWidth, windowHeight );
	end

	-- Draw mapZBuffer onto screenZBuffer
	love.graphics.setCanvas( self._screenZBuffer );
	love.graphics.clear();
	love.graphics.setShader();
	love.graphics.setColor( 255, 255, 255 );
	love.graphics.setBlendMode( "replace", "premultiplied" );
	love.graphics.draw( self._mapZBuffer, -self._originX, -self._originY );
	love.graphics.setCanvas();

	-- Setup depth sort shader
	local w, h = GFXConfig:getWindowSize();
	love.graphics.setShader( self._depthSortShader );
	self._depthSortShader:send( "zBuffer", self._screenZBuffer );
	self._depthSortShader:send( "screenSize", { w, h } );
	love.graphics.setBlendMode( "alpha", "alphamultiply" );

	-- Draw water
	local waterSim = self._mapScene:getWaterSim();
	local w, h = map:getDimensions();
	local tileWidth, tileHeight, tileAltitude = map:getTileDimensions();
	for x = 0, w - 1 do
		for y = 0, h - 1 do
			local h = math.ceil( waterSim:getWaterLevelAt( x, y ) * tileAltitude );
			if h > 0 then
				love.graphics.setColor( 0, 180, 200, h * 80 );
				local tx, ty = map:tilesToPixels( x, y );
				self._depthSortShader:send( "depthThreshold", x + y );
				love.graphics.draw( self._surfaceTile, tx - tileWidth / 2, ty - 0.5 * tileHeight );
				love.graphics.rectangle( "fill", tx - tileWidth / 2, ty - h, tileWidth, h );
				love.graphics.draw( self._surfaceTile, tx - tileWidth / 2, ty - 0.5 * tileHeight - h );
			end
		end
	end

	-- Draw entities
	love.graphics.setColor( 255, 255, 255 );
	for _, entity in ipairs( self._mapScene:getDrawableEntities() ) do
		local depth = entity:getPosition():getDepth();
		self._depthSortShader:send( "depthThreshold", depth );
		entity:draw();
	end

end



return MapSceneRenderer;
