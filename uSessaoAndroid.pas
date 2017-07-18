unit uSessaoAndroid;

interface

type
  TSessao = class
    private
      FUsuario: String;
      FSenha: String;
      FImei: String;
      FToken: String;
      FDataHora: TDateTime;
      FValida: Boolean;
    procedure SetDataHora(const Value: TDateTime);
    procedure SetImei(const Value: String);
    procedure SetSenha(const Value: String);
    procedure SetToken(const Value: String);
    procedure SetUsuario(const Value: String);
    procedure SetValida(const Value: Boolean);
    published
      property Usuario: String read FUsuario write SetUsuario;
      property Senha: String read FSenha write SetSenha;
      property Imei: String read FImei write SetImei;
      property Token: String read FToken write SetToken;
      property DataHora: TDateTime read FDataHora write SetDataHora;
      property Valida: Boolean read FValida write SetValida;
    public
      Constructor Create;
      Destructor Destroy; override;
  end;

implementation

{ TSessao }

constructor TSessao.Create;
begin

end;

destructor TSessao.Destroy;
begin

  inherited;
end;

procedure TSessao.SetDataHora(const Value: TDateTime);
begin
  FDataHora := Value;
end;

procedure TSessao.SetImei(const Value: String);
begin
  FImei := Value;
end;

procedure TSessao.SetSenha(const Value: String);
begin
  FSenha := Value;
end;

procedure TSessao.SetToken(const Value: String);
begin
  FToken := Value;
end;

procedure TSessao.SetUsuario(const Value: String);
begin
  FUsuario := Value;
end;

procedure TSessao.SetValida(const Value: Boolean);
begin
  FValida := Value;
end;

end.
