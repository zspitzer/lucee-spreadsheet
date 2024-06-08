<cfscript>
	paths = [ "root.test.suite" ];
	try{
		testRunner = New testbox.system.TestBox();
		result = testRunner.runRaw( bundles=paths, reporter="text" );
		report = testRunner.runReport( result );
	
		report = "## Lucee #server.lucee.version# / Java #server.java.version#" & chr(10) & report;
	
		if ( structKeyExists( server.system.environment, "GITHUB_STEP_SUMMARY" ) ){
			fileWrite( server.system.environment.GITHUB_STEP_SUMMARY, report );
		}
		if ( ( result.getTotalFail() + result.getTotalError() ) > 0 ) {
			throw "TestBox could not successfully execute all testcases: #result.getTotalFail()# tests failed; #result.getTotalError()# tests errored.";
		}
	}
	catch( any exception ){
		systemOutput( exception, true );
		rethrow;
	}
	</cfscript>