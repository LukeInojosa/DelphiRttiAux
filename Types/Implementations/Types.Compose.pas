unit Types.Compose;

interface

uses
  Types.Default;


type
  {Tipo Composto de Dados}
  RIntervaloCodigo = record
  private
    {É esperado que as validações de dados já tenham
    sido realizadas antecipadamente nos tipos simples
    de dados: Aqueles que são implementados com interfaces.
    O Tipo composto de dados apenas dá visibilidade para elas}
    FIntervalo: RIntervalo;
    FCodigo: RCodigo;

    function getCodigo: Integer;
    function getDataFinal: TDateTime;
    function getDataInicial: TDateTime;
    procedure setCodigo(const Value: Integer);
    procedure setDataFinal(const Value: TDateTime);
    procedure setDataInicial(const Value: TDateTime);
  public

    {properties são redefinidas apenas para deixar
    mais intuitivo o acesso dos dados, mas não são
    obrigatórias}
    property DataInicial: TDateTime read getDataInicial write setDataInicial;
    property DataFinal: TDateTime read getDataFinal write setDataFinal;
    property Codigo: Integer read getCodigo write setCodigo;

    class operator Explicit(AString: String): RIntervaloCodigo;
    function ToString: String;
  end;

implementation

{ RIntervaloCodigo }

class operator RIntervaloCodigo.Explicit(AString: String): RIntervaloCodigo;
begin
  Result.FIntervalo := RIntervalo(AString);
  Result.FCodigo := RCodigo(AString);
end;

function RIntervaloCodigo.getCodigo: Integer;
begin
  Result := Self.FCodigo.Data.codigo;
end;

function RIntervaloCodigo.getDataFinal: TDateTime;
begin
  Result := Self.FIntervalo.Data.dataFinal;
end;

function RIntervaloCodigo.getDataInicial: TDateTime;
begin
  Result := Self.FIntervalo.Data.dataInicial;
end;

procedure RIntervaloCodigo.setCodigo(const Value: Integer);
begin
  Self.FCodigo.Data.codigo := Value;
end;

procedure RIntervaloCodigo.setDataFinal(const Value: TDateTime);
begin
  Self.FIntervalo.Data.dataFinal := Value;
end;

procedure RIntervaloCodigo.setDataInicial(const Value: TDateTime);
begin
  Self.FIntervalo.Data.dataInicial := Value;
end;

function RIntervaloCodigo.ToString: String;
begin
  Result := Self.FIntervalo.ToString;
  Result := Result + Self.FCodigo.ToString;
end;

end.
