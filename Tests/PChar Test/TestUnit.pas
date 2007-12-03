unit TestUnit;

interface
	var
		teststring : String;

	procedure WriteString();

	function GetString() : String;
	
	procedure SetString(word : String);
	
implementation

	procedure WriteString();
	begin
		WriteLn(teststring);
	end;
	
	function GetString() : String;
	begin
		result := teststring;
	end;
	
	procedure SetString(word : String);
	begin
		teststring := word;
	end;
	
	
end.