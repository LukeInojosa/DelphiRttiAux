unit Types.Default;

interface uses
  Interfaces.Default;
type
  RCodigo = record
    Data: ICodigo;

    class operator Explicit(AString: String): RCodigo;
    function isFilled(const APropName: String): Boolean;
    function ToString: String;
  end;

  RDescricao = record
    Data: IDescricao;

    class operator Explicit(AString: String): RDescricao;
    function isFilled(const APropName: String): Boolean;
    function ToString: String;
  end;

  RIntervalo = record
    Data: IIntervalo;

    class operator Explicit(AString: String): RIntervalo;
    function isFilled(const APropName: String): Boolean;
    function ToString: String;
  end;

implementation
{ RCodigo }

class operator RCodigo.Explicit(AString: String): RCodigo;
begin
  Result.Data := TCodigo.Create;
  Result.Data.SetValues(AString);
  Result.Data._Release;
end;

function RCodigo.isFilled(const APropName: String): Boolean;
begin
  Result := False;
  Self.Data.isFilled.tryGetValue(APropName, Result);
end;

function RCodigo.ToString: String;
begin
  if Assigned(Self.Data) then
    Exit(Self.Data.ToString);
end;

{ RDescricao }

class operator RDescricao.Explicit(AString: String): RDescricao;
begin
  Result.Data := TDescricao.Create;
  Result.Data.SetValues(AString);
end;

function RDescricao.isFilled(const APropName: String): Boolean;
begin
  Result := False;
  Self.Data.isFilled.tryGetValue(APropName, Result);
end;

function RDescricao.ToString: String;
begin
  if Assigned(Self.Data) then
    Exit(Self.Data.ToString);
end;

{ RIntervalo }

class operator RIntervalo.Explicit(AString: String): RIntervalo;
begin
  Result.Data := TIntervalo.Create;
  Result.Data.SetValues(AString);
  Result.Data._Release;
end;

function RIntervalo.isFilled(const APropName: String): Boolean;
begin
  Result := False;
  Self.Data.isFilled.tryGetValue(APropName, Result);
end;

function RIntervalo.ToString: String;
begin
  if Assigned(Self.Data) then
    Exit(Self.Data.ToString);
end;

end.
