local testFiles = {
	"src/dev/cli/TestCLI",
	"src/input/TestInputDevice",
	"src/resources/TestAssets",
	"src/scene/TestScript",
	"src/ui/TestTextInput",
	"src/ui/TestWidget",
	"src/utils/TestMathUtils",
	"src/utils/TestOOP",
	"src/utils/TestStringUtils",
	"src/utils/TestTableUtils",
};

local runTestFile = function( source )

	print( "" );
	local tests = require( source );
	print( "Running " .. #tests .. " tests from: " .. source );

	local numSuccess = 0;
	for i, test in ipairs( tests ) do
		assert( type( test.name ) == "string" );
		assert( type( test.body ) == "function" );
		local success, errorText = xpcall( test.body, function( err )
			print( "    " .. test.name .. ": FAIL (see error output below)" );
			print( err );
			print( debug.traceback() );
		end );
		if success then
			numSuccess = numSuccess + 1;
			print( "    " .. test.name .. ": PASS" );
		end
	end

	package.loaded[source] = false;
	return numSuccess, #tests;

end

local printResults = function( numSuccess, numTests )
	local successRate = numTests > 0 and numSuccess / numTests or 1;
	print( "" );
	print( "Grand total: " .. numSuccess .. "/" .. numTests .. " tests passed" );
end

local runTestSuite = function()
	local totalNumSuccess = 0;
	local totalNumTests = 0;
	for i, testFile in ipairs( testFiles ) do
		local numSuccess, numTests = runTestFile( testFile );
		totalNumSuccess = totalNumSuccess + numSuccess;
		totalNumTests = totalNumTests + numTests;
	end
	printResults( totalNumSuccess, totalNumTests );
	return totalNumSuccess == totalNumTests;
end



return {
	execute = function()
		return runTestSuite();
	end,
}
