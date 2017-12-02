require( "src/utils/OOP" );
local GFXConfig = require( "src/graphics/GFXConfig" );
local MathUtils = require( "src/utils/MathUtils" );
local TableUtils = require( "src/utils/TableUtils" );

local Camera = Class( "Camera" );



-- PUBLIC API

Camera.init = function( self, map )
	self._map = map;
	self:setPosition( 0, 0 );
	self._panThresholdX = 0.075; -- Proportional to screen width
	self._panThresholdY = 0.075; -- Proportional to screen height
	self._panSpeed = 800; -- px per seconds
	self._zoom = 2;
end

Camera.applyTransforms = function( self )
	local left, top = self._x, self._y;
	local screenW, screenH = GFXConfig:getWindowSize();
	left = left - screenW / 2 / self._zoom;
	top = top - screenH / 2 / self._zoom;
	left = MathUtils.roundTo( left, 1 / self._zoom );
	top = MathUtils.roundTo( top, 1 / self._zoom );
	love.graphics.scale( self._zoom, self._zoom );
	love.graphics.translate( -left, -top );
end

Camera.setPosition = function( self, x, y )
	assert( type( x ) == "number" );
	assert( type( y ) == "number" );
	self._x = x;
	self._y = y;
end

Camera.zoomIn = function( self )
	self._zoom = math.min( 16, self._zoom + 1 );
end

Camera.zoomOut = function( self )
	self._zoom = math.max( 1, self._zoom - 1 );
end

Camera.getZoom = function( self )
	return self._zoom;
end

Camera.update = function( self, dt )
	local windowWidth, windowHeight = GFXConfig:getWindowSize();
	local mx, my = love.mouse.getPosition();
	local dx, dy = 0, 0;
	if mx < windowWidth * self._panThresholdX then
		dx = -1;
	end
	if my < windowHeight * self._panThresholdY then
		dy = -1;
	end
	if mx > windowWidth * ( 1 - self._panThresholdX ) then
		dx = 1;
	end
	if my > windowHeight * ( 1 - self._panThresholdY ) then
		dy = 1;
	end

	local d = math.sqrt( dx*dx + dy*dy );
	if d > 0 then
		dx = dx / d;
		dy = dy / d;
	end
	self._x = self._x + dx * dt * self._panSpeed / self._zoom;
	self._y = self._y + dy * dt * self._panSpeed / self._zoom;
end



return Camera;
