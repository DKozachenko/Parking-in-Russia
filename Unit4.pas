unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TgameForm2 = class(TForm)
    bgGameForm2: TImage;
    timeLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure initialValues;
    procedure Сountdown(Sender: TObject);
    procedure MD(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MU(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    function win:boolean;
    function star1:boolean;
    function star2:boolean;
    function star3:boolean;
    procedure disableAll;
    procedure disableTaxi;
    procedure exitClick(Sender: TObject);
  end;

const n = 9;
m = 6;
l = 1;
z = 2;
exitI = 6;
exitJ = 9;
star1I = 3;
star1J = 1;
star2I = 2;
star2J = 5;
star3I = 1;
star3J = 8;
dir = '..\..\images\secondLevel\';

var
  gameForm2: TgameForm2;
  masOfImages: array[1..m, 1..n] of Timage;
  masOfExitImages: array[1..l, 1..z] of TImage;
  masOfZifr:  array[1..m, 1..n] of integer;
  exitButton: TButton;
  curI, curJ, exitCounter: integer;
  horizontal, vertical, ZCH, PCH, SCH: boolean;
  timeStart, timeEnd: TDateTime;
  timer: TTimer;

implementation

{$R *.dfm}

Uses Unit1, Unit2, Unit3, Unit5;

procedure TgameForm2.initialValues;
begin
  exitCounter := 0;

  horizontal := false;
  vertical := false;

  ZCH := false;
  PCH := false;
  SCH := false;
end;

//осноные действия при создании формы
procedure TgameForm2.FormCreate(Sender: TObject);
var i, j: integer;
begin
  bgGameForm2.Picture.LoadFromFile(dir + 'secondLevel.bmp');
  for i := 1 to m do
  begin
    for j := 1 to n do
    begin
      masOfImages[i,j] := TImage.Create(gameForm2);
      masOfImages[i,j].Parent := gameForm2;
      masOfImages[i,j].Width := 40;
      masOfImages[i,j].Height := 40;
      masOfImages[i,j].Stretch := true;
      masOfImages[i,j].Top := 164 + i * 40;
      masOfImages[i,j].Left := 80 + j * 40;
      masOfImages[i,j].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[i,j].OnMouseDown := MD;
      masOfImages[i,j].OnMouseUp := MU;
      masOfImages[i,j].Tag := 0;

      masOfZifr[i,j] := 0;
    end;
  end;

  for i := 1 to l do
  begin
    for j := 1 to z do
    begin
      masOfExitImages[i,j] := TImage.Create(gameForm2);
      masOfExitImages[i,j].Parent := gameForm2;
      masOfExitImages[i,j].Width := 40;
      masOfExitImages[i,j].Height := 40;
      masOfExitImages[i,j].Stretch := true;
      masOfExitImages[i,j].Top := 364 + i * 40;
      masOfExitImages[i,j].Left := 440 + j * 40;
      masOfExitImages[i,j].Picture.LoadFromFile(dir + '0.bmp');
    end;
  end;

  masOfImages[1,1].Picture.LoadFromFile(dir + '1.3.bmp');
  masOfImages[1,1].Tag := 13;
  masOfZifr[1,1] := 1;

  masOfImages[1,2].Picture.LoadFromFile(dir + '1.2.bmp');
  masOfImages[1,2].Tag := 12;
  masOfZifr[1,2] := 1;

  masOfImages[1,3].Picture.LoadFromFile(dir + '1.1.bmp');
  masOfImages[1,3].Tag := 11;
  masOfZifr[1,3] := 1;

  masOfImages[1,9].Picture.LoadFromFile(dir + '2.1.bmp');
  masOfImages[1,9].Tag := 21;
  masOfZifr[1,9] := 2;

  masOfImages[2,9].Picture.LoadFromFile(dir + '2.2.bmp');
  masOfImages[2,9].Tag := 22;
  masOfZifr[2,9] := 2;

  masOfImages[3,9].Picture.LoadFromFile(dir + '2.3.bmp');
  masOfImages[3,9].Tag := 23;
  masOfZifr[3,9] := 2;

  masOfImages[3,4].Picture.LoadFromFile(dir + '3.3.bmp');
  masOfImages[3,4].Tag := 33;
  masOfZifr[3,4] := 3;

  masOfImages[3,5].Picture.LoadFromFile(dir + '3.2.bmp');
  masOfImages[3,5].Tag := 32;
  masOfZifr[3,5] := 3;

  masOfImages[3,6].Picture.LoadFromFile(dir + '3.1.bmp');
  masOfImages[3,6].Tag := 31;
  masOfZifr[3,6] := 3;

  masOfImages[4,5].Picture.LoadFromFile(dir + '4.1.bmp');
  masOfImages[4,5].Tag := 41;
  masOfZifr[4,5] := 4;

  masOfImages[5,5].Picture.LoadFromFile(dir + '4.2.bmp');
  masOfImages[5,5].Tag := 42;
  masOfZifr[5,5] := 4;

  masOfImages[6,5].Picture.LoadFromFile(dir + '4.3.bmp');
  masOfImages[6,5].Tag := 43;
  masOfZifr[6,5] := 4;

  masOfImages[4,1].Picture.LoadFromFile(dir + '5.1.bmp');
  masOfImages[4,1].Tag := 51;
  masOfZifr[4,1] := 5;

  masOfImages[4,2].Picture.LoadFromFile(dir + '5.2.bmp');
  masOfImages[4,2].Tag := 52;
  masOfZifr[4,2] := 5;

  masOfImages[4,3].Picture.LoadFromFile(dir + '5.3.bmp');
  masOfImages[4,3].Tag := 53;
  masOfZifr[4,3] := 5;

  masOfImages[6,8].Picture.LoadFromFile(dir + '6.1.bmp');
  masOfImages[6,8].Tag := 61;
  masOfZifr[6,8] := 6;

  masOfImages[5,8].Picture.LoadFromFile(dir + '6.2.bmp');
  masOfImages[5,8].Tag := 62;
  masOfZifr[5,8] := 6;

  masOfImages[4,8].Picture.LoadFromFile(dir + '6.3.bmp');
  masOfImages[4,8].Tag := 63;
  masOfZifr[4,8] := 6;

  masOfImages[6,1].Picture.LoadFromFile(dir + '9.3.bmp');
  masOfImages[6,1].Tag := 93;
  masOfZifr[6,1] := 9;

  masOfImages[6,2].Picture.LoadFromFile(dir + '9.2.bmp');
  masOfImages[6,2].Tag := 92;
  masOfZifr[6,2] := 9;

  masOfImages[6,3].Picture.LoadFromFile(dir + '9.1.bmp');
  masOfImages[6,3].Tag := 91;
  masOfZifr[6,3] := 9;

  masOfImages[1,5].Picture.LoadFromFile(dir + '-1.bmp');
  masOfImages[1,5].Tag := -1;
  masOfZifr[1,5] := -1;

  masOfImages[4,9].Picture.LoadFromFile(dir + '-1.bmp');
  masOfImages[4,9].Tag := -1;
  masOfZifr[4,9] := -1;

  masOfImages[3,1].Picture.LoadFromFile(dir + 'star.bmp');
  masOfImages[3,1].Tag := -2;
  masOfZifr[3,1] := -2;

  masOfImages[2,5].Picture.LoadFromFile(dir + 'star.bmp');
  masOfImages[2,5].Tag := -2;
  masOfZifr[2,5] := -2;

  masOfImages[1,8].Picture.LoadFromFile(dir + 'star.bmp');
  masOfImages[1,8].Tag := -2;
  masOfZifr[1,8] := -2;

  initialValues;
end;
//создание таймера только при показе этой формы
procedure TgameForm2.FormShow(Sender: TObject);
begin
  ShowMessage('В этом уровне тебе надо будет собрать 3 звезды, чтобы пройти его. Также здесь есть секундомер, который пока что ни на что не влияет');
  timer := TTimer.Create(gameForm2);
  timer.Interval := 1000;
  timer.OnTimer := Сountdown;

  timeStart := Time;
end;
//отсчет времени
procedure TgameForm2.Сountdown(Sender: TObject);
begin
  timeEnd := time;
  timeLabel.Caption :=  TimeToStr(timeEnd - timeStart);
end;

//событие на нажатие мыши
procedure TgameForm2.MD(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i, j: integer;
begin
  for i := 1 to m do
  begin
    for j := 1 to n do
    begin
      if masOfImages[i, j] = Sender then
      begin
        curI := i;
        curJ := j;
      end;
    end;
  end;
  //сложное определение положения машины
  if masOfImages[curI, curJ].Tag.ToString[1] <> '0' then
  begin //если не пустое место
    if (curJ > 1) and (curJ < 9) and (curI > 1) and (curI < 6) then
    begin //если самая середина
      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI, curJ - 1].Tag.ToString[1])) then
        horizontal := true;

      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1, curJ].Tag.ToString[1])) then
        vertical := true;
    end
    else if (curJ = 1) and (curI <> 1) and (curI <> 6) then
    begin //если левая стена
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1]) then
        horizontal := true;

      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1, curJ].Tag.ToString[1])) then
        vertical := true;
    end
    else if (curJ = 1) and (curI = 1) then
    begin //если левый верхний
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1]) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curJ = 1) and (curI = 6) then
    begin //если левый нижний
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1]) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curJ = 9) and (curI <> 1) and (curI <> 6) then
    begin //если правая стена
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ - 1].Tag.ToString[1]) then
        horizontal := true;

      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1, curJ].Tag.ToString[1])) then
        vertical := true;
    end
    else if (curJ = 9) and (curI = 1) then
    begin //если правый верхний
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ - 1].Tag.ToString[1]) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curJ = 9) and (curI = 6) then
    begin //если правый нижний
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ - 1].Tag.ToString[1]) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curI = 1) and (curJ <> 1) and (curJ <> 9) then
    begin //если верхняя стена
      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI, curJ - 1].Tag.ToString[1])) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curI = 6) and (curJ <> 1) and (curJ <> 9) then
    begin //если нижняя стена
      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI, curJ - 1].Tag.ToString[1])) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1, curJ].Tag.ToString[1]) then
        vertical := true;
    end
  end;

  if masOfImages[curI, curJ].Tag mod 10 = 1 then
    PCH := true
  else if masOfImages[curI, curJ].Tag mod 10 = 2 then
    SCH := true
  else if masOfImages[curI, curJ].Tag mod 10 = 3 then
    ZCH := true;
