<cfscript>
describe( "cellFormula", function(){

	beforeEach( function(){
		variables.workbooks = [ s.newXls(), s.newXlsx() ];
		workbooks.Each( function( wb ){
			s.addColumn( wb, "1,1" );
		});
		variables.theFormula = "SUM(A1:A2)";
	});

	it( "Sets and gets the specified formula for the specified cell", function(){
		workbooks.Each( function( wb ){
			s.setCellFormula( wb, theFormula, 3, 1 );
			expect( s.getCellFormula( wb, 3, 1 ) ).toBe( theFormula );
			expect( s.getCellValue( wb, 3, 1 ) ).toBe( 2 );
		});
	});

	it( "setCellFormula and getCellFormula are chainable", function(){
		workbooks.Each( function( wb ){
			var actual = s.newChainable( wb )
				.setCellFormula( theFormula, 3, 1 )
				.getCellFormula( 3, 1 );
			expect( actual ).toBe( theFormula );
			expect( s.getCellValue( wb, 3, 1 ) ).toBe( 2 );
		});
	});

	it( "Gets all formulas from the workbook", function(){
		workbooks.Each( function( wb ){
			s.setCellFormula( wb, theFormula, 3, 1 );
			var expected = [{
				formula: theFormula
				,row: 3
				,column: 1
			}];
			var actual = s.getCellFormula( wb );
			expect( actual ).toBe( expected );
		});
	});

	it( "Returns an empty string if the specified cell doesn't exist", function(){
		workbooks.Each( function( wb ){
			var actual = s.getCellFormula( wb, 100, 100 );
			expect( actual ).toBeEmpty();
		});
	});

	describe( "recalculation", function(){

		it( "can set a flag for all formulas to be recalculated in the workbook the next time the file is opened", function(){
			// only xlsx seems to reflect the flag status
			var wb = s.newXlsx();
			expect( wb.getForceFormulaRecalculation() ).toBeFalse();
			s.setRecalculateFormulasOnNextOpen( wb );
			expect( wb.getForceFormulaRecalculation() ).toBeTrue();
		});

		it( "getForceFormulaRecalculation is chainable", function(){
			// only xlsx seems to reflect the flag status
			var wb = s.newXlsx();
			expect( wb.getForceFormulaRecalculation() ).toBeFalse();
			s.newChainable( wb ).setRecalculateFormulasOnNextOpen();
			expect( wb.getForceFormulaRecalculation() ).toBeTrue();
		});

	});

});	
</cfscript>