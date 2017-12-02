require( "src/utils/OOP" );
local Log = require( "src/dev/Log" );
local GFXConfig = require( "src/graphics/GFXConfig" );
local Assets = require( "src/resources/Assets" );
local MathUtils = require( "src/utils/MathUtils" );

local MapSceneRenderer = Class( "MapSceneRenderer" );


-- SHADERS

local debugZBufferShader = [[
	vec4 effect( vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords )
	{
		vec4 local = Texel( texture, textureCoords );
		local *= color * vec4( 10, 10, 10, 1 );
		local.a = 1;
		return local;
	}
]];

local depthSortShader = [[
	extern Image zBuffer;
	extern int depthThreshold;
	vec4 effect( vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords )
	{
		vec4 zBufferRead = Texel( zBuffer, screenCoords / love_ScreenSize.xy );
		if ( int( zBufferRead.x * 255 ) + int( zBufferRead.y * 255 ) > depthThreshold ) {
			return vec4( 0, 0, 0, 0 );
		}
		vec4 local = Texel( texture, textureCoords );
		return local * color;
	}
]];

local depthWriteShader = [[
#ifdef VERTEX
	attribute vec4 mData;
	varying out vec4 data;
	vec4 position( mat4 transformProjection, vec4 vertexPosition )
	{
		data = mData;
		return transformProjection * vertexPosition;
	}
#endif

#ifdef PIXEL
	extern Image zBuffer;
	in vec4 data;

	vec4 effect( vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords )
	{
		vec4 texturecolor = Texel( texture, textureCoords );
		if (texturecolor.a == 0)
		{
			discard;
		}
		vec4 zBufferRead = Texel( zBuffer, screenCoords / love_ScreenSize.xy );
		if ( int( zBufferRead.x * 255 ) + int( zBufferRead.y * 255 ) > int( data.x * 255 ) + int( data.y * 255 ) ) {
			discard;
		}
		return data;
	}
#endif
]];

