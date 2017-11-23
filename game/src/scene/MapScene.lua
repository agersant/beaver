require( "src/utils/OOP" );
local Log = require( "src/dev/Log" );
local Assets = require( "src/resources/Assets" );
local Colors = require( "src/resources/Colors" );
local Camera = require( "src/scene/Camera" );
local Scene = require( "src/scene/Scene" );
local Entity = require( "src/scene/entity/Entity" );
local UIScene = require( "src/ui/UIScene" );
local TableUtils = require( "src/utils/TableUtils" );

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

	local mapWidth = self._map:getWidthInPixels();
	local mapHeight = self._map:getHeightInPixels();
	self._camera = Camera:new( mapWidth, mapHeight );
end

MapScene.update = function( self, dt )
	MapScene.super.update( self, dt );

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
		if entity:isCombatable() then
			table.insert( self._combatableEntities, entity );
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



-- MAP

MapScene.getMap = function( self )
	return self._map;
end


return MapScene;
