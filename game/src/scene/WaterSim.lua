require( "src/utils/OOP" );
local Assets = require( "src/resources/Assets" );
local MathUtils = require( "src/utils/MathUtils" );
local TableUtils = require( "src/utils/TableUtils" );

local WaterSim = Class( "WaterSim" );



-- IMPLEMENTATION

local sample = function( self, x, y )
	if x < 0 or x >= self._width or y < 0 or y >= self._height then
		return {
			h = 0,
			H = 0,
			source = 0,
		};
	end
	return self._field[x][y];
end



-- PUBLIC API

WaterSim.init = function( self, map )
	assert( map );
	self._map = map;
	self._field = {};
	self._width, self._height = self._map:getDimensions();
	self._surfaceTile = Assets:getImage( "assets/code/water/surface.png" );

	self._time = 0;
	self._stepsDone = 0;
	self._stepsPerSecond = 10;

	for x = 0, self._width - 1 do
		self._field[x] = {};
		for y = 0, self._height - 1 do
			self._field[x][y] = {
				h = 0, 		-- height of water above ground (1 unit = 1 layer's thickness of water)
				source = 0, -- sponatenous water level elevation per step
				H = self._map:getAltitude( x, y ), -- TODO slopes
			};
		end
	end
end


WaterSim.setWaterHeight = function( self, x, y, height )
	assert( height >= 0 );
	self._field[x][y].h = height;
end

WaterSim.setWaterSource = function( self, x, y, amount )
	assert( amount >= 0 );
	self._field[x][y].source = amount;
end

WaterSim.step = function( self )

	local newField = {};
	for x = 0, self._width - 1 do
		newField[x] = {};
		for y = 0, self._height - 1 do
			newField[x][y] = TableUtils.shallowCopy( self._field[x][y] );
		end
	end

	for x = 0, self._width - 1 do
		for y = 0, self._height - 1 do
			local sampleLocal = sample( self, x, y );
			local transferred = 0;

			assert( newField[x][y].source >= 0 );
			newField[x][y].h = newField[x][y].h + newField[x][y].source;

			for i = -1, 1 do
				for j = -1, 1 do
					local hasWaterToGive = transferred < sampleLocal.h;
					local isNeighbour = ( i ~= 0 or j ~= 0 ) and ( i == 0 or j == 0 );
					if hasWaterToGive and isNeighbour then
						local sampleDelta = sample( self, x + i, y + j );
						local totalLocal = sampleLocal.h + sampleLocal.H;
						local totalDelta = sampleDelta.h + sampleDelta.H;
						if totalLocal > totalDelta then
							local isOnMap = x + i >= 0 and y + j >= 0 and x + i < self._width and y + j < self._height;
							local difference = totalLocal - totalDelta;

							local transferAmount;
							if isOnMap then
								transferAmount = math.min( difference * 0.25, sampleLocal.h * 0.25 );
							else
								transferAmount = difference;
							end
							transferAmount = math.min( sampleLocal.h - transferred, transferAmount );

							assert( transferAmount >= 0 );
							if isOnMap then
								newField[x+i][y+j].h = newField[x+i][y+j].h + transferAmount;
							end
							if sampleLocal.source <= 0 then
								newField[x][y].h = math.max( 0, newField[x][y].h - transferAmount );
								transferred = transferred + transferAmount;
							end
						end
					end
				end
			end
		end
	end

	self._field = newField;
end

WaterSim.update = function( self, dt )
	self._time = self._time + dt;
	while self._stepsDone < math.floor( self._time * self._stepsPerSecond ) do
		self:step();
		self._stepsDone = self._stepsDone + 1;
	end
end

WaterSim.draw = function( self, depthSortShader )
	local w, h = self._map:getDimensions();
	local tileWidth, tileHeight, tileAltitude = self._map:getTileDimensions();

	for x = 0, w - 1 do
		for y = 0, h - 1 do
			local h = MathUtils.round( self._field[x][y].h * tileAltitude );
			if h > 0 then
				love.graphics.setColor( 0, 180, 200, h * 80 );
				local tx, ty = self._map:tilesToPixels( x, y );
				depthSortShader:send( "depthThreshold", x + y );
				love.graphics.draw( self._surfaceTile, tx - tileWidth / 2, ty - 0.5 * tileHeight );
				love.graphics.rectangle( "fill", tx - tileWidth / 2, ty - h, tileWidth, h );
				love.graphics.draw( self._surfaceTile, tx - tileWidth / 2, ty - 0.5 * tileHeight - h );
			end
		end
	end
end


return WaterSim;
