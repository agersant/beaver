require( "src/utils/OOP" );
local MathUtils = require( "src/utils/MathUtils" );
local TableUtils = require( "src/utils/TableUtils" );

local WaterSim = Class( "WaterSim" );



-- IMPLEMENTATION

-- TODO Why does water map explode when this is <= 1.7
local discontinuity = 2;

local sample = function( self, x, y, field )
	if x < 0 or x >= self._width or y < 0 or y >= self._height then
		local cx = MathUtils.clamp( 0, x, self._width - 1 );
		local cy = MathUtils.clamp( 0, y, self._height - 1 );
		return {
			h = 0,
			H = self._map:getAltitude( cx, cy ),
			source = 0,
		};
	end
	return ( field or self._field )[x][y];
end



-- PUBLIC API

WaterSim.init = function( self, map )
	assert( map );
	self._map = map;
	self._field = {};
	self._width, self._height = self._map:getDimensions();

	self._time = 0;
	self._stepsDone = 0;
	self._stepsPerSecond = 5;

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

	for _, source in ipairs( self._map:getWaterSources() ) do
		self._field[source.x][source.y].source = source.flow;
	end
end

WaterSim.step = function( self )

	-- Initialzed connected component labels
	local labels = {};
	for x = 0, self._width - 1 do
		labels[x] = {};
		for y = 0, self._height - 1 do
			labels[x][y] = nil;
		end
	end

	-- Determine connected components
	local currentLabel = 1;
	local components = {};
	for x = 0, self._width - 1 do
		for y = 0, self._height - 1 do

			local sampleLocal = sample( self, x, y );

			if ( sampleLocal.h > 0 or sampleLocal.source > 0 ) and not labels[x][y] then
				components[currentLabel] = {};
				local queue = {};

				labels[x][y] = currentLabel;
				table.insert( components[currentLabel], { x = x, y = y } );
				table.insert( queue, { x = x, y = y } );
				while #queue > 0 do
					local p = table.remove( queue );
					for i = -1, 1 do
						for j = -1, 1 do
							local nx, ny = p.x + i, p.y + j;
							local isNeighbour = ( i ~= 0 or j ~= 0 ) and ( i == 0 or j == 0 );
							local isOnMap = nx >= 0 and ny >= 0 and nx < self._width and ny < self._height;
							local sampleDelta = sample( self, nx, ny );
							local hasWater = sampleDelta.source > 0 or sampleDelta.h > 0;
							local zDelta = ( sampleDelta.h + sampleDelta.H );
							local zLocal = ( sampleLocal.h + sampleLocal.H );
							local isComparableZLevel = discontinuity > math.abs( zDelta - zLocal );
							if isNeighbour and isOnMap and hasWater and isComparableZLevel and not labels[nx][ny] then
								labels[nx][ny] = currentLabel;
								table.insert( components[currentLabel], { x = nx, y = ny } );
								table.insert( queue, { x = nx, y = ny } );
							end
						end
					end
				end

				currentLabel = currentLabel + 1;
			end

		end
	end

	-- Initialize new field
	local newField = {};
	for x = 0, self._width - 1 do
		newField[x] = {};
		for y = 0, self._height - 1 do
			newField[x][y] = TableUtils.shallowCopy( self._field[x][y] );
		end
	end

	-- Add water to the system
	local rise = {};
	for componentIndex, component in ipairs( components ) do
		local input = 0;
		for _, p in ipairs( component ) do
			input = input + self._field[p.x][p.y].source;
		end
		rise[componentIndex] = input / #component;
		if input > 0 then
			for _, p in ipairs( component ) do
				newField[p.x][p.y].h = newField[p.x][p.y].h + input / #component;
			end
		end
	end

	-- Compute water exchanged between components
	local droplets = {};
	local dropEmitters = {};
	local dropReceivers = {};
	for componentIndex, component in ipairs( components ) do

		for _, p in ipairs( TableUtils.shallowCopy( component ) ) do
			local sampleLocal = sample( self, p.x, p.y, newField );
			local dropped = 0 ;
			for i = -1, 1 do
				for j = -1, 1 do
					local nx, ny = p.x + i, p.y + j;
					local isNeighbour = ( i ~= 0 or j ~= 0 ) and ( i == 0 or j == 0 );
					local isOnMap = nx >= 0 and ny >= 0 and nx < self._width and ny < self._height;
					local isOtherComponent = isOnMap and labels[nx][ny] ~= componentIndex;
					local isLeak = not isOnMap and sampleLocal.source == 0;
					if isNeighbour and ( isOtherComponent or isLeak ) then
						local sampleDelta = sample( self, nx, ny, newField );
						if ( sampleDelta.H + sampleDelta.h ) < ( sampleLocal.H + sampleLocal.h ) then
							local deltaZ = ( sampleLocal.h + sampleLocal.H ) - ( sampleDelta.h + sampleDelta.H );
							assert( deltaZ > 0 );
							local isComparableZLevel = discontinuity > ( deltaZ - rise[componentIndex] );
							if isComparableZLevel then
								-- print( "propagate from ", p.x, p.y, " to ", nx, ny, rise[componentIndex] );
								table.insert( component, { x = nx, y = ny } );
							else
								local existingDroplet = 0;
								if isOnMap then
									if not droplets[nx] then
										droplets[nx] = {};
									end
									if not droplets[nx][ny] then
										droplets[nx][ny] = 0;
									end
									existingDroplet = droplets[nx][ny];
								end
								local transferAmount = math.max( 0, math.min( sampleLocal.h - dropped, deltaZ - existingDroplet ) );
								-- print( "drop from ", p.x, p.y, " to ", nx, ny, transferAmount );
								dropped = dropped + transferAmount;
								dropEmitters[componentIndex] = dropEmitters[componentIndex] or 0;
								dropEmitters[componentIndex] = dropEmitters[componentIndex] + transferAmount;
								if isOnMap then
									if labels[nx][ny] then
										dropReceivers[labels[nx][ny]] = dropReceivers[labels[nx][ny]] or 0;
										dropReceivers[labels[nx][ny]] = dropReceivers[labels[nx][ny]] + transferAmount;
									else
										droplets[nx][ny] = droplets[nx][ny] + transferAmount;
									end
								end
							end
						end
					end
				end
			end
		end

	end

	-- Adjust z level of components based on exchanges
	for componentIndex, component in ipairs( components ) do
		local zSum = 0;
		for _, p in ipairs( component ) do
			local sampleLocal = sample( self, p.x, p.y, newField );
			zSum = zSum + sampleLocal.h + sampleLocal.H;
		end
		if dropEmitters[componentIndex] then
			zSum = zSum - dropEmitters[componentIndex];
		end
		if dropReceivers[componentIndex] then
			zSum = zSum + dropReceivers[componentIndex];
		end
		local zAverage = zSum / #component;
		for _, p in ipairs( component ) do
			local isOnMap = p.x >= 0 and p.y >= 0 and p.x < self._width and p.y < self._height;
			if isOnMap then
				newField[p.x][p.y].h = math.max( 0, zAverage - newField[p.x][p.y].H );
			end
		end
	end

	-- Drop water outside existing components
	for x, d in pairs( droplets ) do
		for y, amount in pairs( d ) do
			newField[x][y].h = newField[x][y].h + amount;
		end
	end

	self._field = newField;

	-- print( "STEP " .. self._stepsDone );
	-- self._field = newField;
	-- local volume = 0;
	-- for y = 0, self._height - 1 do
	-- 	local line = "";
	-- 	for x = 0, self._width - 1 do
	-- 		volume = volume + self._field[x][y].h;
	-- 		line = line .. ", " .. string.format( "%.2f", self._field[x][y].h );
	-- 	end
	-- 	print( line );
	-- end
	-- print( "Volume: ", volume );
	-- print( "" );
end

WaterSim.update = function( self, dt )
	self._time = self._time + dt;
	while self._stepsDone < math.floor( self._time * self._stepsPerSecond ) do
		self:step();
		self._stepsDone = self._stepsDone + 1;
	end
end

WaterSim.getWaterLevelAt = function( self, x, y )
	return self._field[x][y].h;
end


return WaterSim;
