unit dmMainAndroid;

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP;

type
  TDM_Main = class(TDataModule)
    IdHTTP: TIdHTTP;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM_Main: TDM_Main;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