local outlineShader = [[
	#extension GL_EXT_gpu_shader4 : enable

	const int slopeSW = 1 << 0;
	const int slopeSE = 1 << 1;
	const int slopeNW = 1 << 2;
	const int slopeNE = 1 << 3;

	extern float vDelta;
	vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords)
	{
		vec4 local = Texel(texture, textureCoords);
		vec4 down = Texel(texture, textureCoords + vec2( 0, vDelta / love_ScreenSize.y ) );
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

local waterShader = [[

	#ifdef VERTEX
		attribute vec4 mData;
		attribute vec4 waterData;
		varying out vec4 data;
		varying out vec4 pixelWaterData;
		vec4 position( mat4 transformProjection, vec4 vertexPosition )
        {
			data = mData;
			pixelWaterData = waterData;
            return transformProjection * vertexPosition;
        }
	#endif

	#ifdef PIXEL
		extern Image zBuffer;
		extern vec2 tileSize;
		in vec4 data;
		in vec4 pixelWaterData;
		vec4 effect( vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords )
		{

			textureCoords.x = int( textureCoords.x );
			textureCoords.y = int( textureCoords.y );

			// Drop top-left corner pixels
			if ( textureCoords.x + 2 < tileSize.x / 2 - 2 * textureCoords.y )
			{
				discard;
			}

			// Drop top-right corner pixels
			if ( textureCoords.x - 1 > tileSize.x / 2 + 2 * textureCoords.y )
			{
				discard;
			}

			// Drop bottom-left corner pixels
			if ( textureCoords.y > pixelWaterData.y * 255 - tileSize.y / 2 + textureCoords.x / 2 )
			{
				discard;
			}

			// Drop bottom-right corner pixels
			if ( textureCoords.y + 0.5 > pixelWaterData.y * 255 + tileSize.y / 2 - textureCoords.x / 2 )
			{
				discard;
			}

			// Drop Z-sorted pixels
			vec4 zBufferRead = Texel( zBuffer, screenCoords / love_ScreenSize.xy );
			if ( int( zBufferRead.x * 255 ) + int( zBufferRead.y * 255 ) > int( data.x * 255 ) + int( data.y * 255 ) ) {
				discard;
			}

			vec4 local = Texel( texture, textureCoords );
			return local * color;
		}
	#endif
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
	local batch = love.graphics.newSpriteBatch( tilesetImage, maxTiles, "static" );
	local mesh = love.graphics.newMesh( { { "mData", "byte", 4 } }, 4 * batch:getBufferSize(), "fan", "static" );

	for z = 1, mapAltitude do
		for x = 0, mapWidth - 1 do
			for y = 0, mapHeight - 1 do
				local tileID = map:getTileAt( x, y, z );
				if tileID >= 0 then
					local tx, ty = MathUtils.indexToXY( tileID, tilesetWidth );
					quad:setViewport( tx * tileImageWidth, ty * tileImageHeight, tileImageWidth, tileImageHeight );
					local px = ( x - y ) * tileWidth / 2;
					local py = -( ( z - 1 ) * tileAltitude ) + ( x + y ) * tileHeight / 2;
					local id = batch:add( quad, px, py );

					local flags = 0;
					local tileData = tileset:getTileData( tileID );
					if tileData then
						flags = tileData.flags;
					end
					for i = 1, 4 do
						mesh:setVertex( 4 * ( id - 1 ) + i, x, y, z, flags );
					end
				end
			end
		end
	end

	batch:attachAttribute( "mData", mesh );
	return batch, mesh;
end

-- PUBLIC API

MapSceneRenderer.init = function( self, mapScene )
	self._mapScene = mapScene;
	self._pixelWidth, self._pixelHeight, self._originX, self._originY = getPixelDimensions( self, mapData );
	self._tilesBatch, self._tilesMesh = createTileBatch( self );

	self._depthWriteShader = love.graphics.newShader( depthWriteShader );
	self._outlineShader = love.graphics.newShader( outlineShader );
	self._depthSortShader = love.graphics.newShader( depthSortShader );
	self._waterShader = love.graphics.newShader( waterShader );
	self._debugZBufferShader = love.graphics.newShader( debugZBufferShader );

	local surfaceTile = Assets:getImage( "assets/code/water/surface.png" );
	local mapWidth, mapHeight = mapScene:getMap():getDimensions();
	self._waterBatch = love.graphics.newSpriteBatch( surfaceTile, mapWidth * mapHeight, "stream" );
	self._waterMesh = love.graphics.newMesh( {
		{ "mData", "byte", 4 },
		{ "waterData", "byte", 4 },
		{ "VertexTexCoord", "float", 2 },
	}, 4 * self._waterBatch:getBufferSize(), "fan", "stream" );
	self._waterBatch:attachAttribute( "mData", self._waterMesh );
	self._waterBatch:attachAttribute( "waterData", self._waterMesh );
	self._waterBatch:attachAttribute( "VertexTexCoord", self._waterMesh );
end

MapSceneRenderer.drawScreen = function( self )

	local camera = self._mapScene:getCamera();
	local map = self._mapScene:getMap();
	local mapWidth, mapHeight = map:getDimensions();
	local tileWidth, tileHeight, tileAltitude = map:getTileDimensions();

	-- Make sure we have a zBuffer canvas to draw too
	local zBufferWidth, zBufferHeight = 0, 0;
	if self._screenZBuffer then
		zBufferWidth, zBufferHeight = self._screenZBuffer:getDimensions();
	end
	local windowWidth, windowHeight = GFXConfig:getWindowSize();
	if zBufferWidth ~= windowWidth or zBufferHeight ~= windowHeight then
		Log:info( "Re-allocating MapScene Z Buffer" );
		self._screenZBuffer = love.graphics.newCanvas( windowWidth, windowHeight );
		self._screenZBuffer:setFilter( "nearest", "nearest" );
	end

	love.graphics.clear( 120, 120, 120 );
	love.graphics.setColor( 255, 255, 255 );
	love.graphics.setCanvas( self._screenZBuffer );
	love.graphics.clear();


	love.graphics.push();
	camera:applyTransforms();

	-- Draw tiles on screen
	love.graphics.setCanvas();
	love.graphics.draw( self._tilesBatch );

	-- Draw tiles on ZBuffer
	love.graphics.setCanvas( self._screenZBuffer );
	love.graphics.setBlendMode( "replace", "premultiplied" );
	self._depthWriteShader:send( "zBuffer", self._screenZBuffer );
	love.graphics.setShader( self._depthWriteShader );
	love.graphics.draw( self._tilesBatch );

	love.graphics.pop();

	-- Draw outlines on screen
	love.graphics.setCanvas();
	love.graphics.setBlendMode( "alpha", "alphamultiply" );
	self._outlineShader:send( "vDelta", camera:getZoom() );
	love.graphics.setShader( self._outlineShader );
	love.graphics.setColor( 0, 0, 0, 255 );
	love.graphics.draw( self._screenZBuffer );

	love.graphics.push();
	camera:applyTransforms();

	-- Draw water on screen
	self._waterBatch:clear();
	local quad = love.graphics.newQuad( 0, 0, 0, 0, tileWidth, tileHeight );
	local waterSim = self._mapScene:getWaterSim();
	for x = 0, mapWidth - 1 do
		for y = 0, mapHeight - 1 do
			local h = math.ceil( waterSim:getWaterLevelAt( x, y ) * tileAltitude );
			if h > 0 then
				local z = math.ceil( waterSim:getWaterLevelAt( x, y ) + map:getAltitude( x, y ) );
				local tx, ty = map:tilesToPixels( x, y );
				local px, py = tx - tileWidth / 2, ty - 0.5 * tileHeight - h;
				quad:setViewport( 0, 0, tileWidth, h + tileHeight );
				local id = self._waterBatch:add( quad, px, py );
				for i = 1, 4 do
					self._waterMesh:setVertex( 4 * ( id - 1 ) + i,
						-- Map data
						x, y, z, 0,
						-- Water data
						0, h + tileHeight, 0, 0,
						-- VertexTexCoord
						( i == 3 or i == 4 ) and tileWidth or 0,
						( i == 2 or i == 4 ) and ( h + tileHeight ) or 0
					);
				end
			end
		end
	end

	love.graphics.setShader( self._waterShader );
	love.graphics.setColor( 0, 100, 150, 200 );
	self._waterShader:send( "zBuffer", self._screenZBuffer );
	self._waterShader:send( "tileSize", { tileWidth, tileHeight } );
	love.graphics.setBlendMode( "alpha", "alphamultiply" );
	love.graphics.draw( self._waterBatch );

	-- Draw water on ZBuffer
	love.graphics.setCanvas( self._screenZBuffer );
	love.graphics.setBlendMode( "replace", "premultiplied" );
	self._depthWriteShader:send( "zBuffer", self._screenZBuffer );
	love.graphics.setShader( self._depthWriteShader );
	love.graphics.draw( self._waterBatch );

	-- Draw entities on screen
	love.graphics.setCanvas();
	love.graphics.setBlendMode( "alpha", "alphamultiply" );
	self._depthSortShader:send( "zBuffer", self._screenZBuffer );
	love.graphics.setShader( self._depthSortShader );

	love.graphics.setColor( 255, 255, 255 );
	for _, entity in ipairs( self._mapScene:getDrawableEntities() ) do
		local depth = entity:getPosition():getDepth();
		self._depthSortShader:send( "depthThreshold", depth );
		entity:draw();
	end

	love.graphics.pop();

	-- self:drawZBuffer();

	-- print("");
	-- local stats = love.graphics.getStats();
	-- for k, v in pairs( stats ) do
	-- 	print(k, v);
	-- end
end

MapSceneRenderer.drawZBuffer = function( self )
	love.graphics.setCanvas();
	love.graphics.setShader( self._debugZBufferShader );
	love.graphics.setColor( 255, 255, 255, 255 );
	love.graphics.setBlendMode( "alpha", "alphamultiply" );
	love.graphics.draw( self._screenZBuffer );
end

return MapSceneRenderer;
