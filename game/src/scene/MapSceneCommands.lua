local CLI = require( "src/dev/cli/CLI" );
local PlayerSave = require( "src/persistence/PlayerSave" );
local MapScene = require( "src/scene/MapScene" );
local Scene = require( "src/scene/Scene" );



local loadMap = function( mapName )
	local newScene = MapScene:new( "assets/map/" .. mapName .. ".lua" );
	Scene:setCurrent( newScene );
end

CLI:addCommand( "loadMap mapName:string", loadMap );
