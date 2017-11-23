require( "src/utils/OOP" );
local Log = require( "src/dev/Log" );
local TableUtils = require( "src/utils/TableUtils" );

local PlayerSave = Class( "PartyMember" );



-- PUBLIC API

PlayerSave.init = function( self )
end

PlayerSave.toPOD = function( self )
	return {};
end

PlayerSave.writeToDisk = function( self, path )
	local pod = self:toPOD();
	local fileContent = TableUtils.serialize( pod );
	love.filesystem.write( path, fileContent );
	local fullPath = love.filesystem.getRealDirectory( path ) .. "/" .. path;
	Log:info( "Saved player save to " .. fullPath );
end



-- STATIC

local currentPlayerSave = PlayerSave:new();

PlayerSave.getCurrent = function( self )
	return currentPlayerSave;
end

PlayerSave.setCurrent = function( self, playerSave )
	assert( playerSave );
	Log:info( "Overwrote in-memory player save" );
	currentPlayerSave = playerSave;
end

PlayerSave.fromPOD = function( self, pod )
	local playerSave = PlayerSave:new();
	assert( pod.party );
	playerSave._party = Party:fromPOD( pod.party );
	assert( pod.location );
	playerSave._location = pod.location;
	return playerSave;
end

PlayerSave.loadFromDisk = function( self, path )
	local fileContent = love.filesystem.read( path );
	local pod = TableUtils.unserialize( fileContent );
	local playerSave = PlayerSave:fromPOD( pod );
	local fullPath = love.filesystem.getRealDirectory( path ) .. "/" .. path;
	Log:info( "Loaded player save from " .. fullPath );
	return playerSave;
end



return PlayerSave;
