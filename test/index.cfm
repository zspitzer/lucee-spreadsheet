<cfscript>
paths = [ "root.test.suite" ];
try{
	testRunner = New testbox.system.TestBox( bundles=paths, reporter="console" );
	systemOutput( testRunner.run(), true );
}
catch( any exception ){
	systemOutput( exception );
}
</cfscript>