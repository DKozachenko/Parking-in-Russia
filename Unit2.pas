unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TStoryForm = class(TForm)
    bgStoryForm: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure nextStory(Sender: TObject);
    procedure backToMenu(Sender: TObject);
  end;

var
  StoryForm: TStoryForm;
  nextButton, backButton: TButton;

implementation

{$R *.dfm}

Uses Unit1, Unit3, Unit4, Unit5;

procedure TStoryForm.FormCreate(Sender: TObject);
begin
  bgStoryForm.Picture.LoadFromFile('..\..\images\story1.bmp');
  nextButton := TButton.Create(StoryForm);
  nextButton.Parent := StoryForm;
  nextButton.Width := 100;
  nextButton.Height := 40;
  nextButton.Caption := 'Next';
  nextButton.Font.Size := 20;
  nextButton.Left := 20;
  nextButton.Top := 20;
  nextButton.onClick := nextStory;
end;

procedure TStoryForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TStoryForm.nextStory(Sender: TObject);
begin
  bgStoryForm.Picture.LoadFromFile('..\..\images\story2.bmp');
  nextButton.Destroy;
  backButton := TButton.Create(StoryForm);
  backButton.Parent := StoryForm;
  backButton.Width := 100;
  backButton.Height := 40;
  backButton.Caption := 'Back';
  backButton.Font.Size := 20;
  backButton.Left := 20;
  backButton.Top := 20;
  nextButton.onClick := backToMenu;
end;

procedure TStoryForm.backToMenu(Sender: TObject);
begin
  storyForm.Close;
  backButton.Destroy;
  bgStoryForm.Picture.LoadFromFile('..\..\images\story1.bmp');
  nextButton := TButton.Create(StoryForm);
  nextButton.Parent := StoryForm;
  nextButton.Width := 100;
  nextButton.Height := 40;
  nextButton.Caption := 'Next';
  nextButton.Font.Size := 20;
  nextButton.Left := 20;
  nextButton.Top := 20;
  nextButton.onClick := nextStory;
  menuForm.Show;
end;



end.
