unit frmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.MultiView, FMX.Layouts, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, FMX.TabControl;

type
  TF_Main = class(TForm)
    Layout1: TLayout;
    MultiViewPainel: TMultiView;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    ToolBar2: TToolBar;
    SpeedButton2: TSpeedButton;
    Label2: TLabel;
    StyleBook1: TStyleBook;
    MultiViewForm: TMultiView;
    LayoutForm: TLayout;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Layout1Resize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Main: TF_Main;

implementation

{$R *.fmx}

uses frmLogin;

procedure TF_Main.FormCreate(Sender: TObject);
begin
  Self.Width := Screen.Width;
  Self.Height := Screen.Height;
end;

procedure TF_Main.FormShow(Sender: TObject);
begin
  if Assigned(F_Login) then
    F_Login := NIL;
end;

procedure TF_Main.Layout1Resize(Sender: TObject);
begin
  MultiViewPainel.Width := Trunc(Layout1.Width / 1.1);
  MultiViewForm.Width := Layout1.Width;
end;

procedure TF_Main.SpeedButton1Click(Sender: TObject);
begin
  MultiViewPainel.ShowMaster;
end;

procedure TF_Main.SpeedButton2Click(Sender: TObject);
begin
  MultiViewPainel.HideMaster;
end;

end.
