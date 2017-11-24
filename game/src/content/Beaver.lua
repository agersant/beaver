require( "src/utils/OOP" );
local Assets = require( "src/resources/Assets" );
local Entity = require( "src/scene/Entity" );
local Position = require( "src/scene/component/Position" );
local Sprite = require( "src/scene/component/Sprite" );

local Beaver = Class( "Beaver", Entity );



-- PUBLIC API

Beaver.init = function( self, scene )
	assert( scene );
	Beaver.super.init( self, scene );
	self:addPosition( Position:new() );
	local sheet = Assets:getSpritesheet( "assets/spritesheet/beaver.lua" );
	self:addSprite( Sprite:new( sheet ) );
end



return Beaver;
