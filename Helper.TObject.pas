unit Helper.TObject;

interface uses
  System.Rtti,
  System.Generics.Collections;

type HelperTOBJ = class helper for TObject
   procedure SetPropValue(propName: String; propValue: TValue);
   function getPropNames(): TArray<String>;
   function getPropValue(propName: String): TValue;
   function call(methodName: String; const args: array of TValue): TValue;
end;

implementation

uses
  System.SysUtils;

{ HelperTOBJ }


function HelperTOBJ.call(methodName: String; const args: array of TValue): TValue;
var
  Ctx: TRttiContext;
  RttiType: TRttiType;
  RttiMethod: TRttiMethod;
begin
  try
    Ctx := TRttiContext.Create;
    RttiType := Ctx.GetType(Self.ClassType);
    if not Assigned(RttiType) then
       raise Exception.Create('Nao foi possivel conseguir achar o tipo no contexto');

    RttiMethod := RttiType.GetMethod(methodName);
    if not Assigned(RttiMethod) then
       raise Exception.Create('Metodo <' + methodName + '> nao foi encontrado na classe');

    Result := RttiMethod.Invoke(Self, args);
  finally
    Ctx.Free;
  end;
end;

function HelperTOBJ.getPropNames: TArray<String>;
var
  Ctx : TRttiContext;
  RttiType: TRttiType;
  Properties: TArray<TRttiProperty>;
  prop: TRttiProperty;
  Arr: TArray<String>;
begin
  try
    Ctx := TRttiContext.Create;
    RttiType := Ctx.GetType(Self.ClassType);
    if not Assigned(RttiType) then
      raise Exception.Create('Nao foi possivel conseguir achar o tipo no contexto');

    Properties := RttiType.GetProperties;

    if not Assigned(Properties) then
      raise Exception.Create('Nao foi possivel conseguir Properties do tipo');

    for prop in Properties do
    begin
       System.Insert(prop.Name,Arr,0);
    end;

    Result := Arr;
  finally
    Ctx.Free;
  end;
end;

function HelperTOBJ.getPropValue(propName: String): TValue;
var
  Ctx: TRttiContext;
  RttiType: TRttiType;
  prop: TRttiProperty;
  propType: TRttiType;
begin
  try
    Ctx := TRttiContext.Create;
    RttiType := Ctx.GetType(Self.ClassType);
    if not Assigned(RttiType) then
      raise Exception.Create('Nao foi possivel conseguir achar o tipo no contexto');

    prop := RttiType.GetProperty(propName);

    if not prop.IsReadable then
      raise Exception.Create('propriedade <' + propName + '> nao eh readable');

    //Result := TPair<String,TValue>.Create(
    //              prop.PropertyType.Name,
    //              prop.GetValue(Self));
    Result := prop.GetValue(Self);
  finally
    Ctx.Free;
  end;
end;

procedure HelperTOBJ.SetPropValue(propName: String; propValue: TValue);
var
  Ctx : TRttiContext;
  RttiType: TRttiType;
  Prop: TRttiProperty;
begin
  try
    Ctx := TRttiContext.Create();
    RttiType := Ctx.GetType(Self.ClassType);

    if not Assigned(RttiType) then
      raise Exception.Create('Nao foi possivel conseguir achar o tipo no contexto');

    Prop := RttiType.GetProperty(propName);

    if not Assigned(Prop) then
      raise Exception.Create('propriedade <' + propName + '> nao existe na classe');

    if not Prop.IsWritable then
      raise Exception.Create('propriedade <' + propName + '> nao eh writable');

    Prop.SetValue(Self,propValue);
  finally
    Ctx.Free;
  end;
end;



{ HelperTValue }

end.
