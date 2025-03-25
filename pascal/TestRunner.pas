(*fpc TestRunner.pas && ./TestRunner*)

program TestRunner;
{$mode objfpc}{$H+}

uses fpcunit, testregistry, testreport, SortRandomNumbersUtils, SortRandomNumbersTest;

var
    Writer : TPlainResultsWriter;
    TestResult : TTestResult;
    Test : TTest;

begin
    Writer := TPlainResultsWriter.Create;
    TestResult := TTestResult.Create;
    Test := GetTestRegistry;

    TestResult.AddListener(Writer);
    Test.Run(TestResult);
    Writer.WriteResult(TestResult);
end.
