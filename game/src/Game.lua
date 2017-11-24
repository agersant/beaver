local GFXConfig = require( "src/graphics/GFXConfig" );
local FPSCounter = require( "src/dev/FPSCounter" );
local HotReload = require( "src/dev/HotReload" );
local Log = require( "src/dev/Log" );
local CLI = require( "src/dev/cli/CLI" );
local Input = require( "src/input/Input" );
local Content = require( "src/resources/Content" );
local Scene = require( "src/scene/Scene" );



love.load = function()
	love.keyboard.setTextInput( false );
	require( "src/graphics/GFXCommands" ); 				-- Register commands
	require( "src/persistence/PlayerSaveCommands" ); 	-- Register commands
	require( "src/scene/MapSceneCommands" ); 			-- Register commands
	Content:requireAll( "src/content" );
	Log:info( "Completed startup" );
end

love.update = function( dt )
	FPSCounter:update( dt );

	local scene;
	local newScene = Scene:getCurrent();
	while scene ~= newScene do
		scene = newScene;
		scene:update( dt );
		newScene = Scene:getCurrent();
	end

	Input:flushEvents();
end

love.draw = function()
	love.graphics.reset();
	Scene:getCurrent():draw();
	love.graphics.reset();
	FPSCounter:draw();
	CLI:draw();
end

love.keypressed = function( key, scanCode, isRepeat )
   local ctrl = love.keyboard.isDown( "lctrl" ) or love.keyboard.isDown( "rctrl" );
	CLI:keyPressed( key, scanCode, ctrl );
	Input:keyPressed( key, scanCode, isRepeat );
end

love.keyreleased = function( key, scanCode )
	Input:keyReleased( key, scanCode );
end

love.wheelmoved = function( x, y )
	Input:wheelMoved( x, y );
end

love.textinput = function( text )
	CLI:textInput( text );
end
