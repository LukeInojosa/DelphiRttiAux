unit Helper.TObject;

interface uses
  System.Rtti,
  System.Generics.Collections,
  System.TypInfo;

type PIntPtr = ^IntPtr;
type
  HelperTOBJ = class helper for TObject
    {Properties}
     procedure setRttiProperty(Prop: TRttiProperty; propValue: TValue);
     procedure SetPropValue(propName: String; propValue: TValue); overload;
     function getPropValue(propName: String): TValue;
     function getPropNames(): TArray<String>;
     function getDeclaredPropNames(): Tarray<String>;

     {Fields}
     function hasField(fieldName: String): Boolean;
     procedure setFieldValue(fieldName: String; fieldValue: TValue);
     function getFieldValue(fieldName: String): TValue;

     function call(methodName: String; const args: array of TValue): TValue;

     // implementar profundidade da busca no futuro
     procedure setInnerPropValue(propName: String; propValue:TValue);
     function getInnerPropValue(propName: String): TValue;

     function hasProp(propName: String): Boolean;

     // retorna o nome do getter da propriedade APropName
     function getterNameOf(APropName: String): String;

     // retorna o nome do setter da propriedade APropName
     function setterNameOf(APropName: String): String;

     // retona o ponteiro na classe de um offset de ponteiro de função
     function getPointerOfMethod(APointer: Pointer): Pointer;
  end;


implementation

uses
  System.SysUtils;

var
  Ctx: TRttiContext;
{ HelperTOBJ }


function HelperTOBJ.call(methodName: String; const args: array of TValue): TValue;
var
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

function HelperTOBJ.getDeclaredPropNames: Tarray<String>;
var
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

    Properties := RttiType.GetDeclaredProperties;

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

function HelperTOBJ.getFieldValue(fieldName: String): TValue;
var
  RttiType: TRttiType;
  RttiField: TRttiField;
begin
  try
    Ctx := TRttiContext.Create;
    RttiType := Ctx.GetType(Self.ClassType);
    if not Assigned(RttiType) then
      raise Exception.Create('Nao foi possivel conseguir achar o tipo no contexto');

    RttiField := RttiType.GetField(fieldName);

    if not Assigned(RttiField) then
      raise EArgumentException.Create('Field ' + fieldName + '  não encontrado');

     Result := RttiField.GetValue(Self);
  finally
    Ctx.Free;
  end;
end;

function HelperTOBJ.getInnerPropValue(propName: String): TValue;
var
  RttiType: TRttiType;
  Field: TRttiField;
  FieldType: TRttiType;
  InnerProperty: TRttiProperty;
begin
  Result := Nil;

  ctx := TRttiContext.Create;

  RttiType := ctx.GetType(Self.ClassType);

  for Field in RttiType.GetFields do
  begin
    FieldType := Field.FieldType;

    InnerProperty := FieldType.GetProperty(propName);

    if not Assigned(InnerProperty) then
       continue;

    Result := innerProperty.GetValue(Field.GetValue(Self).AsObject);

    exit;
  end;
end;

function HelperTOBJ.getPointerOfMethod(APointer: Pointer): Pointer;
begin
  if (IntPtr(APointer) and PROPSLOT_MASK) = PROPSLOT_FIELD then
  begin
    // Field
    Result := PByte(Self) + (IntPtr(APointer) and (not PROPSLOT_MASK));
    Exit;
  end;

  if (IntPtr(APointer) and PROPSLOT_MASK) = PROPSLOT_VIRTUAL then
  begin
    // Virtual dispatch, but with offset, not slot
    Result := PPointer(PIntPtr(Self)^ + SmallInt(IntPtr(APointer)))^;
  end
  else
  begin
    // Static dispatch
    Result := APointer;
  end;
end;

function HelperTOBJ.getPropNames: TArray<String>;
var
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
  RttiType: TRttiType;
  prop: TRttiProperty;
  propType: TRttiType;
begin
  try
    Ctx := TRttiContext.Create;
    RttiType := Ctx.GetType(Self.ClassType);

    if not Assigned(RttiType) then
      raise EArgumentException.Create('Nao foi possivel conseguir achar o tipo no contexto');

    prop := RttiType.GetProperty(propName);

    if not Assigned(Prop) then
      raise EArgumentException.Create('propriedade <' + propName + '> nao existe na classe');

    if not prop.IsReadable then
      raise EAccessViolation.Create('propriedade <' + propName + '> nao eh readable');

    Result := prop.GetValue(Self);
  finally
    Ctx.Free;
  end;
