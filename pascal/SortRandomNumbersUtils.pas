unit SortRandomNumbersUtils;

interface

procedure sort(var arr: array of Integer; number_count: Integer);
procedure generateRandomNumbers(var arr: array of Integer; from_number, to_number, number_count: Integer);
procedure printArray(arr: array of Integer; number_count: Integer);

implementation

procedure sort(var arr: array of Integer; number_count: Integer);
var
	i, j, temp: Integer;
begin
	for i := 0 to number_count - 2 do
		for j := i + 1 to number_count - 1 do
			if arr[i] > arr[j] then
			begin
				temp := arr[i];
        		arr[i] := arr[j];
        		arr[j] := temp;
      		end;
end;

procedure generateRandomNumbers(var arr: array of Integer; from_number, to_number, number_count: Integer);
var
	i: Integer;
begin
	Randomize;
	for i := 0 to number_count - 1 do
		(*random(x) returns a random number from 0 to x-1*)
		arr[i] := random(to_number - from_number + 1) + from_number;
end;

procedure printArray(arr: array of Integer; number_count: Integer);
var
	i: Integer;
begin
	for i := 0 to number_count - 1 do
		write(arr[i], ' ');
	writeln;
end;


end.
