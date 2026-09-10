unit Types.Generic;

interface uses
  Interfaces.Generic,
  System.Generics.Collections, System.Rtti;

type
  TGeneric = class(TInterfacedObject, IGeneric)
  strict private
    FPropIsFilled: TDictionary<String,Boolean>;
    function getPropIsFilled: TDictionary<String,Boolean>;
  protected
    function SetValues(PropNames: String; Values: TArray<String>): Boolean; overload;
    function SetValues(PropNames: TArray<String>; Values: TArray<String>): Boolean; overload;
    function SetValues(jsonString: String): Boolean; overload;
    constructor Create;
    destructor Destroy; override;
  public
    function Tryget(propName: String; out Value: TValue): Boolean;
    function TrySet(propName: String; Value: TValue): Boolean;

    class function hasProperty(propName:String;
      AReadable: Boolean = False; AWritable: Boolean = False): Boolean;

    procedure UnFill(propName: String);
    procedure UnFillAll;
    function ToString: String;
    // controle se campos foram setados ou não
    property isFilled: TDictionary<String,Boolean> read getPropIsFilled;
  end;

implementation uses
  System.SysUtils, System.JSON, System.RegularExpressions, Helper.TObject, Utils.TClass;

{ TGeneric }
function TGeneric.SetValues(PropNames, Values: TArray<String>): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := Low(Values) to High(Values) do
  begin
    PropNames[I] := PropNames[I].Trim.ToLower;
    if Self.hasProperty(PropNames[i]) then
    begin
      Self.SetPropValue(PropNames[I],Values[I]);
      Result := True;
    end;
  end;
end;

constructor TGeneric.Create;
var
  vmi: TVirtualMethodInterceptor;
  propName: String;
begin
  Self.FPropIsFilled := TDictionary<String,Boolean>.Create;

  for propName in Self.getPropNames do
    Self.FPropIsFilled.AddOrSetValue(propName.ToLower, False);

  vmi := TVirtualMethodInterceptor.Create(Self.ClassType);
  vmi.OnBefore :=
  procedure (
    Instance: TObject;
    Method: TRttiMethod;
    const Args: TArray<TValue>;
    out DoInvoke: Boolean;
    out Response: TValue)
  var
    lValue: TValue;
    lTypeOfAcessorMethod: String;
    lFieldName: String;
  begin
    DoInvoke := False;

    if Method.Name.ToLower = 'afterconstruction' then
      Writeln(Format('Executando Construtor da Classe <%s>',[Instance.ClassName]));

    if Method.Name.ToLower = 'beforedestruction' then
      Writeln(Format('Executando Destrutor da Classe <%s>',[Instance.ClassName]));

    // pega tipo do metodo
    lTypeOfAcessorMethod := Method.Name.Substring(0,3);

    // pega campo que se esta modificando
    lFieldName := Method.Name.Substring(3,Length(Method.Name) - 3);

    if (lTypeOfAcessorMethod.ToLower = 'get') then
    begin
      Response := Self.getFieldValue('F' + lFieldName);
    end
    else if (lTypeOfAcessorMethod.ToLower = 'set') then
    begin
      Self.setFieldValue('F' + lFieldName, Args[0]);
      Self.FPropIsFilled[lFieldName.ToLower] := True;
    end;
  end;
  vmi.Proxify(Self);
end;

destructor TGeneric.Destroy;
begin
  Self.FPropIsFilled.Free;
end;

function TGeneric.getPropIsFilled: TDictionary<String, Boolean>;
begin
  Result := Self.FPropIsFilled;
end;

class function TGeneric.hasProperty(propName: String; AReadable: Boolean = False; AWritable: Boolean = False): Boolean;
begin
  Result := Utils.TClass.HasProperty(Self, propName, AReadable, AWritable);
end;

function TGeneric.SetValues(jsonString: String): Boolean;
var
  jsonValue: TJSONValue;
  jsonObject: TJSONObject;
  pair: TJSONPair;
  I: Integer;
  Key: String;
  Value: String;
  Match: TMatch;
const 
  FORMAT = '^"(.*)"$';
begin
try
  Result := False;
  jsonValue := TJSONObject.ParseJSONValue(jsonString);
  if (jsonValue = nil) or (not (jsonValue is TJSONObject)) then
    raise Exception.Create('Não foi possivel realizar o cast da string json para TJSONObject');

  jsonObject := (jsonValue as TJSONObject);
    
  I := 0;
  while I < jsonObject.Count do
  begin
    Pair := jsonObject.Pairs[I];
      
    Key := Pair.JsonString.ToString;
    Match := TRegEx.Match(Key, FORMAT);
    if Match.Success then
    begin
      Key := Key.Substring(Match.Groups[1].Index - 1,Match.Groups[1].Length);
    end;
      
    Value := Pair.JsonValue.ToString;
    Match := TRegEx.Match(Value, FORMAT);
    if Match.Success then
    begin
      Value := Value.Substring(Match.Groups[1].Index - 1,Match.Groups[1].Length);
    end;

    if Self.hasProperty(Key) then
    begin
      Self.SetPropValue(Key,Value);
      Result := True;
    end;

    Inc(I);
  end;
finally
  jsonValue.Free;
end;
end;

function TGeneric.SetValues(PropNames: String; Values: TArray<String>): Boolean;
begin
  Self.SetValues(propNames.Split([',']), Values);
end;

function TGeneric.ToString: String;
var
  propNames: TArray<String>;
  propName: String;
  value: TValue;
  isFilledProp: Boolean;
begin
  Result :='{';
  propNames := Self.getPropNames();
  for propName in propNames do
  begin
    if propName = 'isFilled' then
      continue;

    if (
      Self.isFilled.TryGetValue(propName, isFilledProp) and
      (not isFilledProp) )
    then
      continue;

    value := Self.getPropValue(propName);
    Result := Result + Format('%s : %s ,', [propName, value.ToString])
  end;
  Delete(Result, Length(Result), 1);
  Result := Result + '}';
end;

function TGeneric.Tryget(propName: String; out Value: TValue): Boolean;
begin
  Result := False;
  if Self.hasProperty(propName, True) then
  begin
    Value := Self.getPropValue(propName);
    Result := True;
  end;
end;

function TGeneric.TrySet(propName: String; Value: TValue): Boolean;
begin
  Result := False;
  if Self.hasProperty(PropName, False, True) then
  begin
    Self.SetPropValue(propName, Value);
    Result := True;
  end;
end;

procedure TGeneric.UnFill(propName: String);
begin
  if not Self.FPropIsFilled.ContainsKey(propName.ToLower) then
    raise Exception.Create('Propriedade ' + propName + ' não foi encontrada na classe ' + Self.ClassName);
  Self.FPropIsFilled[propName.ToLower] := False;
end;

procedure TGeneric.UnFillAll;
var
  Key: String;
begin
  for Key in Self.FPropIsFilled.Keys do
    Self.FPropIsFilled[Key] := False;
end;

end.