end;
//событие после отпускания мыши
procedure TgameForm2.MU(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var k: integer;
begin
  //если нужно подвинуть вправо
  if (X > 40) and (horizontal) then
  begin
    //если нужно двигаться п. частью начиная с начала машины
    if (PCH) and (masOfImages[curI, curJ + 1].Tag = 0) then
    begin
      for k := 1 to 3 do
      begin
        masOfImages[curI, curJ + 2 - k].picture.LoadFromFile(dir +
        masOfImages[curI, curJ].Tag.ToString[1] + '.' + IntToStr(k) + '.bmp');


        masOfImages[curI, curJ + 2 - k].Tag := masOfImages[curI, curJ + 1 - k].Tag;
        masOfZifr[curI, curJ + 2 - k] := masOfZifr[curI, curJ];
      end;

      masOfImages[curI, curJ - 2].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI, curJ - 2].Tag := 0;
      masOfZifr[curI, curJ - 2] := 0;
    end
    //если нужно двигаться з. частью начиная с начала машины
    else if (ZCH) and (masOfImages[curI, curJ + 1].Tag = 0) then
    begin
      for k := 1 to 3 do
      begin
        masOfImages[curI, curJ + 2 - k].picture.LoadFromFile(dir +
        masOfImages[curI, curJ + 1 - k].Tag.ToString[1] + '.' + IntToStr(4 - k) + '.bmp');


        masOfImages[curI, curJ + 2 - k].Tag := masOfImages[curI, curJ + 1 - k].Tag;
        masOfZifr[curI, curJ + 2 - k] := masOfZifr[curI, curJ + 1 - k];
      end;

      masOfImages[curI, curJ - 2].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI, curJ - 2].Tag := 0;
      masOfZifr[curI, curJ - 2] := 0;
    end
    //если нужно двигаться с. частью
    else if (SCH) and (masOfImages[curI, curJ + 2].Tag = 0) then
    begin
    // начиная с начала машины
      if masOfImages[curI, curJ + 1].Tag mod 10 = 1 then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ + 3 - k].picture.LoadFromFile(dir +
          masOfImages[curI, curJ].Tag.ToString[1] + '.' + IntToStr(k) + '.bmp');


          masOfImages[curI, curJ + 3 - k].Tag := masOfImages[curI, curJ + 2 - k].Tag;
          masOfZifr[curI, curJ + 3 - k] := masOfZifr[curI, curJ];
        end;

        masOfImages[curI, curJ - 1].Picture.LoadFromFile(dir + '0.bmp');
        masOfImages[curI, curJ - 1].Tag := 0;
        masOfZifr[curI, curJ - 1] := 0;
      end
      //начиная с конца машины
      else if masOfImages[curI, curJ + 1].Tag mod 10 = 3 then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ + 3 - k].picture.LoadFromFile(dir +
          masOfImages[curI, curJ + 2 - k].Tag.ToString[1] + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI, curJ + 3 - k].Tag := masOfImages[curI, curJ + 2 - k].Tag;
          masOfZifr[curI, curJ + 3 - k] := masOfZifr[curI, curJ + 2 - k];
        end;

        masOfImages[curI, curJ - 1].Picture.LoadFromFile(dir + '0.bmp');
        masOfImages[curI, curJ - 1].Tag := 0;
        masOfZifr[curI, curJ - 1] := 0;
      end;
    end
    //если нужно двигаться з. частью начиная с конца машины
    else if (ZCH) and (masOfImages[curI, curJ + 3].Tag = 0) and
      (masOfZifr[curI, curJ] = masOfZifr[curI, curJ + 1]) then
    begin
      for k := 1 to 3 do
      begin
        masOfImages[curI, curJ + 4 - k].picture.LoadFromFile(dir +
        masOfImages[curI, curJ].Tag.ToString[1] + '.' + IntToStr(k) + '.bmp');


        masOfImages[curI, curJ + 4 - k].Tag := masOfImages[curI, curJ + 3 - k].Tag;
        masOfZifr[curI, curJ + 4 - k] := masOfZifr[curI, curJ];
      end;

      masOfImages[curI, curJ].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI, curJ].Tag := 0;
      masOfZifr[curI, curJ] := 0;
    end
    //если нужно двигаться п. частью начиная с конца машины
    else if (PCH) and (masOfImages[curI, curJ + 3].Tag = 0) and
      (masOfZifr[curI, curJ] = masOfZifr[curI, curJ + 1]) then
    begin
      for k := 1 to 3 do
        begin
          masOfImages[curI, curJ + 4 - k].picture.LoadFromFile(dir +
          masOfImages[curI, curJ + 3 - k].Tag.ToString[1] + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI, curJ + 4 - k].Tag := masOfImages[curI, curJ + 3 - k].Tag;
          masOfZifr[curI, curJ + 4 - k] := masOfZifr[curI, curJ + 3 - k];
        end;

      masOfImages[curI, curJ].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI, curJ].Tag := 0;
      masOfZifr[curI, curJ] := 0;
    end;
  end;
  //если нужно подвинуть влево
  if (X < -40) and (horizontal) then
  begin
    //если нужно двигаться п. частью начиная с начала машины
    if (PCH) and (masOfImages[curI, curJ - 1].Tag = 0) then
    begin
      for k := 1 to 3 do
      begin
        masOfImages[curI, curJ - 2 + k].picture.LoadFromFile(dir +
        masOfImages[curI, curJ].Tag.ToString[1] + '.' + IntToStr(k) + '.bmp');


        masOfImages[curI, curJ - 2 + k].Tag := masOfImages[curI, curJ - 1 + k].Tag;
        masOfZifr[curI, curJ - 2 + k] := masOfZifr[curI, curJ];
      end;

      masOfImages[curI, curJ + 2].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI, curJ + 2].Tag := 0;
      masOfZifr[curI, curJ + 2] := 0;
    end
    //если нужно двигаться з. частью начиная с начала машины
    else if (ZCH) and ((masOfImages[curI, curJ - 1].Tag = 0) or
      (masOfImages[curI, curJ - 1].Tag = -2)) then
    begin
      for k := 1 to 3 do
      begin
        masOfImages[curI, curJ - 2 + k].picture.LoadFromFile(dir +
        masOfImages[curI, curJ  - 1 + k].Tag.ToString[1] + '.' + IntToStr(4 - k) + '.bmp');


        masOfImages[curI, curJ - 2 + k].Tag := masOfImages[curI, curJ - 1 + k].Tag;
        masOfZifr[curI, curJ - 2 + k] := masOfZifr[curI, curJ - 1 + k];
      end;

      masOfImages[curI, curJ + 2].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI, curJ + 2].Tag := 0;
      masOfZifr[curI, curJ + 2] := 0;
    end
    //если нужно двигаться с. частью
    else if (SCH) and ((masOfImages[curI, curJ - 2].Tag = 0) or
      (masOfImages[curI, curJ - 2].Tag = -2)) then
    begin
    //начиная с начала машины
      if masOfImages[curI, curJ - 1].Tag mod 10 = 1 then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ - 3 + k].picture.LoadFromFile(dir +
          masOfImages[curI, curJ].Tag.ToString[1] + '.' + IntToStr(k) + '.bmp');


          masOfImages[curI, curJ - 3 + k].Tag := masOfImages[curI, curJ - 2 + k].Tag;
          masOfZifr[curI, curJ - 3 + k] := masOfZifr[curI, curJ];
        end;

        masOfImages[curI, curJ + 1].Picture.LoadFromFile(dir + '0.bmp');
        masOfImages[curI, curJ + 1].Tag := 0;
        masOfZifr[curI, curJ + 1] := 0;
      end
      //начиная с конца машины
      else if masOfImages[curI, curJ - 1].Tag mod 10 = 3 then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ - 3 + k].picture.LoadFromFile(dir +
          masOfImages[curI, curJ  - 2 + k].Tag.ToString[1] + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI, curJ - 3 + k].Tag := masOfImages[curI, curJ - 2 + k].Tag;
          masOfZifr[curI, curJ - 3 + k] := masOfZifr[curI, curJ - 2 + k];
        end;

        masOfImages[curI, curJ + 1].Picture.LoadFromFile(dir + '0.bmp');
        masOfImages[curI, curJ + 1].Tag := 0;
        masOfZifr[curI, curJ + 1] := 0;
      end;
    end
    //если нужно двигаться з. частью начиная с конца машины
    else if (ZCH) and (masOfImages[curI, curJ - 3].Tag = 0) and
      (masOfZifr[curI, curJ] = masOfZifr[curI, curJ - 1]) then
    begin
      for k := 1 to 3 do
      begin
        masOfImages[curI, curJ - 4 + k].picture.LoadFromFile(dir +
        masOfImages[curI, curJ].Tag.ToString[1] + '.' + IntToStr(k) + '.bmp');


        masOfImages[curI, curJ - 4 + k].Tag := masOfImages[curI, curJ - 3 + k].Tag;
        masOfZifr[curI, curJ - 4 + k] := masOfZifr[curI, curJ];
      end;

      masOfImages[curI, curJ].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI, curJ].Tag := 0;
      masOfZifr[curI, curJ] := 0;
    end
    //если нужно двигаться п. частью начиная с конца машины
    else if (PCH) and ((masOfImages[curI, curJ - 3].Tag = 0) or
      (masOfImages[curI, curJ - 3].Tag = -2)) and
      (masOfZifr[curI, curJ] = masOfZifr[curI, curJ - 1]) then
    begin
      for k := 1 to 3 do
      begin
        masOfImages[curI, curJ - 4 + k].picture.LoadFromFile(dir +
        masOfImages[curI, curJ  - 3 + k].Tag.ToString[1] + '.' + IntToStr(4 - k) + '.bmp');


        masOfImages[curI, curJ - 4 + k].Tag := masOfImages[curI, curJ - 3 + k].Tag;
        masOfZifr[curI, curJ - 4 + k] := masOfZifr[curI, curJ - 3 + k];
      end;

      masOfImages[curI, curJ].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI, curJ].Tag := 0;
      masOfZifr[curI, curJ] := 0;
    end;
  end;
  //если нужно подвинуть вниз
  if (Y > 40) and (vertical) then
  begin
    //если нужно двигаться п. частью начиная с начала машины
    if (PCH) and (masOfImages[curI + 1, curJ].Tag = 0) then
    begin
      for k := 1 to 3 do
      begin
        masOfImages[curI + 2 - k, curJ].picture.LoadFromFile(dir +
        masOfImages[curI, curJ].Tag.ToString[1] + '.' + IntToStr(k) + '.bmp');


        masOfImages[curI + 2 - k, curJ].Tag := masOfImages[curI + 1 - k, curJ].Tag;
        masOfZifr[curI + 2 - k, curJ] := masOfZifr[curI, curJ];
      end;

      masOfImages[curI - 2, curJ].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI - 2, curJ].Tag := 0;
      masOfZifr[curI - 2, curJ] := 0;
    end
    //если нужно двигаться з. частью начиная с начала машины
    else if (ZCH) and (masOfImages[curI + 1, curJ].Tag = 0) then
    begin
      for k := 1 to 3 do
      begin
        masOfImages[curI + 2 - k, curJ].picture.LoadFromFile(dir +
        masOfImages[curI + 1 - k, curJ].Tag.ToString[1] + '.' + IntToStr(4 - k) + '.bmp');


        masOfImages[curI + 2 - k, curJ].Tag := masOfImages[curI + 1 - k, curJ].Tag;
        masOfZifr[curI + 2 - k, curJ] := masOfZifr[curI + 1 - k, curJ];
      end;

      masOfImages[curI - 2, curJ].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI - 2, curJ].Tag := 0;
      masOfZifr[curI - 2, curJ] := 0;
    end
    //если нужно двигаться с. частью
    else if (SCH) and (masOfImages[curI + 2, curJ].Tag = 0) then
    begin
    //начиная с начала машины
      if masOfImages[curI + 1, curJ].Tag mod 10 = 1 then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI + 3 - k, curJ].picture.LoadFromFile(dir +
          masOfImages[curI, curJ].Tag.ToString[1] + '.' + IntToStr(k) + '.bmp');


          masOfImages[curI + 3 - k, curJ].Tag := masOfImages[curI + 2 - k, curJ].Tag;
          masOfZifr[curI + 3 - k, curJ] := masOfZifr[curI, curJ];
        end;

        masOfImages[curI - 1, curJ].Picture.LoadFromFile(dir + '0.bmp');
        masOfImages[curI - 1, curJ].Tag := 0;
        masOfZifr[curI - 1, curJ] := 0;
      end
      //начиная с конца машины
      else if masOfImages[curI + 1, curJ].Tag mod 10 = 3 then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI + 3 - k, curJ].picture.LoadFromFile(dir +
          masOfImages[curI + 2 - k, curJ].Tag.ToString[1] + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI + 3 - k, curJ].Tag := masOfImages[curI + 2 - k, curJ].Tag;
          masOfZifr[curI + 3 - k, curJ] := masOfZifr[curI + 2 - k, curJ];
        end;

        masOfImages[curI - 1, curJ].Picture.LoadFromFile(dir + '0.bmp');
        masOfImages[curI - 1, curJ].Tag := 0;
        masOfZifr[curI - 1, curJ] := 0;
      end;
    end
    //если нужно двигаться з. частью начиная с конца машины
    else if (ZCH) and (masOfImages[curI + 3, curJ].Tag = 0) and
      (masOfZifr[curI, curJ] = masOfZifr[curI + 1, curJ]) then
    begin
      for k := 1 to 3 do
      begin
        masOfImages[curI + 4 - k, curJ].picture.LoadFromFile(dir +
        masOfImages[curI, curJ].Tag.ToString[1] + '.' + IntToStr(k) + '.bmp');


        masOfImages[curI + 4 - k, curJ].Tag := masOfImages[curI + 3 - k, curJ].Tag;
        masOfZifr[curI + 4 - k, curJ] := masOfZifr[curI, curJ];
      end;

      masOfImages[curI, curJ].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI, curJ].Tag := 0;
      masOfZifr[curI, curJ] := 0;
    end
    //если нужно двигаться п. частью начиная с конца машины
    else if (PCH) and (masOfImages[curI + 3, curJ].Tag = 0) and
      (masOfZifr[curI, curJ] = masOfZifr[curI + 1, curJ]) then
    begin
      for k := 1 to 3 do
        begin
          masOfImages[curI + 4 - k, curJ].picture.LoadFromFile(dir +
          masOfImages[curI + 3 - k, curJ].Tag.ToString[1] + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI + 4 - k, curJ].Tag := masOfImages[curI + 3 - k, curJ].Tag;
          masOfZifr[curI + 4 - k, curJ] := masOfZifr[curI + 3 - k, curJ];
        end;

      masOfImages[curI, curJ].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI, curJ].Tag := 0;
      masOfZifr[curI, curJ] := 0;
    end;
  end;
  //если нужно подвинуть вверх
  if (Y < -40) and (vertical) then
  begin
    //если нужно двигаться п. частью начиная с начала машины
    if (PCH) and ((masOfImages[curI - 1, curJ].Tag = 0) or
    (masOfImages[curI - 1, curJ].Tag = -2)) then
    begin
      for k := 1 to 3 do
      begin
        masOfImages[curI - 2 + k, curJ].picture.LoadFromFile(dir +
        masOfImages[curI, curJ].Tag.ToString[1] + '.' + IntToStr(k) + '.bmp');


        masOfImages[curI - 2 + k, curJ].Tag := masOfImages[curI - 1 + k, curJ].Tag;
        masOfZifr[curI - 2 + k, curJ] := masOfZifr[curI, curJ];
      end;

      masOfImages[curI + 2, curJ].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI + 2, curJ].Tag := 0;
      masOfZifr[curI + 2, curJ] := 0;
    end
    //если нужно двигаться з. частью начиная с начала машины
    else if (ZCH) and ((masOfImages[curI - 1, curJ].Tag = 0) or
    (masOfImages[curI - 1, curJ].Tag = -2)) then
    begin
      for k := 1 to 3 do
      begin
        masOfImages[curI - 2 + k, curJ].picture.LoadFromFile(dir +
        masOfImages[curI - 1 + k, curJ].Tag.ToString[1] + '.' + IntToStr(4 - k) + '.bmp');


        masOfImages[curI - 2 + k, curJ].Tag := masOfImages[curI - 1 + k, curJ].Tag;
        masOfZifr[curI - 2 + k, curJ] := masOfZifr[curI - 1 + k, curJ];
      end;

      masOfImages[curI + 2, curJ].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI + 2, curJ].Tag := 0;
      masOfZifr[curI + 2, curJ] := 0;
    end
    //если нужно двигаться с. частью
    else if (SCH) and ((masOfImages[curI - 2, curJ].Tag = 0) or
    (masOfImages[curI - 2, curJ].Tag = -2)) then
    begin
    //начиная с начала машины
      if masOfImages[curI - 1, curJ].Tag mod 10 = 1 then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI - 3 + k, curJ].picture.LoadFromFile(dir +
          masOfImages[curI, curJ].Tag.ToString[1] + '.' + IntToStr(k) + '.bmp');


          masOfImages[curI - 3 + k, curJ].Tag := masOfImages[curI - 2 + k, curJ].Tag;
          masOfZifr[curI - 3 + k, curJ] := masOfZifr[curI, curJ];
        end;

        masOfImages[curI + 1, curJ].Picture.LoadFromFile(dir + '0.bmp');
        masOfImages[curI + 1, curJ].Tag := 0;
        masOfZifr[curI + 1, curJ] := 0;
      end
      //начиная с конца машины
      else if masOfImages[curI - 1, curJ].Tag mod 10 = 3 then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI - 3 + k, curJ].picture.LoadFromFile(dir +
          masOfImages[curI - 2 + k, curJ].Tag.ToString[1] + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI - 3 + k, curJ].Tag := masOfImages[curI - 2 + k, curJ].Tag;
          masOfZifr[curI - 3 + k, curJ] := masOfZifr[curI - 2 + k, curJ];
        end;

        masOfImages[curI + 1, curJ].Picture.LoadFromFile(dir + '0.bmp');
        masOfImages[curI + 1, curJ].Tag := 0;
        masOfZifr[curI + 1, curJ] := 0;
      end;
    end
    //если нужно двигаться з. частью начиная с конца машины
    else if (ZCH) and ((masOfImages[curI - 3, curJ].Tag = 0) or
    (masOfImages[curI - 3, curJ].Tag = -2)) and
      (masOfZifr[curI, curJ] = masOfZifr[curI - 1, curJ]) then
    begin
      for k := 1 to 3 do
      begin
        masOfImages[curI - 4 + k, curJ].picture.LoadFromFile(dir +
        masOfImages[curI, curJ].Tag.ToString[1] + '.' + IntToStr(k) + '.bmp');


        masOfImages[curI - 4 + k, curJ].Tag := masOfImages[curI - 3 + k, curJ].Tag;
        masOfZifr[curI - 4 + k, curJ] := masOfZifr[curI, curJ];
      end;

      masOfImages[curI, curJ].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI, curJ].Tag := 0;
      masOfZifr[curI, curJ] := 0;
    end
    //если нужно двигаться п. частью начиная с конца машины
    else if (PCH) and ((masOfImages[curI - 3, curJ].Tag = 0) or
    (masOfImages[curI - 3, curJ].Tag = -2)) and
      (masOfZifr[curI, curJ] = masOfZifr[curI - 1, curJ]) then
    begin
      for k := 1 to 3 do
        begin
          masOfImages[curI - 4 + k, curJ].picture.LoadFromFile(dir +
          masOfImages[curI - 3 + k, curJ].Tag.ToString[1] + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI - 4 + k, curJ].Tag := masOfImages[curI - 3 + k, curJ].Tag;
          masOfZifr[curI - 4 + k, curJ] := masOfZifr[curI - 3 + k, curJ];
        end;

      masOfImages[curI, curJ].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[curI, curJ].Tag := 0;
      masOfZifr[curI, curJ] := 0;
    end;
  end;
  //проверка на выигрыш
  if win and star1 and star2 and star3 then
  begin
    timer.Enabled := false;
    ShowMessage('Вы выиграли');
    disableAll;
    //создание кнопки выезда
    exitButton := TButton.Create(gameForm2);
    exitButton.Parent := gameForm2;
    exitButton.Width := 40;
    exitButton.Height := 40;
    exitButton.Left := 490;
    exitButton.Top := 355;
    exitButton.Caption := 'Выезд';
    exitButton.OnClick := exitClick;
  end
  else if win and (star1 = false or star2 = false or star3 = false) then
  begin
    ShowMessage('Вы собрали не все звезды');
    disableTaxi;
  end;

  horizontal := false;
  vertical := false;

  ZCH := false;
  PCH := false;
  SCH := false;
