program ServerAndroid;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.SysUtils,
  IniFiles,
  uParametros in 'uParametros.pas',
  uSocketAERO in 'uSocketAERO.pas';

var
  oSocket    : TSocketAERO;
  oParametros: TParametros;
  sDigitado, sBanco, sUsuario, sSenha,
    sIP, sConexao: string;
  oIni           : TIniFile;
  lExecutar      : Boolean;

begin
  try

    oIni := TIniFile.Create(GetCurrentDir + '\ServerSocket.ini');
    if (oIni.ReadString('BancoLog', 'Base', '') <> '') then
      oParametros := TParametros.Create;
{$REGION 'BANCO LOG'}
    sDigitado := oIni.ReadString('BancoLog', 'Base', '');
    if (sDigitado = '') then begin
      Writeln('Qual o endereço do banco que vou me conectar para salvar o log?');
      while sBanco = '' do begin
        Readln(sBanco); // '197.87.77.250:/aero32db/romanha/ctba/aerosml.gdb';
      end;
      oIni.WriteString('BancoLog', 'Base', sBanco);
    end;

    sDigitado := oIni.ReadString('BancoLog', 'User', '');
    if (sDigitado = '') then begin
      Writeln('Qual o usuário de conexão ao banco para salvar o log?');
      while sUsuario = '' do begin
        Readln(sUsuario); // 'SYSDBA';
      end;
      oIni.WriteString('BancoLog', 'User', sUsuario);
    end;

    sDigitado := oIni.ReadString('BancoLog', 'Pass', '');
    if (sDigitado = '') then begin
      Writeln('Qual a senha de conexão ao banco para salvar o log?');

      while sSenha = '' do begin
        Readln(sSenha); // '13031526';
      end;
      oIni.WriteString('BancoLog', 'Pass', sSenha);
    end;

    if (oIni.ReadString('BancoLog', 'Base', '') <> '') then
      oParametros := TParametros.Create
    else begin
      Writeln('Favor configurar o banco de log!');
      Halt(0);
    end;
{$ENDREGION}
    sDigitado := oIni.ReadString('Banco', 'Base', '');
    if (sDigitado = '') then begin
      Writeln('Qual o endereço do banco que vou me conectar?');
      while sDigitado = '' do begin
        Readln(sDigitado); // '197.87.77.250:/aero32db/romanha/ctba/aerosml.gdb';
      end;
      sBanco := sDigitado;
      oIni.WriteString('Banco', 'Base', sBanco);
    end;

    sDigitado := oIni.ReadString('Banco', 'User', '');
    if (sDigitado = '') then begin
      Writeln('Qual o usuário de conexão ao banco?');
      while sDigitado = '' do begin
        Readln(sDigitado); // 'SYSDBA';
      end;
      sUsuario := sDigitado;
      oIni.WriteString('Banco', 'User', sUsuario);
    end;

    sDigitado := oIni.ReadString('Banco', 'Pass', '');
    if (sDigitado = '') then begin
      Writeln('Qual a senha de conexão ao banco?');

      while sDigitado = '' do begin
        Readln(sDigitado); // '13031526';
      end;
      sSenha := sDigitado;
      oIni.WriteString('Banco', 'Pass', sSenha);
    end;

    oSocket := TSocketAERO.Create(oParametros);

    oParametros.ExecutaReplicacao := false;

    if (oParametros.Replicacao = '1') then begin

      oParametros.ExecutaReplicacao := true;

      // oThreadRepli := ThreadReplicacao.Create(oParametros);
      // oThreadRepli.Execute;
    end;

    sDigitado := '';
    lExecutar := true;

    while lExecutar do begin
      Readln(sDigitado);

      if (sDigitado.ToUpper = 'SAIR') then begin
        lExecutar := false;
      end else if (sDigitado.Contains('desligar monitor')) then begin
        // desliga monitor
        // SendMessage(ConsoleHandle, WM_SYSCOMMAND, SC_MONITORPOWER, 1);

      end else if (sDigitado.Contains('Conexoes')) then begin
        // oSocket.oSocket.

      end;

      sDigitado := '';
    end;

    oSocket.Terminate;
    oSocket.Free;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
