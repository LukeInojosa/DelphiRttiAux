unit Utils.Records;

interface

uses
  System.Rtti,
  Helper.TObject;

type TRecordUtil<T:record> = record
    // implementar profundidade da busca no futuro
   class procedure setInnerPropValue(ARec: T; propName: String; propValue:TValue); static;
   class function getInnerPropValue(ARec: T; propName: String): TValue; static;
end;

implementation

uses
  System.SysUtils;

{ TRecordUtil<T> }

class function TRecordUtil<T>.getInnerPropValue(ARec: T; propName: String): TValue;
var
  ctx: TRttiContext;
  RttiType: TRttiType;
  Field: TRttiField;
  FieldType: TRttiType;
  InnerProperty: TRttiProperty;
begin
  Result := Nil;
try
  ctx := TRttiContext.Create;

  RttiType := ctx.GetType(TypeInfo(T));

  for Field in RttiType.GetFields do
  begin

    FieldType := Field.FieldType;

    InnerProperty := FieldType.GetProperty(propName);

    if not Assigned(InnerProperty) then
       continue;

    Result := innerProperty.GetValue(Field.GetValue(@ARec).AsObject);

    exit;
  end;
finally
  ctx.Free;
end;
end;

class procedure TRecordUtil<T>.setInnerPropValue(ARec:T; propName: String;
  propValue: TValue);
var
  ctx: TRttiContext;
  RttiType: TRttiType;
  Field: TRttiField;
  FieldType: TRttiType;
  InnerProperty: TRttiProperty;
  P: TRttiProperty;
begin
try
  ctx := TRttiContext.Create;

  RttiType := ctx.GetType(TypeInfo(T));

  for Field in RttiType.GetFields do
  begin
    FieldType := Field.FieldType;

    InnerProperty := FieldType.GetProperty(propName);

    for P in FieldType.GetProperties do
      Writeln(P.Name);


    if not Assigned(InnerProperty) then
       continue;

    if not InnerProperty.IsWritable then
      raise Exception.Create('propriedade <' + propName + '> nao eh writable');

    Field.GetValue(@ARec).AsObject.setRttiProperty(InnerProperty, propValue);

    exit;
  end;
  raise Exception.Create('Nao foi possivel conseguir achar o tipo no contexto');

finally
  ctx.Free;
end;
end;

end.
