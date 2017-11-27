require( "src/utils/OOP" );
local MathUtils = require( "src/utils/MathUtils" );
local TableUtils = require( "src/utils/TableUtils" );

local WaterSim = Class( "WaterSim" );



-- IMPLEMENTATION

-- TODO Why does water map explode when this is <= 1.7
local discontinuity = 2;

local sample = function( self, x, y )
	if x < 0 or x >= self._width or y < 0 or y >= self._height then
		local cx = MathUtils.clamp( 0, x, self._width - 1 );
		local cy = MathUtils.clamp( 0, y, self._height - 1 );
		return {
			h = 0,
			H = self._map:getAltitude( cx, cy ),
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

	for _, source in ipairs( self._map:getWaterSources() ) do
		self._field[source.x][source.y].source = source.flow;
	end
end

WaterSim.step = function( self )

	local newField = {};
	local labels = {};
	for x = 0, self._width - 1 do
		newField[x] = {};
		labels[x] = {};
		for y = 0, self._height - 1 do
			self._field[x][y].h = self._field[x][y].h + self._field[x][y].source;
			newField[x][y] = TableUtils.shallowCopy( self._field[x][y] );
			labels[x][y] = nil;
		end
	end

	local currentLabel = 1;
	local components = {};

	for x = 0, self._width - 1 do
		for y = 0, self._height - 1 do

			local sampleLocal = sample( self, x, y );

			if sampleLocal.h > 0 and not labels[x][y] then
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
							local hasWater = sampleDelta.h > 0;
							local zDelta = ( sampleDelta.h + sampleDelta.H - sampleDelta.source );
							local zLocal = ( sampleLocal.h + sampleLocal.H - sampleLocal.source );
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

	-- Compute water exchanged between components
	local droplets = {};
	local dropEmitters = {};
	local dropReceivers = {};
	for componentIndex, component in ipairs( components ) do

		for _, p in ipairs( TableUtils.shallowCopy( component ) ) do
			local sampleLocal = sample( self, p.x, p.y );
			local dropped = 0 ;
			for i = -1, 1 do
				for j = -1, 1 do
					local nx, ny = p.x + i, p.y + j;
					local isNeighbour = ( i ~= 0 or j ~= 0 ) and ( i == 0 or j == 0 );
					local isOnMap = nx >= 0 and ny >= 0 and nx < self._width and ny < self._height;
					local isOtherComponent = isOnMap and labels[nx][ny] ~= componentIndex;
					local isLeak = not isOnMap and sampleLocal.source == 0;
					if isNeighbour and ( isOtherComponent or isLeak ) then
						local sampleDelta = sample( self, nx, ny );
						if ( sampleDelta.H + sampleDelta.h ) < ( sampleLocal.H + sampleLocal.h ) then
							local deltaZ = ( sampleLocal.h + sampleLocal.H ) - ( sampleDelta.h + sampleDelta.H );
							assert( deltaZ > 0 );
							local isComparableZLevel = discontinuity > ( deltaZ - sampleLocal.source + sampleDelta.source );
							if isComparableZLevel then
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
								local transferAmount = math.min( sampleLocal.h - dropped, deltaZ - existingDroplet );

								assert( transferAmount >= 0 );
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

	for x, d in pairs( droplets ) do
		for y, amount in pairs( d ) do
			newField[x][y].h = newField[x][y].h + amount;
		end
	end

	-- Level components
	for componentIndex, component in ipairs( components ) do
		local zSum = 0;
		for _, p in ipairs( component ) do
			local sampleLocal = sample( self, p.x, p.y );
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

	self._field = newField;
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
