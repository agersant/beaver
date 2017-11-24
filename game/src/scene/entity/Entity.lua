require( "src/utils/OOP" );
local Colors = require( "src/resources/Colors" );
local ScriptRunner = require( "src/scene/component/ScriptRunner" );
local MathUtils = require( "src/utils/MathUtils" );

local Entity = Class( "Entity" );



Entity.init = function( self, scene )
	assert( scene );
	self._scene = scene;
	self._valid = true;
	self._scene:spawn( self );
end



-- SPRITE COMPONENT

Entity.addSprite = function( self, sprite )
	self._sprite = sprite;
	assert( self._sprite );
end

Entity.setAnimation = function( self, animationName, forceRestart )
	assert( self._sprite );
	self._sprite:setAnimation( animationName, forceRestart );
end

Entity.setUseSpriteHitboxData = function( self, enabled )
	assert( self._body );
	self._useSpriteHitboxData = enabled;
end



-- SCRIPT COMPONENT

Entity.addScriptRunner = function( self )
	self._scriptRunner = ScriptRunner:new( self );
end

Entity.addScript = function( self, script )
	assert( self._scriptRunner );
	self._scriptRunner:addScript( script );
end

Entity.removeScript = function( self, script )
	assert( self._scriptRunner );
	self._scriptRunner:removeScript( script );
end

Entity.signal = function( self, signal, ... )
	if not self._scriptRunner then
		return;
	end
	self._scriptRunner:signal( signal, ... );
end



-- CONTROLLER COMPONENT

Entity.addController = function( self, controller )
	if self._controller then
		self:removeScript( self._controller );
	end
	self._controller = controller;
	self:addScript( self._controller );
	assert( self._controller );
end

Entity.getController = function( self )
	return self._controller;
end



-- CORE

Entity.isUpdatable = function( self )
	return self._scriptRunner or self._sprite or ( self.update ~= Entity.update );
end

Entity.isDrawable = function( self )
	return self._sprite or self._body or ( self.draw ~= Entity.draw );
end

Entity.update = function( self, dt )
	if self._scriptRunner then
		self._scriptRunner:update( dt );
	end
	if self._sprite then
		local animationWasOver = self._sprite:isAnimationOver();
		self._sprite:update( dt );
		if not animationWasOver and self._sprite:isAnimationOver() then
			self:signal( "animationEnd" );
		end
	end
end

Entity.draw = function( self )
	if self._sprite and self._body then
		self._sprite:draw( self._body:getX(), self._body:getY() );
	end
end

Entity.despawn = function( self )
	self._valid = false;
	self._scene:despawn( self );
end

Entity.isValid = function( self )
	return self._valid;
end

Entity.getScene = function( self )
	return self._scene;
end



return Entity;
