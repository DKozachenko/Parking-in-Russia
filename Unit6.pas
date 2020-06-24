unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TStoryForm2 = class(TForm)
    bgStoryForm2: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure backToMenu(Sender: TObject);
  end;

var
  StoryForm2: TStoryForm2;
  backButton: TButton;

implementation

{$R *.dfm}
Uses Unit1, Unit3, Unit4, Unit5;

procedure TStoryForm2.FormCreate(Sender: TObject);
begin
  bgStoryForm2.Picture.LoadFromFile('..\..\images\story3.bmp');
  backButton := TButton.Create(StoryForm2);
  backButton.Parent := StoryForm2;
  backButton.Width := 200;
  backButton.Height := 40;
  backButton.Caption := 'Back to Menu';
  backButton.Font.Size := 20;
  backButton.Left := 175;
  backButton.Top := 10;
  backButton.onClick := backToMenu;
end;

procedure TStoryForm2.backToMenu(Sender: TObject);
begin
  storyForm2.Close;
  menuForm.Show();
end;

end.
