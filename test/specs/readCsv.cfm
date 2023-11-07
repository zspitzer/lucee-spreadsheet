<cfscript>
describe( "readCsv", function(){

	it( "can read a basic csv file into an array", function(){
		var path = getTestFilePath( "test.csv" );
		var expected = [ [ "Frumpo McNugget", "12345" ] ];
		var actual = s.readCsv( path )
			.intoAnArray()
			.execute();
		expect( actual ).toBe( expected );
	});

	it( "allows predefined formats to be specified", function(){
		var csv = '"Frumpo McNugget"#Chr( 9 )#12345';
		FileWrite( tempCsvPath, csv );
		var expected = [ [ "Frumpo McNugget", "12345" ] ];
		var actual = s.readCsv( tempCsvPath )
			.intoAnArray()
			.withPredefinedFormat( "TDF" )
			.execute();
		expect( actual ).toBe( expected );
	});

	it( "allows Commons CSV format options to be applied", function(){
		var path = getTestFilePath( "test.csv" );
		var object = s.readCsv( path )
			.withAllowMissingColumnNames( true )
			.withAutoFlush( true )
			.withCommentMarker( "##" )
			.withDelimiter( "|" )
			.withDuplicateHeaderMode( "ALLOW_EMPTY" )
			.withEscapeCharacter( "\" )
			.withHeader( [ "Name", "Number" ] )
			.withHeaderComments( [ "comment1", "comment2" ] )
			.withIgnoreEmptyLines( true )
			.withIgnoreHeaderCase( true )
			.withIgnoreSurroundingSpaces( true )
			.withNullString( "" )
			.withQuoteCharacter( "'" )
			.withSkipHeaderRecord( true )
			.withTrailingDelimiter( true )
			.withTrim( true );
		expect( object.getFormat().getAllowMissingColumnNames() ).toBeTrue();
		expect( object.getFormat().getAutoFlush() ).toBeTrue();
		expect( object.getFormat().getCommentMarker() ).toBe( "##" );
		expect( object.getFormat().getDelimiterString() ).toBe( "|" );
		expect( object.getFormat().getDuplicateHeaderMode().name() ).toBe( "ALLOW_EMPTY" );
		expect( object.getFormat().getEscapeCharacter() ).toBe( "\" );
		expect( object.getFormat().getHeader() ).toBe( [ "Name", "Number" ] );
		expect( object.getFormat().getHeaderComments() ).toBe( [ "comment1", "comment2" ] );
		expect( object.getFormat().getIgnoreEmptyLines() ).toBeTrue();
		expect( object.getFormat().getIgnoreHeaderCase() ).toBeTrue();
		expect( object.getFormat().getIgnoreSurroundingSpaces() ).toBeTrue();
		expect( object.getFormat().getNullString() ).toBe( "" );
		expect( object.getFormat().getQuoteCharacter() ).toBe( "'" );
		expect( object.getFormat().getSkipHeaderRecord() ).toBeTrue();
		expect( object.getFormat().getTrailingDelimiter() ).toBeTrue();
		expect( object.getFormat().getTrim() ).toBeTrue();
		//reverse check in case any of the above were defaults
		object
			.withAllowMissingColumnNames( false )
			.withAutoFlush( false )
			.withDuplicateHeaderMode( "ALLOW_ALL" )
			.withIgnoreEmptyLines( false )
			.withIgnoreHeaderCase( false )
			.withIgnoreSurroundingSpaces( false )
			.withSkipHeaderRecord( false )
			.withTrailingDelimiter( false )
			.withTrim( false );
		expect( object.getFormat().getAllowMissingColumnNames() ).toBeFalse();
		expect( object.getFormat().getAutoFlush() ).toBeFalse();
		expect( object.getFormat().getDuplicateHeaderMode().name() ).toBe( "ALLOW_ALL" );
		expect( object.getFormat().getIgnoreEmptyLines() ).toBeFalse();
		expect( object.getFormat().getIgnoreHeaderCase() ).toBeFalse();
		expect( object.getFormat().getIgnoreSurroundingSpaces() ).toBeFalse();
		expect( object.getFormat().getSkipHeaderRecord() ).toBeFalse();
		expect( object.getFormat().getTrailingDelimiter() ).toBeFalse();
		expect( object.getFormat().getTrim() ).toBeFalse();
	});

	it( "has special handling when specifying tab as the delimiter", function(){
		var csv = '"Frumpo McNugget"#Chr( 9 )#12345';
		FileWrite( tempCsvPath, csv );
		var validTabValues = [ "#Chr( 9 )#", "\t", "tab", "TAB" ];
		var expected = [ [ "Frumpo McNugget", "12345" ] ];
		for( var delimiter in validTabValues ){
			var actual = s.readCsv( tempCsvPath )
				.intoAnArray()
				.withDelimiter( delimiter )
				.execute();
			expect( actual ).toBe( expected );
		}
	});

	it( "allows N rows to be skipped at the start of the file", function(){
		var csv = 'Skip this line#crlf#skip this line too#crlf#"Frumpo McNugget",12345';
		var expected = [ [ "Frumpo McNugget", "12345" ] ];
		FileWrite( tempCsvPath, csv );
		var actual = s.readCsv( tempCsvPath )
			.intoAnArray()
			.skippingFirstRows( 2 )
			.execute();
		expect( actual ).toBe( expected );
	});

	it( "allows rows to be filtered out of processing using a passed filter UDF", function(){
		var csv = '"Frumpo McNugget",12345#crlf#"Skip",12345#crlf#"Susi Sorglos",67890';
		var expected = [ [ "Frumpo McNugget", "12345" ], [ "Susi Sorglos", "67890" ] ];
		FileWrite( tempCsvPath, csv );
		var filter = function( rowValues ){
			return !ArrayFindNoCase( rowValues, "skip" );
		};
		var actual = s.readCsv( tempCsvPath )
			.intoAnArray()
			.withRowFilter( filter )
			.execute();
		expect( actual ).toBe( expected );
	});

	afterEach( function(){
		if( FileExists( tempCsvPath ) )
			FileDelete( tempCsvPath );
	});

	describe( "throws an exception if", function(){

		it( "a zero or positive integer is not passed to skippingFirstRows()", function(){
			expect( function(){
				var actual = s.readCsv( getTestFilePath( "test.csv" ) ).skippingFirstRows( -1 );
			}).toThrow( type="cfsimplicity.spreadsheet.invalidArgument" );
		});

	});

});
</cfscript>