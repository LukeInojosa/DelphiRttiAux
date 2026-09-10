unit Interfaces.Default;

interface uses
  Interfaces.Generic,
  Types.Generic;

type
  ICodigo = interface(IGeneric)
    {Codigo}
    function getCodigo: Integer;
    procedure setCodigo(ACodigo: Integer);

    property codigo: Integer read getCodigo write setCodigo;
  end;

  IIntervalo = interface(IGeneric)
    {Intervalo}
    function getDataInicial: TDateTime;
    procedure setDataInicial(ADataInicial: TDateTime);

    function getDataFinal: TDateTime;
    procedure setDataFinal(ADataFinal: TDateTime);

    property dataInicial: TDateTime read getDataInicial write setDataInicial;
    property dataFinal: TDateTime read getDataFinal write setDataFinal;
  end;

  IDescricao = interface(IGeneric)
    {Descricao}
    function getDescricao: String;
    procedure setDescricao(ADescricao: String);

    property descricao: String read getDescricao write setDescricao;
  end;

  TCodigo = class(TGeneric, ICodigo)
  strict private
    FCodigo: Integer;
  public
    function getCodigo: Integer; virtual;
    procedure setCodigo(ACodigo: Integer); virtual;

    property codigo: Integer read getCodigo write setCodigo;

    constructor Create;
  end;

  TIntervalo = class(TGeneric, IIntervalo)
  strict private
    FDataInicial: TDateTime;
    FDataFinal: TDateTime;
  public
    function getDataInicial: TDateTime; virtual;
    procedure setDataInicial(ADataInicial: TDateTime); virtual;

    function getDataFinal: TDateTime; virtual;
    procedure setDataFinal(ADataFinal: TDateTime); virtual;

    property dataInicial: TDateTime read getDataInicial write setDataInicial;
    property dataFinal: TDateTime read getDataFinal write setDataFinal;

    constructor Create;
  end;

  TDescricao = class(TGeneric, IDescricao)
  strict private
    FDescricao: String;
  public
    function getDescricao: String; virtual;
    procedure setDescricao(ADescricao: String); virtual;

    property descricao: String read getDescricao write setDescricao;

    constructor Create;
  end;

implementation

{ TDescricao }

constructor TDescricao.Create;
begin
inherited;
end;

function TDescricao.getDescricao: String;
begin

end;

procedure TDescricao.setDescricao(ADescricao: String);
begin

end;

{ TIntervalo }

constructor TIntervalo.Create;
begin
inherited;
end;

function TIntervalo.getDataFinal: TDateTime;
begin

end;

function TIntervalo.getDataInicial: TDateTime;
begin

end;

procedure TIntervalo.setDataFinal(ADataFinal: TDateTime);
begin

end;

procedure TIntervalo.setDataInicial(ADataInicial: TDateTime);
begin

end;

{ TCodigo }

constructor TCodigo.Create;
begin
inherited;
end;

function TCodigo.getCodigo: Integer;
begin

end;

procedure TCodigo.setCodigo(ACodigo: Integer);
begin

end;


end.
