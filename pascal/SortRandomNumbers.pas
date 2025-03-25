program SortRandomNumbers;

uses SysUtils, SortRandomNumbersUtils;

var
	from_number, to_number, number_count: Integer;
	numbers: array of Integer;

begin
	if ParamCount = 3 then
	begin
		from_number := StrToInt(ParamStr(1));
		to_number := StrToInt(ParamStr(2));
		number_count := StrToInt(ParamStr(3));
	end
	else
	begin
		from_number := 0;
		to_number := 100;
		number_count := 50;
	end;
	
  	SetLength(numbers, number_count);

  	generateRandomNumbers(numbers, from_number, to_number, number_count);
	writeln('Generated numbers:');
  	printArray(numbers, number_count);

  	sort(numbers, number_count);
  	writeln('Sorted numbers:');
  	printArray(numbers, number_count);
end.
