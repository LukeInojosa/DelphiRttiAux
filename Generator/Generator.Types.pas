unit Generator.Types;

interface
type
  TGeneratorTypes = class
  public
    /// <summary> Cria um novo tipo </summary>
    constructor Create(ATypeName: String);

    /// <summary> Adiciona uma nova propriedade ao tipo </summary>
    procedure AddProperty(APropertyName: String);
  end;

implementation

{ TGeneratorTypes }

procedure TGeneratorTypes.AddProperty(APropertyName: String);
begin

end;

constructor TGeneratorTypes.Create(ATypeName: String);
begin
  // primeira letra do type deve ser T
end;

end.
