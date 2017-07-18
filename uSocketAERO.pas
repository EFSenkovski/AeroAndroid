unit uSocketAERO;

interface

uses
  System.SysUtils,
  IdHTTPServer, FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  Generics.Collections,
  IniFiles,
  IdContext,
  IdComponent,
  IdCustomTCPServer,
  IdCustomHTTPServer,
  System.Classes,
  uParametros,
  FireDAC.Stan.StorageJSON;

type
  TSocketAERO = class
    oSocket: TIdHTTPServer;
    oCon: TFDConnection;
    oSql: TDictionary<string, string>;
    oIni: TIniFile;
    sEndereco: string;
    sEnderecoAERO: string;
    _oParametros: TParametros;
  private
    procedure IdHTTPServer1Connect(AContext: TIdContext);
    procedure SalvaLog(sTabela: string; sChave: string; sUsu: string; sAcao: string);

  protected

  public
    constructor Create(const oParametros: TParametros);

    procedure IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure Terminate;
  end;

implementation


{ TSocketAERO }
constructor TSocketAERO.Create(const oParametros: TParametros);
var
  sEstacao: string;
begin
  oIni                 := TIniFile.Create(GetCurrentDir + '\ServerSocket.ini');
  oSocket              := TIdHTTPServer.Create(nil);
  oSocket.KeepAlive    := false;
  oSocket.DefaultPort  := 2424;
  oSocket.Active       := true;
  oSocket.OnCommandGet := IdHTTPServer1CommandGet;
  oSocket.OnConnect    := IdHTTPServer1Connect;

  oCon := TFDConnection.Create(nil);

  oCon.Params.Database := oIni.ReadString('Banco', 'Base', '');
  // '197.87.77.250:/aero32db/romanha/ctba/aerosml.gdb';
  oCon.Params.UserName := oIni.ReadString('Banco', 'User', '');
  // 'SYSDBA';
  oCon.Params.Password := oIni.ReadString('Banco', 'Pass', '');
  // '13031526';
  oCon.Params.DriverID := oIni.ReadString('Banco', 'Driver', 'FB');
  // FB
  oCon.Open();

  // Crio o endereço
  // sEnderecoAERO := oIni.ReadString('Estacao', 'IP', '');
  // sEnderecoAERO := sEndereco + '/?user=' + oIni.ReadString('Banco', 'User', '').ToUpper;
  // sEnderecoAERO := sEndereco + '&senha=' + oIni.ReadString('Banco', 'Pass', '');

  oIni.Free;

  oSql := TDictionary<string, string>.Create();
  oSql.Add('sql', 'Parametros sqlhtml: Tipo STRING. Exemplo:/?user=user&senha=senha&sql=comandosql');

  _oParametros := oParametros;

end;

procedure TSocketAERO.IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  sComando     : string;
  sRetorno     : string;
  oStream      : TStringStream;
  oQuery       : TFDQuery;
  iIndexRowList: Integer;
  iIndexInicio : Integer;
  iIndexFinal  : Integer;
  sJSON        : string;
  iIndexRowID  : Integer;
  i            : Integer;
  oPair        : TPair<string, string>;
  sUser        : string;
  sPass        : string;
  lLogado      : Boolean;
  sContent     : string;
begin
  if (ARequestInfo.Params.Count > 0) then begin
    oQuery := TFDQuery.Create(nil);

    oQuery.Connection := oCon;
    // 1-Servidor cliente
    // 2-Servidor AERO
    // 3-Estação Cliente
    // 4-Estação AERO

    try
      oStream := TStringStream.Create;
      oQuery.Close;

      sUser   := ARequestInfo.Params[0].Replace('user=', '').Replace('"', '''');
      sPass   := ARequestInfo.Params[1].Replace('senha=', '').Replace('"', '''');
      lLogado := false;

      oQuery.SQL.Text := 'SELECT * FROM USUARIOS WHERE NOME = :NOME AND SENHA = :SENHA';

      oQuery.ParamByName('NOME').AsString  := sUser;
      oQuery.ParamByName('SENHA').AsString := sPass;
      oQuery.Open();
      lLogado := not oQuery.Eof;

      if (lLogado) then begin
        sContent := 'application/json';
        sComando := ARequestInfo.Params[2].Replace('sql=', '').Replace('"', '''');

        if (sComando = 'help') then begin

          sRetorno := 'Tipo de consultas' + #13;
          for oPair in oSql do begin
            sRetorno := sRetorno + 'sql=' + oPair.Key + ' - ' + oPair.Value + #13;
          end;

        end else begin

          oQuery.SQL.Text := sComando;

          if (sComando.Substring(0, 6).ToUpper = 'SELECT') then
            oQuery.Open
          else
            oQuery.ExecSQL;

          oQuery.SaveToStream(oStream, sfJSON);

          sRetorno := oStream.DataString;

        end;

      end else begin

        sRetorno := 'Usuário não encontrado!!!!';

      end;
    except
      on E: Exception do begin
        sRetorno := E.Message;
      end;
    end;

    oStream.Free;

    AResponseInfo.ContentText := sRetorno;
    AResponseInfo.ContentType := sContent;
    AResponseInfo.CharSet     := 'UTF-8';

    oQuery.Free;
  end;
end;

procedure TSocketAERO.IdHTTPServer1Connect(AContext: TIdContext);
begin

  Writeln('Conectado com o IP ' + AContext.Binding.PeerIP + ', Hora: ' + DateTimeToStr(Now) + #13);
  SalvaLog('ClienteConectado', AContext.Binding.PeerIP, 'SERVERSOCKET', 'Conectado com o IP ' + AContext.Binding.PeerIP + ', Hora: ' + DateTimeToStr(Now) + #13);

end;

procedure TSocketAERO.SalvaLog(sTabela: string; sChave: string; sUsu: string; sAcao: string);
var
  oQryExec: TFDQuery;
  sSql    : string;
begin
  // try
  // oQryExec := TFDQuery.Create(nil);
  //
  // oQryExec.Connection := oCon;
  //
  // sSql := 'INSERT INTO LOGPROVEDOR(LOG_TAB, LOG_TABCOD, LOG_DTA, LOG_HOR, LOG_USU, LOG_ACAO, LOG_IP)' +
  // ' VALUES(' + QuotedStr(sTabela) + ','
  // + QuotedStr(sChave) + ',' +
  // 'cast(''now'' as timestamp), ' +
  // 'cast(''now'' as timestamp), ' +
  // QuotedStr(sUsu) + ', ' +
  // QuotedStr(sAcao) + ', ' +
  // QuotedStr(_oParametros.IP) + ')';
  //
  // oQryExec.SQL.Text := sSql;
  // oQryExec.ExecSQL;
  //
  // finally
  // oQryExec.Free;
  // end;

end;

procedure TSocketAERO.Terminate;
begin
  oSocket.Active := false;
end;

end.
