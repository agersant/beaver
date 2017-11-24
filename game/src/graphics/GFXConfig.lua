require( "src/utils/OOP" );

local GFXConfig = Class( "GFXConfig" );
local instance;



-- IMPLEMENTATION

local setMode = function( self )
	if not love.window then
		return;
	end
	love.window.setMode( self._windowWidth, self._windowHeight, {
		msaa = 8,
		resizable = true,
		vsync = false,
		fullscreen = self._fullscreen,
	} );
	love.window.setTitle( "Beaver" );
end



-- PUBLIC API

love.resize = function( width, height )
	instance._windowWidth = width;
	instance._windowHeight = height;
end

GFXConfig.init = function( self )
	self:setResolution( 1600, 900 );
	setMode( self );
end

GFXConfig.setResolution = function( self, width, height )
	self._windowWidth = width;
	self._windowHeight = height;
	setMode( self );
end

GFXConfig.setFullscreenEnabled = function( self, enabled )
	self._fullscreen = enabled;
	setMode( self );
end

GFXConfig.getWindowSize = function( self )
	return self._windowWidth, self._windowHeight;
end


instance = GFXConfig:new();
return instance;
