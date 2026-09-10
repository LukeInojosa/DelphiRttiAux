unit Types.User;

interface uses
  Interfaces.User,
  Types.Generic, System.Generics.Collections;

type
  RUser = record
  strict private
    Data: IUser; // contagem de referencia

    procedure SetNome(ANome:string);
    function GetNome: String;

    procedure SetSenha(ASenha: String);
    function GetSenha: String;

    procedure SetNascimento(ANascimento: TDateTime);
    function GetNascimento: TDateTime;

    procedure SetSalario(ASalario: Double);
    function GetSalario: Double;

    function getIsFilled: TDictionary<String,Boolean>;
  public
    property nome: String read GetNome write SetNome;
    property senha: String read GetSenha write SetSenha;
    property nascimento: TDateTime read GetNascimento write SetNascimento;
    property salario: Double read GetSalario write SetSalario;
    property isFilled: TDictionary<String,Boolean> read getIsFilled;

    function ToString: String;
    class operator Implicit(User: TUser): RUser;
    class operator Implicit(Values: TArray<String>): RUser;
    class operator Explicit(jsonString:String): RUser;

    const
       FIELDS_ORDER = 'nome,senha,nascimento,salario';
  end;

implementation

uses
  System.SysUtils,
  System.JSON;

{ RUser }

class operator RUser.Implicit(User: TUser): RUser;
begin
  Result.Data := User;
  Result.Data._Release;
end;

function RUser.getIsFilled: TDictionary<String, Boolean>;
begin
  Result := Self.Data.isFilled;
end;

function RUser.GetNascimento: TDateTime;
begin
  Result := Self.Data.nascimento;
end;

function RUser.GetNome: String;
begin
  Result := Self.Data.nome;
end;

function RUser.GetSalario: Double;
begin
  Result := Self.Data.salario;
end;

function RUser.GetSenha: String;
begin
  Result := Self.Data.senha;
end;

class operator RUser.Implicit(Values: TArray<String>): RUser;
begin
  Result.Data := TUser.Create;
  Result.Data.SetValues(Result.FIELDS_ORDER, Values);
  Result.Data._Release;
end;

procedure RUser.SetNascimento(ANascimento: TDateTime);
begin
  Self.Data.nascimento := ANascimento;
end;

procedure RUser.SetNome(ANome: string);
begin
  Self.Data.Nome := ANome;
end;

procedure RUser.SetSalario(ASalario: Double);
begin
  Self.Data.salario := ASalario;
end;

procedure RUser.SetSenha(ASenha: String);
begin
  Self.Data.senha := ASenha;
end;

class operator RUser.Explicit(jsonString: String): RUser;
begin
  Result.Data := TUser.Create;
  Result.Data.SetValues(jsonString);
  Result.Data._Release;
end;

function RUser.ToString: String;
begin
  if not Assigned(Self.Data) then
    Exit('{}');
  Result := Self.Data.ToString;
end;

end.
