unit uParametros;

interface

uses
  FireDAC.Comp.Client,
  IniFiles,
  System.SysUtils,
  IdIPWatch;

type
  TParametros = Class
  private
    sEstacao          : string;
    sWMS              : String;
    sReplicacao       : string;
    sLocalArquivo     : string;
    iLastIndex        : integer;
    lExecutaReplicacao: boolean;
    lCriarTrigger     : boolean;
    sIP               : string;
    oConexaoLog       : TFDConnection;

    function GetIPAddress(): String;

  public
    property Estacao          : String read sEstacao Write sEstacao;
    property WMS              : String read sWMS Write sWMS;
    property Replicacao       : String read sReplicacao Write sReplicacao;
    property LocalArquivo     : String read sLocalArquivo Write sLocalArquivo;
    property LastIndex        : integer read iLastIndex Write iLastIndex;
    property ExecutaReplicacao: boolean read lExecutaReplicacao Write lExecutaReplicacao;
    property CriarTrigger     : boolean read lCriarTrigger Write lCriarTrigger;
    property ConexaoLog       : TFDConnection read oConexaoLog Write oConexaoLog;
    property IP               : string read sIP;

    constructor Create;
  end;

implementation

{ TParametros }

constructor TParametros.Create;
var
  oIni  : TIniFile;
  sValor: String;
begin
  oIni        := TIniFile.Create(GetCurrentDir + '\ServerSocket.ini');
  oConexaoLog := TFDConnection.Create(nil);

  oConexaoLog.Params.Database := oIni.ReadString('BancoLog', 'Base', '');
  // '197.87.77.250:/aero32db/romanha/ctba/aerosml.gdb';
  oConexaoLog.Params.UserName := oIni.ReadString('BancoLog', 'User', '');
  // 'SYSDBA';
  oConexaoLog.Params.Password := oIni.ReadString('BancoLog', 'Pass', '');
  // '13031526';
  oConexaoLog.Params.DriverID := oIni.ReadString('BancoLog', 'Driver', 'FB');

  try
    oConexaoLog.Open();
  except
    on E: Exception do begin
      Writeln('Erro: ' + E.Message);
      Readln(sValor); // '197.87.77.250:/aero32db/romanha/ctba/aerosml.gdb';
    end;
  end;

  oIni.free;

  sIP := GetIPAddress;
end;

function TParametros.GetIPAddress(): String;
var
  IPW: TIdIPWatch;
begin
  result := '127.0.0.1';
  IPW    := TIdIPWatch.Create(nil);
  try
    if IPW.LocalIP <> '' then
      result := IPW.LocalIP;
  finally
    IPW.free;
  end;
end;

end.
