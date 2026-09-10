unit Interfaces.User;
interface uses
  Interfaces.Generic,
  Types.Generic, System.Generics.Collections,
  System.Sysutils;

type
  IUser = interface(IGeneric)
    ['{F28630E9-ED85-4D1D-9329-15EA702347E7}']
    // getters e Setters devem ter formato
    //  - get[Nome da Property]
    //  - set[Nome da Property]
    // caso contrário, não será possível setar
    // automaticamente os valores e será necessários
    // implementar os getters e setters no TClassName
    procedure SetNome(ANome:string);
    function GetNome: String;

    procedure SetSenha(ASenha: String);
    function GetSenha: String;

    procedure SetNascimento(ANascimento: TDateTime);
    function GetNascimento: TDateTime;

    procedure SetSalario(ASalario: Double);
    function GetSalario: Double;

    procedure SetCasado(ACasado: Boolean);
    function getCasado: Boolean;


    // properties devem ser dos tipos basicos do delphi
    // getters e setters automáticos não funcionam para
    // tipos complexos.
    property nome: String read GetNome write SetNome;
    property senha: String read GetSenha write SetSenha;
    property nascimento: TDateTime read GetNascimento write SetNascimento;
    property salario: Double read GetSalario write SetSalario;
    property casado: Boolean read GetCasado write SetCasado;
  end;

   // TClassName deve herdard de IClassName e de TGeneric
   TUser = class(TGeneric, IUser)
    // nome dos atributos deve ser F[AtributeName] para
    // que a atribuição automática funcione
    strict private
      FNome: String;
      FSenha: String;
      FNascimento: TDateTime;
      FSalario: Double;
      FCasado: Boolean;
    public
      // getters e settes devem ser publcos em TClasse
      // e todos devem ser virtual. Caso queria implementar
      // seu próprio getter ou setter, não marque ele como
      // virtual. Dessa forma, ele não será sobrescrito
      // pelo constructor do TGeneric
      procedure SetNome(Nome:string); virtual;
      function GetNome: String; virtual;

      procedure SetSenha(Senha: String); virtual;
      function GetSenha: String; virtual;

      procedure SetNascimento(Nascimento: TDateTime); virtual;
      function GetNascimento: TDateTime; virtual;

      procedure SetSalario(Salario: Double); virtual;
      function GetSalario: Double; virtual;

      procedure SetCasado(ACasado: Boolean); virtual;
      function getCasado: Boolean; virtual;

      property nome: String read GetNome write SetNome;
      property senha: String read GetSenha write SetSenha;
      property nascimento: TDateTime read GetNascimento write SetNascimento;
      property salario: Double read GetSalario write SetSalario;
      property casado: Boolean read GetCasado write SetCasado;

      // Construtor deve existir
      constructor Create;
      destructor Destroy;
  end;

implementation
{ TUser }

// Construtor deve chamar inherited
// para que os getters e settes sejam
// construidos automaticamente
constructor TUser.Create;
begin
  inherited;
end;


// Não é necessário nenhuma implementação
// dos getters e setters virtuals. Caso haja uma
// implementação, ela será ignorada a menos que
// a função ou procedimento não seja virtual
destructor TUser.Destroy;
begin
  Writeln('Destructor Chamado para Usuario');
  inherited;
end;

function TUser.getCasado: Boolean;
begin

end;

function TUser.GetNascimento: TDateTime;
begin

end;

function TUser.GetNome: String;
begin

end;

function TUser.GetSalario: Double;
begin

end;

function TUser.GetSenha: String;
begin

end;

procedure TUser.SetCasado(ACasado: Boolean);
begin

end;

procedure TUser.SetNascimento(Nascimento: TDateTime);
begin

end;

procedure TUser.SetNome(Nome: string);
begin

end;

procedure TUser.SetSalario(Salario: Double);
begin

end;

procedure TUser.SetSenha(Senha: String);
begin

end;

end.
