local CLI = require( "src/dev/cli/CLI" );
local PlayerSave = require( "src/persistence/PlayerSave" );
local MapScene = require( "src/scene/MapScene" );
local Scene = require( "src/scene/Scene" );
local Entity = require( "src/scene/entity/Entity" );



local loadMap = function( mapName )
	local newScene = MapScene:new( "assets/map/" .. mapName .. ".lua" );
	Scene:setCurrent( newScene );
end

CLI:addCommand( "loadMap mapName:string", loadMap );

local testMap = function()
	loadMap( "dev" );
end

CLI:addCommand( "testMap", testMap );

local setDrawPhysicsOverlay = function( draw )
	gConf.drawPhysics = draw;
end

CLI:addCommand( "showPhysicsOverlay", function() setDrawPhysicsOverlay( true ); end );
CLI:addCommand( "hidePhysicsOverlay", function() setDrawPhysicsOverlay( false ); end );

local setDrawNavmeshOverlay = function( draw )
	gConf.drawNavmesh = draw;
end

CLI:addCommand( "showNavmeshOverlay", function() setDrawNavmeshOverlay( true ); end );
CLI:addCommand( "hideNavmeshOverlay", function() setDrawNavmeshOverlay( false ); end );
