unit SortRandomNumbersTest;
{$mode objfpc}{$H+}

interface

uses fpcunit, testregistry, SortRandomNumbersUtils;

type
	TProgramTest = class(TTestCase)
	published
		procedure TestSort_EmptyArray;
		procedure TestSort_SingleElement;
		procedure TestSort_AlreadySorted;
		procedure TestSort_UnsortedArray;
		procedure TestGRN_InRange;
	end;
  
implementation

procedure TProgramTest.TestSort_EmptyArray;
var
	numbers: array of SmallInt;
begin
	SetLength(numbers, 0);
	sort(numbers, 0);
	AssertEquals(0, Length(numbers));
end;

procedure TProgramTest.TestSort_SingleElement;
var
	numbers: array of SmallInt;
begin
	SetLength(numbers, 1);
	numbers[0] := 42;
	sort(numbers, 1);
	AssertEquals(42, numbers[0]);
end;

procedure TProgramTest.TestSort_AlreadySorted;
var
	numbers: array of SmallInt;
begin
	SetLength(numbers, 5);
	numbers[0] := 1;
	numbers[1] := 2;
	numbers[2] := 3;
	numbers[3] := 4;
	numbers[4] := 5;

	sort(numbers, 5);

	AssertEquals(1, numbers[0]);
	AssertEquals(2, numbers[1]);
	AssertEquals(3, numbers[2]);
	AssertEquals(4, numbers[3]);
	AssertEquals(5, numbers[4]);
end;

procedure TProgramTest.TestSort_UnsortedArray;
var
	numbers: array of SmallInt;
begin
	SetLength(numbers, 5);
	numbers[0] := 8;
	numbers[1] := 10;
	numbers[2] := 7;
	numbers[3] := 14;
	numbers[4] := 5;

	sort(numbers, 5);

	AssertEquals(5, numbers[0]);
	AssertEquals(7, numbers[1]);
	AssertEquals(8, numbers[2]);
	AssertEquals(10, numbers[3]);
	AssertEquals(14, numbers[4]);
end;

procedure TProgramTest.TestGRN_InRange;
var
	numbers: array of SmallInt;
	i, from_number, to_number, number_count: Integer;
	valid: Boolean;
begin
	from_number := 10;
	to_number := 20;
	number_count := 100;

	SetLength(numbers, number_count);
	generateRandomNumbers(numbers, from_number, to_number, number_count);

	valid := True;
	for i := 0 to number_count - 1 do
	begin
		if (numbers[i] < from_number) or (numbers[i] > to_number) then
		begin
			valid := False;
			Break;
		end;
	end;

	AssertTrue(valid);
end;

initialization
	RegisterTest(TProgramTest);
end.