end;

function HelperTOBJ.getterNameOf(APropName: String): String;
var
  RttiType: TRttiType;
  RttiProperty: TRttiProperty;
  InstanceProp: TRttiInstanceProperty;
  lPropInfo: PPropInfo;
  RttiMethod: TRttiMethod;
  Getter: Pointer;
begin
  Ctx := TRttiContext.Create;
  try
   RttiType := Ctx.GetType(Self.ClassType);

    if not Assigned(RttiType) then
      raise Exception.Create('Nao foi possivel conseguir achar o tipo no contexto');

    RttiProperty := RttiType.GetProperty(APropName);

    if not Assigned(RttiProperty) then
      raise EArgumentException.Create('Property ' + APropName + '  não encontrado');

    if not (RttiProperty is TRttiInstanceProperty) then
      raise Exception.Create('Não foi possivel converter Property');

    if not RttiProperty.IsReadable then
      raise Exception.Create('Property ' + APropName + ' não é readable' );

    InstanceProp := TRttiInstanceProperty(RttiProperty);
    lPropInfo := InstanceProp.PropInfo;
    Getter := lPropInfo^.GetProc ;

    if Getter = nil then
      raise Exception.Create('Property ' + APropName + ' Não possui getter visivel');

    for RttiMethod in RttiType.GetMethods do
    begin
      if RttiMethod.CodeAddress = Self.getPointerOfMethod(Getter) then
        Exit(RttiMethod.Name);
    end;

    raise Exception.Create('Método não foi encontrado');
  finally
    Ctx.Free;
  end;
end;

function HelperTOBJ.hasField(fieldName: String): Boolean;
var
  RttiType: TRttiType;
  RttiField: TRttiField;
begin
  try
    Ctx := TRttiContext.Create;
    RttiType := Ctx.GetType(Self.ClassType);

    if not Assigned(RttiType) then
      raise Exception.Create('Nao foi possivel conseguir achar o tipo no contexto');

    RttiField := RttiType.GetField(fieldName);

    Result := Assigned(RttiField);
  finally
    Ctx.Free;
  end;
end;

function HelperTOBJ.hasProp(propName: String): Boolean;
var
  RttiType: TRttiType;
  prop: TRttiProperty;
  propType: TRttiType;
begin
  try
    Ctx := TRttiContext.Create;
    RttiType := Ctx.GetType(Self.ClassType);

    if not Assigned(RttiType) then
      raise EArgumentException.Create('Nao foi possivel conseguir achar o tipo no contexto');

    prop := RttiType.GetProperty(propName);
    Result := Assigned(prop);
  finally
    Ctx.Free;
  end;
end;

procedure HelperTOBJ.setFieldValue(fieldName: String; fieldValue: TValue);
var
  RttiType: TRttiType;
  RttiField: TRttiField;
begin
  try
    ctx := TRttiContext.Create;

    RttiType := ctx.GetType(Self.ClassType);
    if not Assigned(RttiType) then
      raise Exception.Create('Nao foi possivel conseguir achar o tipo no contexto');

    RttiField := RttiType.GetField(fieldName);
    if not Assigned(RttiField) then
      raise EArgumentException.Create('Field ' + fieldName + '  não encontrado');

    RttiField.SetValue(Self, fieldValue);
  finally
    ctx.Free;
  end;
end;

procedure HelperTOBJ.setInnerPropValue(propName: String; propValue: TValue);
var
  RttiType: TRttiType;
  Field: TRttiField;
  FieldType: TRttiType;
  InnerProperty: TRttiProperty;
begin
  ctx := TRttiContext.Create;

  RttiType := ctx.GetType(Self.ClassType);

  for Field in RttiType.GetFields do
  begin
    FieldType := Field.FieldType;

    InnerProperty := FieldType.GetProperty(propName);

    if not Assigned(InnerProperty) then
       continue;

    if not InnerProperty.IsWritable then
      raise Exception.Create('propriedade <' + propName + '> nao eh writable');

    Field.GetValue(Self).AsObject.setRttiProperty(InnerProperty, propValue);

    exit;
  end;

  raise Exception.Create('Nao foi possivel conseguir achar o tipo no contexto');
end;

procedure HelperTOBJ.SetPropValue(propName: String; propValue: TValue);
var
  RttiType: TRttiType;
  Prop: TRttiProperty;
  propValueAsString: String;
