local CLI = require( "src/dev/cli/CLI" );
local GFXConfig = require( "src/graphics/GFXConfig" );



local enableFullscreen = function( )
	GFXConfig:setFullscreenEnabled( true );
end

local disableFullscreen = function( )
	GFXConfig:setFullscreenEnabled( false );
end

CLI:addCommand( "enableFullscreen", enableFullscreen );
CLI:addCommand( "disableFullscreen", disableFullscreen );
