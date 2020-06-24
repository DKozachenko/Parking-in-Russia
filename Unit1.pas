unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Imaging.jpeg;

type
  TmenuForm = class(TForm)
    bgMenuForm: TImage;
    StartBtn: TBitBtn;
    StoryBtn: TBitBtn;
    ExitBtn: TBitBtn;
    title: TLabel;
    SandBoxBtn: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExitBtnClick(Sender: TObject);
    procedure StoryBtnClick(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure SandBoxBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  menuForm: TmenuForm;

implementation

{$R *.dfm}

Uses Unit2, Unit3, Unit4, Unit5, Unit6, Unit7;

procedure TmenuForm.ExitBtnClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TmenuForm.SandBoxBtnClick(Sender: TObject);
begin
  menuForm.Hide;
  sandBoxForm.Show;
end;

procedure TmenuForm.StartBtnClick(Sender: TObject);
begin
  menuForm.Hide;
  gameForm.Show();
  sandBoxBtn.Enabled := true;
end;
procedure TmenuForm.StoryBtnClick(Sender: TObject);
begin
  menuForm.Hide;
  StoryForm.Show();
end;

procedure TmenuForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

end.