begin
  try
    Ctx := TRttiContext.Create();
    RttiType := Ctx.GetType(Self.ClassType);

    if not Assigned(RttiType) then
      raise EArgumentException.Create('Nao foi possivel conseguir achar o tipo no contexto');

    Prop := RttiType.GetProperty(propName);

    if not Assigned(Prop) then
      raise EArgumentException.Create('propriedade <' + propName + '> nao existe na classe');

    if not Prop.IsWritable then
      raise EAccessViolation.Create('propriedade <' + propName + '> nao eh writable');

    Self.setRttiProperty(Prop, PropValue);
  finally
    Ctx.Free;
  end;
end;

procedure HelperTOBJ.setRttiProperty(Prop: TRttiProperty;
  propValue: TValue);
var
  propValueAsString: String;
begin
  if (propValue.Kind <> Prop.PropertyType.TypeKind) then
  begin
    if not (propValue.Kind in [tkString, tkUString, tkWString, tkLString, tkChar, tkWChar]) then
      raise ENotImplemented.Create('Ainda não há implementação para outra conversão');

    propValueAsString := propValue.ToString;

    case Prop.PropertyType.TypeKind of
      tkInteger:  Prop.SetValue(Self,StrToInt(propValueAsString));
      tkChar,
      tkLString,
      tkWString,
      tkWChar,
      tkUString,
      tkString: Prop.SetValue(Self,propValueAsString);
      tkInt64: Prop.SetValue(Self,StrToUInt64(propValueAsString));
      tkFloat:
        case Prop.PropertyType.Handle.TypeData.FloatType of
          ftSingle: Prop.SetValue(Self,StrToFloat(propValueAsString));
          ftDouble:
          begin
            if Prop.PropertyType.Handle = System.TypeInfo(TDate) then
              Prop.SetValue(Self,StrToDate(propValueAsString))
            else if Prop.PropertyType.Handle = System.TypeInfo(TTime) then
              Prop.SetValue(Self,StrToTime(propValueAsString))
            else if Prop.PropertyType.Handle = System.TypeInfo(TDateTime) then
              Prop.SetValue(Self,StrToDateTime(propValueAsString))
            else
              Prop.SetValue(Self,StrToFloat(propValueAsString))
          end;
          ftExtended: Prop.SetValue(Self,StrToFloat(propValueAsString));
          ftComp: Prop.SetValue(Self,StrToInt(propValueAsString));
          ftCurr: Prop.SetValue(Self,StrToCurr(propValueAsString));
        end;
      tkEnumeration: // supoe que é true e false
        Prop.SetValue(Self, StrToBool(propValueAsString));
      else
        raise ENotImplemented.Create('Ainda não foi implementada conversão de ' +
          GetEnumName(TypeInfo(TTypeKind),Ord(Prop.PropertyType.TypeKind)));
    end;
  end else
  begin
    Prop.SetValue(Self,propValue);
  end;
end;

function HelperTOBJ.setterNameOf(APropName: String): String;
var
  RttiType: TRttiType;
  RttiProperty: TRttiProperty;
  InstanceProp: TRttiInstanceProperty;
  lPropInfo: PPropInfo;
  RttiMethod: TRttiMethod;
  Setter: Pointer;
begin
  Ctx := TRttiContext.Create;
  try
    RttiType := Ctx.GetType(Self.ClassType);

    if not Assigned(RttiType) then
      raise Exception.Create('Nao foi possivel conseguir achar o tipo no contexto');

    RttiProperty := RttiType.GetProperty(APropName);

    if not Assigned(RttiProperty) then
      raise EArgumentException.Create('Property ' + APropName + '  não encontrado');

    if not RttiProperty.IsWritable then
      raise Exception.Create('Property ' + APropName + ' não é writable');

    InstanceProp := TRttiInstanceProperty(RttiProperty);
    lPropInfo := InstanceProp.PropInfo;
    Setter := lPropInfo^.SetProc;

    if Setter = nil then
      raise Exception.Create('Property ' + APropName + ' Não possui setter visivel');

    for RttiMethod in RttiType.GetDeclaredMethods do
    begin
      if RttiMethod.CodeAddress = Self.getPointerOfMethod(Setter) then
        Exit(RttiMethod.Name);
    end;

    raise Exception.Create('Método não foi encontrado');

  finally
    Ctx.Free;
  end;
end;

end.
