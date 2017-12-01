require( "src/utils/OOP" );
local GFXConfig = require( "src/graphics/GFXConfig" );
local Log = require( "src/dev/Log" );
local Input = require( "src/input/Input" );
local Assets = require( "src/resources/Assets" );
local Camera = require( "src/scene/Camera" );
local Scene = require( "src/scene/Scene" );
local MapSceneRenderer = require( "src/scene/MapSceneRenderer" );
local WaterSim = require( "src/scene/WaterSim" );
local TableUtils = require( "src/utils/TableUtils" );

-- TMP
local Beaver = require( "src/content/Beaver" );

local MapScene = Class( "MapScene", Scene );



-- IMPLEMENTATION

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

	self._renderer = MapSceneRenderer:new( self );
	self._camera = Camera:new( self._map );

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
	self._renderer:drawScreen();
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

MapScene.getMap = function( self )
	return self._map;
end

MapScene.getDrawableEntities = function( self )
	return TableUtils.shallowCopy( self._drawableEntities );
end

return MapScene;
