require( "src/utils/OOP" );
local MathUtils = require( "src/utils/MathUtils" );
local TableUtils = require( "src/utils/TableUtils" );

local WaterSim = Class( "WaterSim" );



-- IMPLEMENTATION

-- Minimum difference in water level for two tiles to not be considered as
-- part of the same connected component. Being part of the same component
-- makes water levels line up instantly, while water pours gradually between
-- distinct components.
local discontinuity = 2;

-- How much faster water is allowed to leave the map than it enters.
-- Setting this value higher makes it more difficult for a river to overflow.
-- Current value of 2 allows a river to stay within its bed as long as there
-- are at least half as many output tiles as input tiles (regardless of input flow).
local allowedOverflow = 2;

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
	for _, source in ipairs( self._map:getWaterFills() ) do
		self._field[source.x][source.y].h = source.height;
	end
end

WaterSim.step = function( self )

	-- Initialize connected component labels
	local labels = {};
	for x = 0, self._width - 1 do
		labels[x] = {};
		for y = 0, self._height - 1 do
			labels[x][y] = nil;
		end
	end

	-- Assign connected components
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

	-- Initialize exchange data structures
	local dropInputs = {}; -- Index by component, values are water received from other components
	for componentIndex, component in ipairs( components ) do
		dropInputs[componentIndex] = 0;
	end

	-- Sort components by z level
	local sortedComponentIndices = {};
	for i = 1, #components do
		sortedComponentIndices[i] = i;
	end
	table.sort( sortedComponentIndices, function( a, b )
		local x, y = components[a][1].x, components[a][1].y;
		zA = newField[x][y].H + newField[x][y].h;
		local x, y = components[b][1].x, components[b][1].y;
		zB = newField[x][y].H + newField[x][y].h;
		return zA > zB;
	end );

	-- Update components one by one
	for i = 1, #components do
		local componentIndex = sortedComponentIndices[i];
		local component = components[componentIndex];

		-- Count amount of water received from sources and waterfalls
		local waterInput = dropInputs[componentIndex];
		for _, p in ipairs( component ) do
			waterInput = waterInput + self._field[p.x][p.y].source;
		end

		-- Spread water received evenly
		local volume = 0;
		for _, p in ipairs( component ) do
			newField[p.x][p.y].h = newField[p.x][p.y].h + waterInput / #component;
			volume = volume + newField[p.x][p.y].h;
		end

		-- Find pours (water falls into other component) and droplets (water falls on dry tile)
		local waterOutput = 0;
		local pours = {}; 		-- drops onto other connected components
		local droplets = {};	-- drops onto dry tiles
		local dropTargets = {};	-- keep track of how much water we're dropping on individual tiles to avoid pouring too much on a given spot

		for _, p in ipairs( component ) do
			local sampleLocal = sample( self, p.x, p.y, newField );
			for i = -1, 1 do
				for j = -1, 1 do
					local nx, ny = p.x + i, p.y + j;
					local isNeighbour = ( i ~= 0 or j ~= 0 ) and ( i == 0 or j == 0 );
					local isOnMap = nx >= 0 and ny >= 0 and nx < self._width and ny < self._height;
					local isOtherComponent = isOnMap and labels[nx][ny] ~= componentIndex;
					local isLeak = not isOnMap and sampleLocal.source == 0;
					if isNeighbour and ( isOtherComponent or isLeak ) then
						local sampleNeighbour = sample( self, nx, ny, newField );
						local zLocal = ( sampleLocal.H + sampleLocal.h );
						local zNeighbour = ( sampleNeighbour.H + sampleNeighbour.h );
						local deltaZ = zLocal - zNeighbour;
						if deltaZ > 0 and ( isLeak or ( deltaZ - waterInput / #component ) > discontinuity ) then
							dropTargets[nx] = dropTargets[nx] or {};
							dropTargets[nx][ny] = 0;
							if isOnMap and labels[nx][ny] then
								pours[labels[nx][ny]] = 0;
							else
								droplets[nx] = droplets[nx] or {};
								droplets[nx][ny] = 0;
							end
						end
					end
				end
			end
		end

		local numDropTargets = 0;
		for x, t in pairs( dropTargets ) do
			for y, _ in pairs( t ) do
				numDropTargets = numDropTargets + 1;
			end
		end

		local numOutputTargets = TableUtils.countKeys( pours );
		for x, t in pairs( droplets ) do
			for y, _ in pairs( t ) do
				numOutputTargets = numOutputTargets + 1;
			end
		end

		-- Decide how much water can be dropped into each pour/droplet
		for _, p in ipairs( component ) do
			local sampleLocal = sample( self, p.x, p.y, newField );
			for i = -1, 1 do
				for j = -1, 1 do
					local nx, ny = p.x + i, p.y + j;
					local isNeighbour = ( i ~= 0 or j ~= 0 ) and ( i == 0 or j == 0 );
					local isOnMap = nx >= 0 and ny >= 0 and nx < self._width and ny < self._height;
					local isOtherComponent = isOnMap and labels[nx][ny] ~= componentIndex;
					local isLeak = not isOnMap and sampleLocal.source == 0;
					if isNeighbour and ( isOtherComponent or isLeak ) then
						local sampleNeighbour = sample( self, nx, ny, newField );
						local zLocal = ( sampleLocal.H + sampleLocal.h );
						local zNeighbour = ( sampleNeighbour.H + sampleNeighbour.h );
						local deltaZ = zLocal - zNeighbour;
						if deltaZ > 0 and ( isLeak or ( deltaZ - waterInput / #component ) > discontinuity ) then
							local zNeighbourFutureOffset = 0;
							if isOnMap and labels[nx][ny] then
								zNeighbourFutureOffset = ( dropInputs[labels[nx][ny]] + pours[labels[nx][ny]] ) / #components[labels[nx][ny]];
							else
								zNeighbourFutureOffset = droplets[nx][ny];
							end

							local oldTransfer = dropTargets[nx][ny];
							if waterInput == 0 then
								dropTargets[nx][ny] = dropTargets[nx][ny] + sampleLocal.h;
							else
								dropTargets[nx][ny] = dropTargets[nx][ny] + waterInput / numDropTargets;
							end
							if not isLeak then
								dropTargets[nx][ny] = math.min( dropTargets[nx][ny], math.max( 0, deltaZ - zNeighbourFutureOffset ) );
							else
								dropTargets[nx][ny] = math.min( dropTargets[nx][ny], math.max( 0, allowedOverflow * deltaZ - zNeighbourFutureOffset ) );
							end
							waterOutput = waterOutput + dropTargets[nx][ny] - oldTransfer;

							if isOnMap and labels[nx][ny] then
								pours[labels[nx][ny]] = pours[labels[nx][ny]] + dropTargets[nx][ny] - oldTransfer;
							else
								droplets[nx][ny] = droplets[nx][ny] + dropTargets[nx][ny] - oldTransfer;
							end
						end
					end
				end
			end
		end

		-- Pour water out!
		if numOutputTargets > 0 then
			waterOutput = math.min( volume, waterOutput );

			local transferred = 0;
			while transferred < waterOutput and numOutputTargets > 0 do
				local oldTransferred = transferred;
				local w = ( waterOutput - transferred ) / numOutputTargets;

				-- Pour to other component
				for label, amount in pairs( TableUtils.shallowCopy( pours ) ) do
					local t = math.max( 0, math.min( w, amount ) );
					dropInputs[label] = dropInputs[label] + t;
					transferred = transferred + t;
					pours[label] = pours[label] - t;
					if pours[label] <= 0 then
						pours[label] = nil;
						numOutputTargets = numOutputTargets - 1;
					end
				end

				-- Pour to droplet
				for x, t in pairs( droplets ) do
					for y, amount in pairs( TableUtils.shallowCopy( t ) ) do
						local t = math.max( 0, math.min( w, amount ) );
						transferred = transferred + t;
						droplets[x][y] = droplets[x][y] - t;
						local isOnMap = x >= 0 and y >= 0 and x < self._width and y < self._height;
						if isOnMap then
							newField[x][y].h = newField[x][y].h + t;
						end
						if droplets[x][y] <= 0 then
							droplets[x][y] = nil;
							numOutputTargets = numOutputTargets - 1;
						end
					end
				end

			end

			for _, p in ipairs( component ) do
				newField[p.x][p.y].h = math.max( 0, newField[p.x][p.y].h - waterOutput / #component );
			end
		end

		-- Expand to nearby tiles
		for _, p in ipairs( TableUtils.shallowCopy( component ) ) do
			local sampleLocal = sample( self, p.x, p.y, newField );
			for i = -1, 1 do
				for j = -1, 1 do
					local nx, ny = p.x + i, p.y + j;
					local isNeighbour = ( i ~= 0 or j ~= 0 ) and ( i == 0 or j == 0 );
					local isOnMap = nx >= 0 and ny >= 0 and nx < self._width and ny < self._height;
					local isOtherComponent = isOnMap and labels[nx][ny] ~= componentIndex;
					local isLeak = not isOnMap and sampleLocal.source == 0;
					if isNeighbour and ( isOtherComponent or isLeak ) then
						local sampleNeighbour = sample( self, nx, ny, newField );
						local zLocal = ( sampleLocal.H + sampleLocal.h );
						local zNeighbour = ( sampleNeighbour.H + sampleNeighbour.h );
						local deltaZ = zLocal - zNeighbour;
						local isDropTarget = dropTargets[nx] and dropTargets[nx][ny];
						if deltaZ > 0 and not isDropTarget then
							table.insert( component, { x = nx, y = ny } );
						end
					end
				end
			end
		end

		-- Level
		local zSum = 0;
		for _, p in ipairs( component ) do
			local sampleLocal = sample( self, p.x, p.y, newField );
			zSum = zSum + sampleLocal.h + sampleLocal.H;
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

	-- print( "STEP " .. self._stepsDone );
	-- self._field = newField;
	-- local volume = 0;
	-- for y = 0, self._height - 1 do
	-- 	local line = "";
	-- 	for x = 0, self._width - 1 do
	-- 		volume = volume + self._field[x][y].h;
	-- 		line = line .. ", " .. string.format( "%.2f", self._field[x][y].h );
	-- 	end
		-- print( line );
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
