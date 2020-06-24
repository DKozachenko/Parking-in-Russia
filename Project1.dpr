program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {menuForm},
  Unit2 in 'Unit2.pas' {StoryForm},
  Unit3 in 'Unit3.pas' {gameForm},
  Unit4 in 'Unit4.pas' {gameForm2},
  Unit5 in 'Unit5.pas' {gameForm3},
  Unit6 in 'Unit6.pas' {StoryForm2},
  Unit7 in 'Unit7.pas' {sandBoxForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmenuForm, menuForm);
  Application.CreateForm(TStoryForm, StoryForm);
  Application.CreateForm(TgameForm, gameForm);
  Application.CreateForm(TgameForm2, gameForm2);
  Application.CreateForm(TgameForm3, gameForm3);
  Application.CreateForm(TStoryForm2, StoryForm2);
  Application.CreateForm(TsandBoxForm, sandBoxForm);
  Application.Run;
end.
