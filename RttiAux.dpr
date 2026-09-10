program RttiAux;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  GBJSON.Helper,
  System.SysUtils,
  System.Generics.Collections,
  Interfaces.User in 'Types\Interfaces\Interfaces.User.pas',
  Types.Generic in 'Types\Implementations\Types.Generic.pas',
  Types.User in 'Types\Implementations\Types.User.pas',
  Interfaces.Generic in 'Types\Interfaces\Interfaces.Generic.pas',
  Types.Default in 'Types\Implementations\Types.Default.pas',
  Interfaces.Default in 'Types\Interfaces\Interfaces.Default.pas',
  Utils.TClass in 'Helpers\Utils.TClass.pas',
  Helper.TObject in 'Helpers\Helper.TObject.pas',
  Utils.Records in 'Helpers\Utils.Records.pas',
  Types.Compose in 'Types\Implementations\Types.Compose.pas';

procedure UseProc();
var
  lIntervaloCodigo: RIntervaloCodigo;
begin
  lIntervaloCodigo := RIntervaloCodigo
  ('{"dataInicial": "12/12/2024", "dataFinal": "12/12/2024", "Codigo": 123}');
  Writeln(lIntervaloCodigo.ToString);
end;

begin
try
  UseProc;
  Readln;
except
  on E: Exception do
    Writeln(E.ClassName, ': ', E.Message);
end;
end.
