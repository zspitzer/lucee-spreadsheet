<cfscript>
	paths = [ "root.test.suite" ];
	try{
		testRunner = New testbox.system.TestBox();
		result = testRunner.runRaw( bundles=paths );
		reporter = testRunner.buildReporter( "text" );
		report = reporter.runReport( result, testRunner );
	
		failure = ( result.getTotalFail() + result.getTotalError() ) > 0;
	
		report = "## #(failure?':x:':':heavy_check_mark:')# Lucee #server.lucee.version# / Java #server.java.version#" & chr(10) & report;
	
		if ( structKeyExists( server.system.environment, "GITHUB_STEP_SUMMARY" ) ){
			// fileWrite( server.system.environment.GITHUB_STEP_SUMMARY, report );
		} else {
			systemOutput( report, true );
		}
		if ( failure ) {
			error = "TestBox could not successfully execute all testcases: #result.getTotalFail()# tests failed; #result.getTotalError()# tests errored.";
			if ( structKeyExists( server.system.environment, "GITHUB_STEP_SUMMARY" ) ){
				fileAppend( server.system.environment.GITHUB_STEP_SUMMARY, chr(10) & "#### " & error );
			} else {
				systemOutput( error, true );
			}
			throw error;
		}
	}
	catch( any exception ){
		systemOutput( exception, true );
		rethrow;
	}
</cfscript>