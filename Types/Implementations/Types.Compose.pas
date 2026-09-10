unit Types.Compose;

interface

uses
  Types.Default;

type
  RIntervaloCodigo = record
    Intervalo: RIntervalo;
    Codigo: RCodigo;

    class operator Explicit(AString: String): RIntervaloCodigo;
    function ToString: String;
  end;

implementation

{ RIntervaloCodigo }

class operator RIntervaloCodigo.Explicit(AString: String): RIntervaloCodigo;
begin
  Result.Intervalo := RIntervalo(AString);
  Result.Codigo := RCodigo(AString);
end;

function RIntervaloCodigo.ToString: String;
begin
  Result := Self.Intervalo.ToString;
  Result := Result + Self.Codigo.ToString;
end;

end.
