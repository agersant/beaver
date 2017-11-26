require( "src/utils/OOP" );
local GFXConfig = require( "src/graphics/GFXConfig" );
local Log = require( "src/dev/Log" );
local Input = require( "src/input/Input" );
local Assets = require( "src/resources/Assets" );
local Camera = require( "src/scene/Camera" );
local Scene = require( "src/scene/Scene" );
local WaterSim = require( "src/scene/WaterSim" );
local TableUtils = require( "src/utils/TableUtils" );

-- TMP
local Beaver = require( "src/content/Beaver" );

local MapScene = Class( "MapScene", Scene );



-- IMPLEMENTATION

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

local removeDespawnedEntitiesFrom = function( self, list )
	for i = #list, 1, -1 do
		local entity = list[i];
		if self._despawnedEntities[entity] then
			table.remove( list, i );
		end
	end
end

local handleInput = function( self )
	local inputDevice = Input:getDevice( 1 );
	for _, commandEvent in inputDevice:pollEvents() do
		if commandEvent == "+zoomIn" then
			self._camera:zoomIn();
		elseif commandEvent == "+zoomOut" then
			self._camera:zoomOut();
		end
	end
end



-- PUBLIC API

MapScene.init = function( self, mapName )
	Log:info( "Instancing scene for map: " .. tostring( mapName ) );
	MapScene.super.init( self );

	self._entities = {};
	self._updatableEntities = {};
	self._drawableEntities = {};
	self._spawnedEntities = {};
	self._despawnedEntities = {};

	self._mapName = mapName;
	self._map = Assets:getMap( mapName );
	self._waterSim = WaterSim:new( self._map );

	self._camera = Camera:new( self._map );

	self._zBuffer = love.graphics.newCanvas( GFXConfig:getWindowSize() );
	self._depthSortShader = love.graphics.newShader( depthSortShader );

	-- TMP

	-- River
	-- self._waterSim:setWaterSource( 0, 4, 1 );
	-- self._waterSim:setWaterSource( 0, 5, 1 );
	-- self._waterSim:setWaterSource( 0, 6, 1 );
	-- self._waterSim:setWaterSource( 19, 4, 1 );
	-- self._waterSim:setWaterSource( 19, 5, 1 );
	-- self._waterSim:setWaterSource( 19, 6, 1 );

	-- Cascade
	-- self._waterSim:setWaterSource( 6, 0, 1 );
	-- self._waterSim:setWaterSource( 7, 0, 1 );

	-- Dam
	self._waterSim:setWaterSource( 0, 4, 1 );
	self._waterSim:setWaterSource( 0, 5, 1 );
	self._waterSim:setWaterSource( 0, 6, 1 );
	self._waterSim:setWaterSource( 0, 7, 1 );
	self._waterSim:setWaterSource( 0, 8, 1 );

	self._beaver = Beaver:new( self );
	self._beaver:getPosition():setInTiles( 5, 9 );
end

MapScene.update = function( self, dt )
	MapScene.super.update( self, dt );

	-- Update water sim
	self._waterSim:update( dt );

	-- Process inputs
	handleInput( self );

	-- Update entities
	for _, entity in ipairs( self._updatableEntities ) do
		entity:update( dt );
	end

	-- Add new entities
	for entity, _ in pairs( self._spawnedEntities ) do
		table.insert( self._entities, entity );
		if entity:isDrawable() then
			table.insert( self._drawableEntities, entity );
		end
	end
	for entity, _ in pairs( self._spawnedEntities ) do
		if entity:isUpdatable() then
			table.insert( self._updatableEntities, entity );
			entity:update( 0 );
		end
	end
	self._spawnedEntities = {};

	-- Remove old entities
	removeDespawnedEntitiesFrom( self, self._entities );
	removeDespawnedEntitiesFrom( self, self._updatableEntities );
	removeDespawnedEntitiesFrom( self, self._drawableEntities );
	for entity, _ in pairs( self._despawnedEntities ) do
		entity:destroy();
	end
	self._despawnedEntities = {};

	self._camera:update( dt );
end

MapScene.draw = function( self )

	MapScene.super.draw( self );
	love.graphics.push();
	self._camera:applyTransforms();

	-- Draw the map
	self._map:draw();

	-- Make sure we have a zBuffer canvas to draw too
	local zBufferWidth, zBufferHeight = self._zBuffer:getDimensions();
	local windowWidth, windowHeight = GFXConfig:getWindowSize();
	if zBufferWidth ~= windowWidth or zBufferHeight ~= windowHeight then
		Log:info( "Re-allocating MapScene Z Buffer" );
		self._zBuffer = love.graphics.newCanvas( windowWidth, windowHeight );
	end

	-- Draw zBuffer
	love.graphics.setCanvas( self._zBuffer );
	love.graphics.clear();
	love.graphics.setShader();
	love.graphics.setColor( 255, 255, 255 );
	love.graphics.setBlendMode( "replace", "premultiplied" );
	local _, _, ox, oy = self._map:getPixelDimensions();
	love.graphics.draw( self._map:getZBuffer(), -ox, -oy );
	love.graphics.setCanvas();

	-- Setup depth sort
	local w, h = GFXConfig:getWindowSize();
	love.graphics.setShader( self._depthSortShader );
	self._depthSortShader:send( "zBuffer", self._zBuffer );
	self._depthSortShader:send( "screenSize", { w, h } );
	love.graphics.setBlendMode( "alpha", "alphamultiply" );

	-- Draw water
	self._waterSim:draw( self._depthSortShader );

	-- Draw entities
	love.graphics.setColor( 255, 255, 255 );
	for _, entity in ipairs( self._drawableEntities ) do
		local depth = entity:getPosition():getDepth();
		self._depthSortShader:send( "depthThreshold", depth );
		entity:draw();
	end

	love.graphics.pop();
end

MapScene.spawn = function( self, entity )
	assert( not self._entities[entity] );
	assert( not self._spawnedEntities[entity] );
	self._spawnedEntities[entity] = true;
	return entity;
end

MapScene.despawn = function( self, entity )
	assert( not entity:isValid() );
	self._despawnedEntities[entity] = true;
end

MapScene.getCamera = function( self )
	return self._camera;
end

MapScene.getWaterSim = function( self )
	return self._waterSim;
end



-- MAP

MapScene.getMap = function( self )
	return self._map;
end


return MapScene;