end;
//неактивные картинки
procedure TgameForm2.disableAll;
var i, j:integer;
begin
  for i := 1 to m do
  begin
    for j := 1 to n do
    begin
      masOfImages[i,j].Enabled := false;
    end;
  end;
end;
//неактивные картинки такси
procedure TgameForm2.disableTaxi;
var i, j:integer;
begin
  for i := 1 to m do
  begin
    for j := 1 to n do
    begin
      if masOfZifr[i,j] = 9 then
      begin
        masOfImages[i,j].Enabled := false;
      end;
    end;
  end;
end;
//проверка на выигрыш
function TGameForm2.win;
begin
  if masOfZifr[exitI, exitJ] = 9 then
    result := true
  else
    result := false;
end;
//проверка на забор первой звездочки
function TGameForm2.star1;
begin
  if masOfZifr[star1I, star1J] <> -2 then
    result := true
  else
    result := false;
end;
//проверка на забор второй звездочки
function TGameForm2.star2;
begin
  if masOfZifr[star2I, star2J] <> -2 then
    result := true
  else
    result := false;
end;
//проверка на забор третьей звездочки
function TGameForm2.star3;
begin
  if masOfZifr[star3I, star3J] <> -2 then
    result := true
  else
    result := false;
end;
//красивый выезд со двора
procedure TGameForm2.exitClick;
begin
  case exitCounter of
    0:
    begin
      masOfExitImages[1,1].Picture.LoadFromFile(dir + '9.1.bmp');
      masOfImages[exitI,exitJ].Picture.LoadFromFile(dir + '9.2.bmp');
      masOfImages[exitI,exitJ - 1].Picture.LoadFromFile(dir + '9.3.bmp');
      masOfImages[exitI,exitJ - 2].picture.LoadFromFile(dir + '0.bmp');

      exitCounter := exitCounter + 1;
    end;
    1:
    begin
      masOfExitImages[1,2].Picture.LoadFromFile(dir + '9.1.bmp');
      masOfExitImages[1,1].Picture.LoadFromFile(dir + '9.2.bmp');
      masOfImages[exitI,exitJ].picture.LoadFromFile(dir + '9.3.bmp');
      masOfImages[exitI,exitJ - 1].Picture.LoadFromFile(dir + '0.bmp');

      exitCounter := exitCounter + 1;
    end;
    2:
    begin
      masOfExitImages[1,2].Picture.LoadFromFile(dir + '9.2.bmp');
      masOfExitImages[1,1].Picture.LoadFromFile(dir + '9.3.bmp');
      masOfImages[exitI,exitJ].picture.LoadFromFile(dir + '0.bmp');

      exitCounter := exitCounter + 1;
    end;
    3:
    begin
      masOfExitImages[1,2].Picture.LoadFromFile(dir + '9.3.bmp');
      masOfExitImages[1,1].Picture.LoadFromFile(dir + '0.bmp');

      exitCounter := exitCounter + 1;
    end;
    4:
    begin
      masOfExitImages[1,2].Picture.LoadFromFile(dir + '0.bmp');
      ShowMessage('Нажмите ок, и вы перейдете на след уровень');

      gameForm2.Close;
      gameForm3.Show;

    end;
  end;
end;

procedure TGameForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

end.
