unit frmLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.MultiView, FMX.Edit,
  FMX.Styles.Objects, FMX.TabControl,
{$IFDEF ANDROID}
  Androidapi.JNI.GraphicsContentViewText, Androidapi.Helpers,
  Androidapi.JNI.Telephony, Androidapi.JNI.Provider, Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes, Androidapi.JNI.Os, Androidapi.JNI.App,
{$ENDIF}
{$IFDEF IOS}
  iOSApi.UIKit,
  iOSApi.Foundation,
  Macapi.Helpers,
{$ENDIF}
  FMX.ExtCtrls;

type
  TF_Login = class(TForm)
    Layout1: TLayout;
    Panel1: TPanel;
    Label1: TLabel;
    StyleBook1: TStyleBook;
    Layout2: TLayout;
    EditUsuario: TEdit;
    EditSenha: TEdit;
    Button1: TButton;
    ToolBar1: TToolBar;
    Label2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    function CapturarImei(): String;
  public
    { Public declarations }
  end;

var
  F_Login: TF_Login;

implementation

{$R *.fmx}


uses frmMain, dmMainAndroid, uFuncoes, uAndroidUdf; // ,//uSessaoAndroid, ;

procedure TF_Login.Button1Click(Sender: TObject);
var
  sUsuario, sSenha, sIMEI: String;
  OFuncoes               : TFuncoes;
  dDta                   : TDateTime;
begin
  try
    if ((EditUsuario.Text = EmptyStr) or (EditSenha.Text = EmptyStr)) then
      Exit;
    sUsuario := EditUsuario.Text;
    sSenha   := EditSenha.Text;
    dDta     := Now;
    sIMEI    := CapturarImei;
    oFuncoes := TFuncoes.Create;
    oFuncoes.dictSql.Add('REQ_USU', sUsuario);
    oFuncoes.dictSql.Add('REQ_SEN', sSenha);
    oFuncoes.dictSql.Add('REQ_IMEIORIGEM',sIMEI);
    oFuncoes.dictSql.Add('REQ_DTA',DateToString(dDta));
    oFuncoes.InsertSql('REQUISICAOLOGIN');
  finally
    oFuncoes.Free;
  end;
end;

function TF_Login.CapturarImei: String;
var
  IMEI: String;
{$IFDEF ANDROID}
  obj: JObject;
  tm : JTelephonyManager;
{$ENDIF}
{$IFDEF IOS}
var
  device: UIDevice;
{$ENDIF}
begin
{$IFDEF ANDROID}
  IMEI := '';
  obj  := TAndroidHelper.Activity.getSystemService(TJContext.JavaClass.TELEPHONY_SERVICE);
  if obj <> nil then
  begin
    tm := TJTelephonyManager.Wrap((obj as ILocalObject).GetObjectID);
    if tm <> nil then
      IMEI := JStringToString(tm.getDeviceId);
  end;
  if IMEI = '' then
    IMEI := JStringToString(TJSettings_Secure.JavaClass.getString(TAndroidHelper.Activity.getContentResolver, TJSettings_Secure.JavaClass.ANDROID_ID));
{$ENDIF}

{$IFDEF IOS}
  IMEI   := '';
  device := TUIDevice.Wrap(TUIDevice.OCClass.currentDevice);
  IMEI   := device.uniqueIdentifier.UTF8String;
{$ENDIF}
  result := IMEI;

end;

procedure TF_Login.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  F_Login.Free;
end;

procedure TF_Login.FormCreate(Sender: TObject);
begin
  Self.Width  := Screen.Width;
  Self.Height := Screen.Height;

end;

end.
