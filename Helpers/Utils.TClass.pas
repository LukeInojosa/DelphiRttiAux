unit Utils.TClass;

interface uses
  System.Rtti,
  System.TypInfo;

function HasProperty(AClass: TClass; APropName: String; ARedable: Boolean = False; AWritable: Boolean = False): Boolean;


implementation

uses
  System.SysUtils;

{ HelperTClass }

function HasProperty(AClass: TClass; APropName: String; ARedable: Boolean = False; AWritable: Boolean = False): Boolean;
var
  Ctx : TRttiContext;
  RttiType: TRttiType;
  Prop: TRttiProperty;
begin
  try
    Ctx := TRttiContext.Create();
    RttiType := Ctx.GetType(AClass);

    if not Assigned(RttiType) then
      raise Exception.Create('Nao foi possivel conseguir achar o tipo no contexto');

    Prop := RttiType.GetProperty(APropName);

    Result := Assigned(Prop);

    if ARedable then
      Result := Result and Prop.IsReadable;
    if AWritable then
      Result := Result and Prop.IsWritable;

  finally
    Ctx.Free
  end;
end;


end.
