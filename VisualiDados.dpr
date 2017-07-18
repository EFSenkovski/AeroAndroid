program VisualiDados;

uses
  System.StartUpCopy,
  FMX.Forms,
  frmMain in 'frmMain.pas' {F_Main},
  frmLogin in 'frmLogin.pas' {F_Login},
  uSessaoAndroid in 'uSessaoAndroid.pas',
  dmMainAndroid in 'dmMainAndroid.pas' {DM_Main: TDataModule},
  uAndroidUdf in 'uAndroidUdf.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TF_Login, F_Login);
  Application.CreateForm(TF_Main, F_Main);
  Application.CreateForm(TDM_Main, DM_Main);
  Application.Run;
end.
