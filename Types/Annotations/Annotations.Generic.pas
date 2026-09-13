unit Annotations.Generic;

interface

type
  Getter = class(TCustomAttribute)
  public
    FFieldName: String;
    constructor Create(AFieldName: String);
  end;

  Setter = class(TCustomAttribute)
  public
    FFieldName: String;
    constructor Create(AFieldName: String);
  end;

implementation

{ GetterTo }

constructor Getter.Create(AFieldName: String);
begin
  Self.FFieldName := AFieldName;
end;

{ SetterTo }

constructor Setter.Create(AFieldName: String);
begin
  Self.FFieldName := AFieldName;
end;

end.
