require( "src/utils/OOP" );
local InputDevice = require( "src/input/InputDevice" );

local Input = Class( "Input" );



-- PUBLIC API

Input.init = function( self )
	self._devices = {};
	for i = 1, gConf.splitscreen.maxLocalPlayers do
		local device = InputDevice:new();
		table.insert( self._devices, device );
	end

	local player1Device = self:getDevice( 1 );
	player1Device:addBinding( "zoomIn", "wheelUp" );
	player1Device:addBinding( "zoomOut", "wheelDown" );
end

Input.getDevice = function( self, index )
	local device = self._devices[index];
	assert( device );
	return device;
end

Input.keyPressed = function( self, key, scanCode, isRepeat )
	for i, device in ipairs( self._devices ) do
		device:keyPressed( key, scanCode, isRepeat );
	end
end

Input.keyReleased = function( self, key, scanCode )
	for i, device in ipairs( self._devices ) do
		device:keyReleased( key, scanCode );
	end
end

Input.wheelMoved = function( self, x, y )
	if y == 0 then
		return;
	end
	local key;
	if y > 0 then
		key = "wheelUp";
	elseif y < 0 then
		key = "wheelDown";
	end
	for i, device in ipairs( self._devices ) do
		device:keyPressed( key);
		device:keyReleased( key);
	end
end

Input.flushEvents = function( self )
	for i, device in ipairs( self._devices ) do
		device:flushEvents();
	end
end


local instance = Input:new();
return instance;
