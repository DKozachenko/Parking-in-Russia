unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus;

type
  TgameForm3 = class(TForm)
    bgGameForm3: TImage;
    Label3: TLabel;
    timeLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
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
    procedure restartClick(Sender: TObject);
  end;

const n = 10;
m = 10;
l = 2;
z = 1;
exitI = 1;
exitJ = 10;
star1I = 7;
star1J = 1;
star2I = 6;
star2J = 5;
star3I = 10;
star3J = 8;
dir = '..\..\images\thirdLevel\';
maxTime = 15;

var
  gameForm3: TgameForm3;
  masOfImages: array[1..m, 1..n] of Timage;
  masOfExitImages: array[1..l, 1..z] of TImage;
  masOfZifr:  array[1..m, 1..n] of integer;
  exitButton, restartButton: TButton;
  curI, curJ, exitCounter: integer;
  horizontal, vertical, ZCH, PCH, SCH: boolean;
  timeStart, timeEnd: TDateTime;
  timer: TTimer;
  cheat: string;

implementation

{$R *.dfm}


Uses Unit1, Unit2, Unit3, Unit6, Unit4, Unit7;

procedure TgameForm3.initialValues;
begin
  exitCounter := 0;

  horizontal := false;
  vertical := false;

  ZCH := false;
  PCH := false;
  SCH := false;
end;
//основные действия при создании формы
procedure TgameForm3.FormCreate(Sender: TObject);
var i, j: integer;
begin
  bgGameForm3.Picture.LoadFromFile(dir + 'thirdLevel.bmp');

  for i := 1 to m do
  begin
    for j := 1 to n do
    begin
      masOfImages[i,j] := TImage.Create(gameForm3);
      masOfImages[i,j].Parent := gameForm3;
      masOfImages[i,j].Width := 40;
      masOfImages[i,j].Height := 40;
      masOfImages[i,j].Stretch := true;
      masOfImages[i,j].Top := 40 + i * 40;
      masOfImages[i,j].Left := 90 + j * 40;
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
      masOfExitImages[i,j] := TImage.Create(gameForm3);
      masOfExitImages[i,j].Parent := gameForm3;
      masOfExitImages[i,j].Width := 40;
      masOfExitImages[i,j].Height := 40;
      masOfExitImages[i,j].Stretch := true;
      masOfExitImages[i,j].Top := -40 + i * 40;
      masOfExitImages[i,j].Left := 450 + j * 40;
      masOfExitImages[i,j].Picture.LoadFromFile(dir + '0.bmp');
    end;
  end;

  masOfImages[8,1].Picture.LoadFromFile(dir + '1.3.bmp');
  masOfImages[8,1].Tag := 13;
  masOfZifr[8,1] := 1;

  masOfImages[8,2].Picture.LoadFromFile(dir + '1.2.bmp');
  masOfImages[8,2].Tag := 12;
  masOfZifr[8,2] := 1;

  masOfImages[8,3].Picture.LoadFromFile(dir + '1.1.bmp');
  masOfImages[8,3].Tag := 11;
  masOfZifr[8,3] := 1;

  masOfImages[8,7].Picture.LoadFromFile(dir + '2.1.bmp');
  masOfImages[8,7].Tag := 21;
  masOfZifr[8,7] := 2;

  masOfImages[9,7].Picture.LoadFromFile(dir + '2.2.bmp');
  masOfImages[9,7].Tag := 22;
  masOfZifr[9,7] := 2;

  masOfImages[10,7].Picture.LoadFromFile(dir + '2.3.bmp');
  masOfImages[10,7].Tag := 23;
  masOfZifr[10,7] := 2;

  masOfImages[1,2].Picture.LoadFromFile(dir + '3.1.bmp');
  masOfImages[1,2].Tag := 31;
  masOfZifr[1,2] := 3;

  masOfImages[1,3].Picture.LoadFromFile(dir + '3.2.bmp');
  masOfImages[1,3].Tag := 32;
  masOfZifr[1,3] := 3;

  masOfImages[1,4].Picture.LoadFromFile(dir + '3.3.bmp');
  masOfImages[1,4].Tag := 33;
  masOfZifr[1,4] := 3;

  masOfImages[3,6].Picture.LoadFromFile(dir + '4.1.bmp');
  masOfImages[3,6].Tag := 41;
  masOfZifr[3,6] := 4;

  masOfImages[4,6].Picture.LoadFromFile(dir + '4.2.bmp');
  masOfImages[4,6].Tag := 42;
  masOfZifr[4,6] := 4;

  masOfImages[5,6].Picture.LoadFromFile(dir + '4.3.bmp');
  masOfImages[5,6].Tag := 43;
  masOfZifr[5,6] := 4;

  masOfImages[3,2].Picture.LoadFromFile(dir + '5.1.bmp');
  masOfImages[3,2].Tag := 51;
  masOfZifr[3,2] := 5;

  masOfImages[3,3].Picture.LoadFromFile(dir + '5.2.bmp');
  masOfImages[3,3].Tag := 52;
  masOfZifr[3,3] := 5;

  masOfImages[3,4].Picture.LoadFromFile(dir + '5.3.bmp');
  masOfImages[3,4].Tag := 53;
  masOfZifr[3,4] := 5;

  masOfImages[1,5].Picture.LoadFromFile(dir + '6.1.bmp');
  masOfImages[1,5].Tag := 61;
  masOfZifr[1,5] := 6;

  masOfImages[1,6].Picture.LoadFromFile(dir + '6.2.bmp');
  masOfImages[1,6].Tag := 62;
  masOfZifr[1,6] := 6;

  masOfImages[1,7].Picture.LoadFromFile(dir + '6.3.bmp');
  masOfImages[1,7].Tag := 63;
  masOfZifr[1,7] := 6;

  masOfImages[5,8].Picture.LoadFromFile(dir + '7.1.bmp');
  masOfImages[5,8].Tag := 71;
  masOfZifr[5,8] := 7;

  masOfImages[5,9].Picture.LoadFromFile(dir + '7.2.bmp');
  masOfImages[5,9].Tag := 72;
  masOfZifr[5,9] := 7;

  masOfImages[5,10].Picture.LoadFromFile(dir + '7.3.bmp');
  masOfImages[5,10].Tag := 73;
  masOfZifr[5,10] := 7;

  masOfImages[1,8].Picture.LoadFromFile(dir + '8.1.bmp');
  masOfImages[1,8].Tag := 81;
  masOfZifr[1,8] := 8;

  masOfImages[1,9].Picture.LoadFromFile(dir + '8.2.bmp');
  masOfImages[1,9].Tag := 82;
  masOfZifr[1,9] := 8;

  masOfImages[1,10].Picture.LoadFromFile(dir + '8.3.bmp');
  masOfImages[1,10].Tag := 83;
  masOfZifr[1,10] := 8;

  masOfImages[5,1].Picture.LoadFromFile(dir + '10.3.bmp');
  masOfImages[5,1].Tag := 103;
  masOfZifr[5,1] := 10;

  masOfImages[5,2].Picture.LoadFromFile(dir + '10.2.bmp');
  masOfImages[5,2].Tag := 102;
  masOfZifr[5,2] := 10;

  masOfImages[5,3].Picture.LoadFromFile(dir + '10.1.bmp');
  masOfImages[5,3].Tag := 101;
  masOfZifr[5,3] := 10;

  masOfImages[2,8].Picture.LoadFromFile(dir + '11.3.bmp');
  masOfImages[2,8].Tag := 113;
  masOfZifr[2,8] := 11;

  masOfImages[2,9].Picture.LoadFromFile(dir + '11.2.bmp');
  masOfImages[2,9].Tag := 112;
  masOfZifr[2,9] := 11;

  masOfImages[2,10].Picture.LoadFromFile(dir + '11.1.bmp');
  masOfImages[2,10].Tag := 111;
  masOfZifr[2,10] := 11;

  masOfImages[7,4].Picture.LoadFromFile(dir + '12.1.bmp');
  masOfImages[7,4].Tag := 121;
  masOfZifr[7,4] := 12;

  masOfImages[8,4].Picture.LoadFromFile(dir + '12.2.bmp');
  masOfImages[8,4].Tag := 122;
  masOfZifr[8,4] := 12;

  masOfImages[9,4].Picture.LoadFromFile(dir + '12.3.bmp');
  masOfImages[9,4].Tag := 123;
  masOfZifr[9,4] := 12;

  masOfImages[9,3].Picture.LoadFromFile(dir + '13.1.bmp');
  masOfImages[9,3].Tag := 131;
  masOfZifr[9,3] := 13;

  masOfImages[9,2].Picture.LoadFromFile(dir + '13.2.bmp');
  masOfImages[9,2].Tag := 132;
  masOfZifr[9,2] := 13;

  masOfImages[9,1].Picture.LoadFromFile(dir + '13.3.bmp');
  masOfImages[9,1].Tag := 133;
  masOfZifr[9,1] := 13;

  masOfImages[10,3].Picture.LoadFromFile(dir + '14.1.bmp');
  masOfImages[10,3].Tag := 141;
  masOfZifr[10,3] := 14;

  masOfImages[10,2].Picture.LoadFromFile(dir + '14.2.bmp');
  masOfImages[10,2].Tag := 142;
  masOfZifr[10,2] := 14;

  masOfImages[10,1].Picture.LoadFromFile(dir + '14.3.bmp');
  masOfImages[10,1].Tag := 143;
  masOfZifr[10,1] := 14;

  masOfImages[1,1].Picture.LoadFromFile(dir + '15.3.bmp');
  masOfImages[1,1].Tag := 153;
  masOfZifr[1,1] := 15;

  masOfImages[2,1].Picture.LoadFromFile(dir + '15.2.bmp');
  masOfImages[2,1].Tag := 152;
  masOfZifr[2,1] := 15;

  masOfImages[3,1].Picture.LoadFromFile(dir + '15.1.bmp');
  masOfImages[3,1].Tag := 151;
  masOfZifr[3,1] := 15;

  masOfImages[7,8].Picture.LoadFromFile(dir + '16.1.bmp');
  masOfImages[7,8].Tag := 161;
  masOfZifr[7,8] := 16;

  masOfImages[7,9].Picture.LoadFromFile(dir + '16.2.bmp');
  masOfImages[7,9].Tag := 162;
  masOfZifr[7,9] := 16;

  masOfImages[7,10].Picture.LoadFromFile(dir + '16.3.bmp');
  masOfImages[7,10].Tag := 163;
  masOfZifr[7,10] := 16;

  masOfImages[10,5].Picture.LoadFromFile(dir + '17.1.bmp');
  masOfImages[10,5].Tag := 171;
  masOfZifr[10,5] := 17;

  masOfImages[9,5].Picture.LoadFromFile(dir + '17.2.bmp');
  masOfImages[9,5].Tag := 172;
  masOfZifr[9,5] := 17;

  masOfImages[8,5].Picture.LoadFromFile(dir + '17.3.bmp');
  masOfImages[8,5].Tag := 173;
  masOfZifr[8,5] := 17;

  masOfImages[8,10].Picture.LoadFromFile(dir + '9.3.bmp');
  masOfImages[8,10].Tag := 93;
  masOfZifr[8,10] := 9;

  masOfImages[9,10].Picture.LoadFromFile(dir + '9.2.bmp');
  masOfImages[9,10].Tag := 92;
  masOfZifr[9,10] := 9;

  masOfImages[10,10].Picture.LoadFromFile(dir + '9.1.bmp');
  masOfImages[10,10].Tag := 91;
  masOfZifr[10,10] := 9;

  masOfImages[3,5].Picture.LoadFromFile(dir + '-1.bmp');
  masOfImages[3,5].Tag := -1;
  masOfZifr[3,5] := -1;

  masOfImages[5,5].Picture.LoadFromFile(dir + '-1.bmp');
  masOfImages[5,5].Tag := -1;
  masOfZifr[5,5] := -1;

  masOfImages[6,4].Picture.LoadFromFile(dir + '-1.bmp');
  masOfImages[6,4].Tag := -1;
  masOfZifr[6,4] := -1;

  masOfImages[7,6].Picture.LoadFromFile(dir + '-1.bmp');
  masOfImages[7,6].Tag := -1;
  masOfZifr[7,6] := -1;

  masOfImages[10,9].Picture.LoadFromFile(dir + '-1.bmp');
  masOfImages[10,9].Tag := -1;
  masOfZifr[10,9] := -1;

  masOfImages[6,5].Picture.LoadFromFile(dir + 'star.bmp');
  masOfImages[6,5].Tag := -2;
  masOfZifr[6,5] := -2;

  masOfImages[7,1].Picture.LoadFromFile(dir + 'star.bmp');
  masOfImages[7,1].Tag := -2;
  masOfZifr[7,1] := -2;

  masOfImages[10,8].Picture.LoadFromFile(dir + 'star.bmp');
  masOfImages[10,8].Tag := -2;
  masOfZifr[10,8] := -2;

  initialValues;
end;
//чит-код на сброс времени
procedure TgameForm3.FormKeyPress(Sender: TObject; var Key: Char);
begin
  cheat := cheat + key;
  Label3.Caption:= cheat;
  if cheat = 'zeroing' then
  begin
    timeStart := Time;
    cheat := '';
  end
  else
  begin
    if Length(cheat) >= 7 then
    begin
      cheat := '';
    end;
  end;
end;
//создание таймера только при показе этой формы
procedure TgameForm3.FormShow(Sender: TObject);
begin
  ShowMessage('В этом уровне тебе помимо сбора всех звезд, надо будет еще уложиться в '
  + IntToStr(maxTime) + ' секунд. Если ты не успеешь, то ты сможешь начать уровень заново');

  timer := TTimer.Create(gameForm3);
  timer.Interval := 1000;
  timer.OnTimer := Сountdown;

  timeStart := Time;
end;
//отсчет времени
procedure TgameForm3.Сountdown(Sender: TObject);
begin
  timeEnd := time;
  timeLabel.Caption :=  TimeToStr(timeEnd - timeStart);
  if (timeLabel.Caption = '0:00:' + IntToStr(maxTime)) then
  begin
    timer.Enabled := false;
    ShowMessage('You are late. Time is over');
    disableAll;

    restartButton := TButton.Create(gameForm3);
    restartButton.Parent := gameForm3;
    restartButton.Width := 130;
    restartButton.Height := 40;
    restartButton.Left := 120;
    restartButton.Top := 500;
    restartButton.Font.Size := 20;
    restartButton.Caption := 'Restart';
    restartButton.OnClick := restartClick;
  end;
end;
//событие на нажатие мыши
procedure TgameForm3.MD(Sender: TObject; Button: TMouseButton;
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
    if (curJ > 1) and (curJ < 10) and (curI > 1) and (curI < 10) then
    begin //если самая середина
      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI, curJ - 1].Tag.ToString[1])) then
        horizontal := true;

      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1, curJ].Tag.ToString[1])) then
        vertical := true;
    end
    else if (curJ = 1) and (curI <> 1) and (curI <> 10) then
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
    else if (curJ = 1) and (curI = 10) then
    begin //если левый нижний
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1]) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curJ = 10) and (curI <> 1) and (curI <> 10) then
    begin //если правая стена
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ - 1].Tag.ToString[1]) then
        horizontal := true;

      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1, curJ].Tag.ToString[1])) then
        vertical := true;
    end
    else if (curJ = 10) and (curI = 1) then
    begin //если правый верхний
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ - 1].Tag.ToString[1]) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curJ = 10) and (curI = 10) then
    begin //если правый нижний
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ - 1].Tag.ToString[1]) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curI = 1) and (curJ <> 1) and (curJ <> 10) then
    begin //если верхняя стена
      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI, curJ - 1].Tag.ToString[1])) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curI = 10) and (curJ <> 1) and (curJ <> 10) then
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
procedure TgameForm3.MU(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var k, l, z, b, numOfKl: integer;
str: string;
move: boolean;
begin
  //определение первых цифр картинки
  str := IntToStr(masOfImages[curI, curJ].Tag);
  l := Length(str);
  Delete(str, l, 1);
  move := false;

  if (X > 40) and (horizontal) then
  begin
    numOfKl := X div 40;
    if numOfKl = 0 then
    begin
      numOfKl := 1;
    end;

    //если нужно двигаться п. частью начиная с начала машины
    if PCH and (masOfZifr[curI, curJ] <> masOfZifr[curI, curJ + 1]) then
    begin
      //можно ли двигаться
      for z := curJ + 1 to curJ + numOfKl do
      begin
        if (masOfZifr[curI,z] = 0) or (masOfZifr[curI,z] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ + numOfKl + 1 - k].picture.LoadFromFile(dir +
          str + '.' + IntToStr(k) + '.bmp');


          masOfImages[curI, curJ + numOfKl + 1 - k].Tag := masOfImages[curI, curJ + 1 - k].Tag;
          masOfZifr[curI, curJ + numOfKl + 1 - k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ + numOfKl - 2 - b].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI, curJ + numOfKl - 2 - b].Tag := 0;
          masOfZifr[curI, curJ + numOfKl - 2 - b] := 0;
        end;
      end;
    end
    //если нужно двигаться з. частью начиная с начала машины
    else if ZCH and (masOfZifr[curI, curJ] <> masOfZifr[curI, curJ + 1]) then
     begin
       //можно ли двигаться
      for z := curJ + 1 to curJ + numOfKl do
      begin
        if (masOfZifr[curI,z] = 0) or (masOfZifr[curI,z] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ + numOfKl + 1 - k].picture.LoadFromFile(dir +
          str + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI, curJ + numOfKl + 1 - k].Tag := masOfImages[curI, curJ + 1 - k].Tag;
          masOfZifr[curI, curJ + numOfKl + 1 - k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ + numOfKl - 2 - b].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI, curJ + numOfKl - 2 - b].Tag := 0;
          masOfZifr[curI, curJ + numOfKl - 2 - b] := 0;
        end;
      end;
     end
    //если нужно двигаться с. частью
    else if (SCH) then
    begin
      //начиная с начала машины
      if masOfImages[curI, curJ + 1].Tag mod 10 = 1 then
      begin
        //можно ли двигаться
        for z := curJ + 2 to curJ + 1 + numOfKl do
        begin
          if (masOfZifr[curI,z] = 0) or (masOfZifr[curI,z] = -2) then
          begin
            move := true;
          end
          else
          begin
            move := false;
            break;
          end;
        end;
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI, curJ + numOfKl + 2 - k].picture.LoadFromFile(dir +
            str + '.' + IntToStr(k) + '.bmp');


            masOfImages[curI, curJ + numOfKl + 2 - k].Tag := masOfImages[curI, curJ + 2 - k].Tag;
            masOfZifr[curI, curJ + numOfKl + 2 - k] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI, curJ + numOfKl - 1 - b].Picture.LoadFromFile(dir + '0.bmp');
            masOfImages[curI, curJ + numOfKl - 1 - b].Tag := 0;
            masOfZifr[curI, curJ + numOfKl - 1 - b] := 0;
          end;
        end;
      end
      //начиная с конца машины
      else if masOfImages[curI, curJ + 1].Tag mod 10 = 3 then
      begin
        //можно ли двигаться
        for z := curJ + 2 to curJ + 1 + numOfKl do
        begin
          if (masOfZifr[curI,z] = 0) or (masOfZifr[curI,z] = -2) then
          begin
            move := true;
          end
          else
          begin
            move := false;
            break;
          end;
        end;
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI, curJ + numOfKl + 2 - k].picture.LoadFromFile(dir +
            str + '.' + IntToStr(4 - k) + '.bmp');


            masOfImages[curI, curJ + numOfKl + 2 - k].Tag := masOfImages[curI, curJ + 2 - k].Tag;
            masOfZifr[curI, curJ + numOfKl + 2 - k] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI, curJ + numOfKl - 1 - b].Picture.LoadFromFile(dir + '0.bmp');
            masOfImages[curI, curJ + numOfKl - 1 - b].Tag := 0;
            masOfZifr[curI, curJ + numOfKl - 1 - b] := 0;
          end;
        end;
      end;
    end
    //если нужно двигаться з. частью начиная с конца машины
    else if (ZCH) and (masOfZifr[curI, curJ] = masOfZifr[curI, curJ + 1]) then
    begin
      //можно ли двигаться
      for z := curJ + 3 to curJ + 2 + numOfKl do
      begin
        if (masOfZifr[curI,z] = 0) or (masOfZifr[curI,z] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ + numOfKl + 3 - k].picture.LoadFromFile(dir +
          str + '.' + IntToStr(k) + '.bmp');


          masOfImages[curI, curJ + numOfKl + 3 - k].Tag := masOfImages[curI, curJ + 3 - k].Tag;
          masOfZifr[curI, curJ + numOfKl + 3 - k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ + numOfKl - b].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI, curJ + numOfKl - b].Tag := 0;
          masOfZifr[curI, curJ + numOfKl - b] := 0;
        end;
      end;
    end
    //если нужно двигаться п. частью начиная с конца машины
    else if (PCH) and (masOfZifr[curI, curJ] = masOfZifr[curI, curJ + 1]) then
    begin
      //можно ли двигаться
      for z := curJ + 3 to curJ + 2 + numOfKl do
      begin
        if (masOfZifr[curI,z] = 0) or (masOfZifr[curI,z] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ + numOfKl + 3 - k].picture.LoadFromFile(dir +
          str + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI, curJ + numOfKl + 3 - k].Tag := masOfImages[curI, curJ + 3 - k].Tag;
          masOfZifr[curI, curJ + numOfKl + 3 - k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ + numOfKl - b].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI, curJ + numOfKl - b].Tag := 0;
          masOfZifr[curI, curJ + numOfKl - b] := 0;
        end;
      end;
    end;
  end;
  //если нужно подвинуть влево
  if (X < -40) and (horizontal) then
  begin
    numOfKl := (X div 40) div -1;
    if numOfKl = 0 then
    begin
      numOfKl := 1;
    end;

    //если нужно двигаться п. частью начиная с начала машины
    if (PCH) and (masOfZifr[curI, curJ] <> masOfZifr[curI, curJ - 1]) then
    begin
      //можно ли двигаться
      for z := curJ - 1 downto curJ - numOfKl do
      begin
        if (masOfZifr[curI,z] = 0) or (masOfZifr[curI,z] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ - numOfKl - 1 + k].picture.LoadFromFile(dir +
          str + '.' + IntToStr(k) + '.bmp');


          masOfImages[curI, curJ - numOfKl - 1 + k].Tag := masOfImages[curI, curJ - 1 + k].Tag;
          masOfZifr[curI, curJ - numOfKl - 1 + k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ - numOfKl + 2 + b].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI, curJ - numOfKl + 2 + b].Tag := 0;
          masOfZifr[curI, curJ - numOfKl + 2 + b] := 0;
        end;
      end;
    end
    //если нужно двигаться з. частью начиная с начала машины
    else if (ZCH) and (masOfZifr[curI, curJ] <> masOfZifr[curI, curJ - 1]) then
    begin
      //можно ли двигаться
      for z := curJ - 1 downto curJ - numOfKl do
      begin
        if (masOfZifr[curI,z] = 0) or (masOfZifr[curI,z] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ - numOfKl - 1 + k].picture.LoadFromFile(dir +
          str + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI, curJ - numOfKl - 1 + k].Tag := masOfImages[curI, curJ - 1 + k].Tag;
          masOfZifr[curI, curJ - numOfKl - 1 + k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ - numOfKl + 2 + b].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI, curJ - numOfKl + 2 + b].Tag := 0;
          masOfZifr[curI, curJ - numOfKl + 2 + b] := 0;
        end;
      end;
    end
    //если нужно двигаться с. частью
    else if (SCH) then
    begin
      //начиная с начала машины
      if masOfImages[curI, curJ - 1].Tag mod 10 = 1 then
      begin
        //можно ли двигаться
        for z := curJ - 2 downto curJ - 1 - numOfKl do
        begin
          if (masOfZifr[curI,z] = 0) or (masOfZifr[curI,z] = -2) then
          begin
            move := true;
          end
          else
          begin
            move := false;
            break;
          end;
        end;
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI, curJ - numOfKl - 2 + k].picture.LoadFromFile(dir +
            str + '.' + IntToStr(k) + '.bmp');


            masOfImages[curI, curJ - numOfKl - 2 + k].Tag := masOfImages[curI, curJ - 2 + k].Tag;
            masOfZifr[curI, curJ - numOfKl - 2 + k] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI, curJ - numOfKl + 1 + b].Picture.LoadFromFile(dir + '0.bmp');
            masOfImages[curI, curJ - numOfKl + 1 + b].Tag := 0;
            masOfZifr[curI, curJ - numOfKl + 1 + b] := 0;
          end;
        end;
      end
      //начиная с конца машины
      else if masOfImages[curI, curJ - 1].Tag mod 10 = 3 then
      begin
        //можно ли двигаться
        for z := curJ - 2 downto curJ - 1 - numOfKl do
        begin
          if (masOfZifr[curI,z] = 0) or (masOfZifr[curI,z] = -2) then
          begin
            move := true;
          end
          else
          begin
            move := false;
            break;
          end;
        end;
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI, curJ - numOfKl - 2 + k].picture.LoadFromFile(dir +
            str + '.' + IntToStr(4 - k) + '.bmp');


            masOfImages[curI, curJ - numOfKl - 2 + k].Tag := masOfImages[curI, curJ - 2 + k].Tag;
            masOfZifr[curI, curJ - numOfKl - 2 + k] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI, curJ - numOfKl + 1 + b].Picture.LoadFromFile(dir + '0.bmp');
            masOfImages[curI, curJ - numOfKl + 1 + b].Tag := 0;
            masOfZifr[curI, curJ - numOfKl + 1 + b] := 0;
          end;
        end;
      end;
    end
    //если нужно двигаться з. частью начиная с конца машины
    else if (ZCH) and (masOfZifr[curI, curJ] = masOfZifr[curI, curJ - 1]) then
    begin
      //можно ли двигаться
      for z := curJ - 3 downto curJ - 2 - numOfKl do
      begin
        if (masOfZifr[curI,z] = 0) or (masOfZifr[curI,z] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ - numOfKl - 3 + k].picture.LoadFromFile(dir +
          str + '.' + IntToStr(k) + '.bmp');


          masOfImages[curI, curJ - numOfKl - 3 + k].Tag := masOfImages[curI, curJ - 3 + k].Tag;
          masOfZifr[curI, curJ - numOfKl - 3 + k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ - numOfKl + b].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI, curJ - numOfKl + b].Tag := 0;
          masOfZifr[curI, curJ - numOfKl + b] := 0;
        end;
      end;
    end
    //если нужно двигаться п. частью начиная с конца машины
    else if (PCH) and (masOfZifr[curI, curJ] = masOfZifr[curI, curJ - 1]) then
    begin
      //можно ли двигаться
      for z := curJ - 3 downto curJ - 2 - numOfKl do
      begin
        if (masOfZifr[curI,z] = 0) or (masOfZifr[curI,z] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ - numOfKl - 3 + k].picture.LoadFromFile(dir +
          str + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI, curJ - numOfKl - 3 + k].Tag := masOfImages[curI, curJ - 3 + k].Tag;
          masOfZifr[curI, curJ - numOfKl - 3 + k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ - numOfKl + b].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI, curJ - numOfKl + b].Tag := 0;
          masOfZifr[curI, curJ - numOfKl + b] := 0;
        end;
      end;
    end;
  end;
  //если нужно подвинуть вниз
  if (Y > 40) and (vertical) then
  begin
    numOfKl := Y div 40;
    if numOfKl = 0 then
    begin
      numOfKl := 1;
    end;

    //если нужно двигаться п. частью начиная с начала машины
    if PCH and (masOfZifr[curI, curJ] <> masOfZifr[curI + 1, curJ]) then
    begin
      //можно ли двигаться
      for z := curI + 1 to curI + numOfKl do
      begin
        if (masOfZifr[z,curJ] = 0) or (masOfZifr[z,curJ] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI + numOfKl + 1 - k, curJ].picture.LoadFromFile(dir +
          str + '.' + IntToStr(k) + '.bmp');


          masOfImages[curI + numOfKl + 1 - k, curJ].Tag := masOfImages[curI + 1 - k, curJ].Tag;
          masOfZifr[curI + numOfKl + 1 - k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI + numOfKl - 2 - b, curJ].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI + numOfKl - 2 - b, curJ].Tag := 0;
          masOfZifr[curI + numOfKl - 2 - b, curJ] := 0;
        end;
      end;
    end
    //если нужно двигаться з. частью начиная с начала машины
    else if ZCH and (masOfZifr[curI, curJ] <> masOfZifr[curI + 1, curJ]) then
     begin
       //можно ли двигаться
      for z := curI + 1 to curI + numOfKl do
      begin
        if (masOfZifr[z,curJ] = 0) or (masOfZifr[z,curJ] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI + numOfKl + 1 - k, curJ].picture.LoadFromFile(dir +
          str + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI + numOfKl + 1 - k, curJ].Tag := masOfImages[curI + 1 - k, curJ].Tag;
          masOfZifr[curI + numOfKl + 1 - k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI + numOfKl - 2 - b, curJ].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI + numOfKl - 2 - b, curJ].Tag := 0;
          masOfZifr[curI + numOfKl - 2 - b, curJ] := 0;
        end;
      end;
     end
    //если нужно двигаться с. частью
    else if (SCH) then
    begin
      //начиная с начала машины
      if masOfImages[curI + 1, curJ].Tag mod 10 = 1 then
      begin
        //можно ли двигаться
        for z := curI + 2 to curI + 1 + numOfKl do
        begin
          if (masOfZifr[z,curJ] = 0) or (masOfZifr[z,curJ] = -2) then
          begin
            move := true;
          end
          else
          begin
            move := false;
            break;
          end;
        end;
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI + numOfKl + 2 - k, curJ].picture.LoadFromFile(dir +
            str + '.' + IntToStr(k) + '.bmp');


            masOfImages[curI + numOfKl + 2 - k, curJ].Tag := masOfImages[curI + 2 - k, curJ].Tag;
            masOfZifr[curI + numOfKl + 2 - k, curJ] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI + numOfKl - 1 - b, curJ].Picture.LoadFromFile(dir + '0.bmp');
            masOfImages[curI + numOfKl - 1 - b, curJ].Tag := 0;
            masOfZifr[curI + numOfKl - 1 - b, curJ] := 0;
          end;
        end;
      end
      //начиная с конца машины
      else if masOfImages[curI + 1, curJ].Tag mod 10 = 3 then
      begin
        //можно ли двигаться
        for z := curI + 2 to curI + 1 + numOfKl do
        begin
          if (masOfZifr[z,curJ] = 0) or (masOfZifr[z,curJ] = -2) then
          begin
            move := true;
          end
          else
          begin
            move := false;
            break;
          end;
        end;
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI + numOfKl + 2 - k, curJ].picture.LoadFromFile(dir +
            str + '.' + IntToStr(4 - k) + '.bmp');


            masOfImages[curI + numOfKl + 2 - k, curJ].Tag := masOfImages[curI + 2 - k, curJ].Tag;
            masOfZifr[curI + numOfKl + 2 - k, curJ] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI + numOfKl - 1 - b, curJ].Picture.LoadFromFile(dir + '0.bmp');
            masOfImages[curI + numOfKl - 1 - b, curJ].Tag := 0;
            masOfZifr[curI + numOfKl - 1 - b, curJ] := 0;
          end;
        end;
      end;
    end
    //если нужно двигаться з. частью начиная с конца машины
    else if (ZCH) and (masOfZifr[curI, curJ] = masOfZifr[curI + 1, curJ]) then
    begin
      //можно ли двигаться
      for z := curI + 3 to curI + 2 + numOfKl do
      begin
        if (masOfZifr[z,curJ] = 0) or (masOfZifr[z,curJ] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI + numOfKl + 3 - k, curJ].picture.LoadFromFile(dir +
          str + '.' + IntToStr(k) + '.bmp');


          masOfImages[curI + numOfKl + 3 - k, curJ].Tag := masOfImages[curI + 3 - k, curJ].Tag;
          masOfZifr[curI + numOfKl + 3 - k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfKl do
        begin
          masOfImages[curI + numOfKl - b, curJ].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI + numOfKl - b, curJ].Tag := 0;
          masOfZifr[curI + numOfKl - b, curJ] := 0;
        end;
      end;
    end
    //если нужно двигаться п. частью начиная с конца машины
    else if (PCH) and (masOfZifr[curI, curJ] = masOfZifr[curI + 1, curJ]) then
    begin
      //можно ли двигаться
      for z := curI + 3 to curI + 2 + numOfKl do
      begin
        if (masOfZifr[z,curJ] = 0) or (masOfZifr[z,curJ] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin    //

          masOfImages[curI + numOfKl + 3 - k, curJ].picture.LoadFromFile(dir +
          str + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI + numOfKl + 3 - k, curJ].Tag := masOfImages[curI + 3 - k, curJ].Tag;
          masOfZifr[curI + numOfKl + 3 - k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI + numOfKl - b, curJ].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI + numOfKl - b, curJ].Tag := 0;
          masOfZifr[curI + numOfKl - b, curJ] := 0;
        end;
      end;
    end;
  end;
  //если нужно подвинуть вверх
  if (Y < -40) and (vertical) then
  begin
    numOfKl := (Y div 40) div -1;
    if numOfKl = 0 then
    begin
      numOfKl := 1;
    end;

    //если нужно двигаться п. частью начиная с начала машины
    if (PCH) and (masOfZifr[curI, curJ] <> masOfZifr[curI - 1, curJ]) then
    begin
      //можно ли двигаться
      for z := curI - 1 downto curI - numOfKl do
      begin
        if (masOfZifr[z,curJ] = 0) or (masOfZifr[z,curJ] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI - numOfKl - 1 + k, curJ].picture.LoadFromFile(dir +
          str + '.' + IntToStr(k) + '.bmp');


          masOfImages[curI - numOfKl - 1 + k, curJ].Tag := masOfImages[curI - 1 + k, curJ].Tag;
          masOfZifr[curI - numOfKl - 1 + k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI - numOfKl + 2 + b, curJ].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI - numOfKl + 2 + b, curJ].Tag := 0;
          masOfZifr[curI - numOfKl + 2 + b, curJ] := 0;
        end;
      end;
    end
    //если нужно двигаться з. частью начиная с начала машины
    else if (ZCH) and (masOfZifr[curI, curJ] <> masOfZifr[curI - 1, curJ]) then
    begin
      //можно ли двигаться
      for z := curI - 1 downto curI - numOfKl do
      begin
        if (masOfZifr[z,curJ] = 0) or (masOfZifr[z,curJ] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI - numOfKl - 1 + k, curJ].picture.LoadFromFile(dir +
          str + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI - numOfKl - 1 + k, curJ].Tag := masOfImages[curI - 1 + k, curJ].Tag;
          masOfZifr[curI - numOfKl - 1 + k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI - numOfKl + 2 + b, curJ].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI - numOfKl + 2 + b, curJ].Tag := 0;
          masOfZifr[curI - numOfKl + 2 + b, curJ] := 0;
        end;
      end;
    end
    //если нужно двигаться с. частью
    else if (SCH) then
    begin
      //начиная с начала машины
      if masOfImages[curI - 1, curJ].Tag mod 10 = 1 then
      begin
        //можно ли двигаться
        for z := curI - 2 downto curI - 1 - numOfKl do
        begin
          if (masOfZifr[z,curJ] = 0) or (masOfZifr[z,curJ] = -2) then
          begin
            move := true;
          end
          else
          begin
            move := false;
            break;
          end;
        end;
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI - numOfKl - 2 + k, curJ].picture.LoadFromFile(dir +
            str + '.' + IntToStr(k) + '.bmp');


            masOfImages[curI - numOfKl - 2 + k, curJ].Tag := masOfImages[curI - 2 + k, curJ].Tag;
            masOfZifr[curI - numOfKl - 2 + k, curJ] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI - numOfKl + 1 + b, curJ].Picture.LoadFromFile(dir + '0.bmp');
            masOfImages[curI - numOfKl + 1 + b, curJ].Tag := 0;
            masOfZifr[curI - numOfKl + 1 + b, curJ] := 0;
          end;
        end;
      end
      //начиная с конца машины
      else if masOfImages[curI - 1, curJ].Tag mod 10 = 3 then
      begin
        //можно ли двигаться
        for z := curI - 2 downto curI - 1 - numOfKl do
        begin
          if (masOfZifr[z,curJ] = 0) or (masOfZifr[z,curJ] = -2) then
          begin
            move := true;
          end
          else
          begin
            move := false;
            break;
          end;
        end;
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI - numOfKl - 2 + k, curJ].picture.LoadFromFile(dir +
            str + '.' + IntToStr(4 - k) + '.bmp');


            masOfImages[curI - numOfKl - 2 + k, curJ].Tag := masOfImages[curI - 2 + k, curJ].Tag;
            masOfZifr[curI - numOfKl - 2 + k, curJ] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI - numOfKl + 1 + b, curJ].Picture.LoadFromFile(dir + '0.bmp');
            masOfImages[curI - numOfKl + 1 + b, curJ].Tag := 0;
            masOfZifr[curI - numOfKl + 1 + b, curJ] := 0;
          end;
        end;
      end;
    end
    //если нужно двигаться з. частью начиная с конца машины
    else if (ZCH) and (masOfZifr[curI, curJ] = masOfZifr[curI - 1, curJ]) then
    begin
      //можно ли двигаться
      for z := curI - 3 downto curI - 2 - numOfKl do
      begin
        if (masOfZifr[z,curJ] = 0) or (masOfZifr[z,curJ] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI - numOfKl - 3 + k, curJ].picture.LoadFromFile(dir +
          str + '.' + IntToStr(k) + '.bmp');


          masOfImages[curI - numOfKl - 3 + k, curJ].Tag := masOfImages[curI - 3 + k, curJ].Tag;
          masOfZifr[curI - numOfKl - 3 + k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI - numOfKl + b, curJ].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI - numOfKl + b, curJ].Tag := 0;
          masOfZifr[curI - numOfKl + b, curJ] := 0;
        end;
      end;
    end
    //если нужно двигаться п. частью начиная с конца машины
    else if (PCH) and (masOfZifr[curI, curJ] = masOfZifr[curI - 1, curJ]) then
    begin
      //можно ли двигаться
      for z := curI - 3 downto curI - 2 - numOfKl do
      begin
        if (masOfZifr[z,curJ] = 0) or (masOfZifr[z,curJ] = -2) then
        begin
          move := true;
        end
        else
        begin
          move := false;
          break;
        end;
      end;
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI - numOfKl - 3 + k, curJ].picture.LoadFromFile(dir +
          str + '.' + IntToStr(4 - k) + '.bmp');


          masOfImages[curI - numOfKl - 3 + k, curJ].Tag := masOfImages[curI - 3 + k, curJ].Tag;
          masOfZifr[curI - numOfKl - 3 + k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI - numOfKl + b, curJ].Picture.LoadFromFile(dir + '0.bmp');
          masOfImages[curI - numOfKl + b, curJ].Tag := 0;
          masOfZifr[curI - numOfKl + b, curJ] := 0;
        end;
      end;
    end;
  end;
  //проверка на выигрыш
  if win and star1 and star2 and star3 then
  begin
    timer.Enabled := false;
    ShowMessage('Вы выиграли');
    disableAll;
    //создание кнопки выезда
    exitButton := TButton.Create(gameForm3);
    exitButton.Parent := gameForm3;
    exitButton.Width := 40;
    exitButton.Height := 40;
    exitButton.Left := 450;
    exitButton.Top := 40;
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
procedure TgameForm3.disableAll;
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
procedure TgameForm3.disableTaxi;
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
function TGameForm3.win;
begin
  if masOfZifr[exitI, exitJ] = 9 then
    result := true
  else
    result := false;
end;
//проверка на забор первой звездочки
function TGameForm3.star1;
begin
  if masOfZifr[star1I, star1J] <> -2 then
    result := true
  else
    result := false;
end;
//проверка на забор второй звездочки
function TGameForm3.star2;
begin
  if masOfZifr[star2I, star2J] <> -2 then
    result := true
  else
    result := false;
end;
//проверка на забор третьей звездочки
function TGameForm3.star3;
begin
  if masOfZifr[star3I, star3J] <> -2 then
    result := true
  else
    result := false;
end;
//красивый выезд со двора
procedure TGameForm3.exitClick;
begin
  case exitCounter of
    0:
    begin
      masOfExitImages[2,1].Picture.LoadFromFile(dir + '9.3.bmp');
      masOfImages[exitI,exitJ].Picture.LoadFromFile(dir + '9.2.bmp');
      masOfImages[exitI + 1,exitJ].Picture.LoadFromFile(dir + '9.1.bmp');
      masOfImages[exitI + 2,exitJ].picture.LoadFromFile(dir + '0.bmp');

      exitCounter := exitCounter + 1;
    end;
    1:
    begin
      masOfExitImages[1,1].Picture.LoadFromFile(dir + '9.3.bmp');
      masOfExitImages[2,1].Picture.LoadFromFile(dir + '9.2.bmp');
      masOfImages[exitI,exitJ].picture.LoadFromFile(dir + '9.1.bmp');
      masOfImages[exitI + 1,exitJ].Picture.LoadFromFile(dir + '0.bmp');

      exitCounter := exitCounter + 1;
    end;
    2:
    begin
      masOfExitImages[1,1].Picture.LoadFromFile(dir + '9.2.bmp');
      masOfExitImages[2,1].Picture.LoadFromFile(dir + '9.1.bmp');
      masOfImages[exitI,exitJ].picture.LoadFromFile(dir + '0.bmp');

      exitCounter := exitCounter + 1;
    end;
    3:
    begin
      masOfExitImages[1,1].Picture.LoadFromFile(dir + '9.1.bmp');
      masOfExitImages[2,1].Picture.LoadFromFile(dir + '0.bmp');

      exitCounter := exitCounter + 1;
    end;
    4:
    begin
      masOfExitImages[1,1].Picture.LoadFromFile(dir + '0.bmp');
      ShowMessage('Нажмите ок, и вы перейдете к заставке');

      gameForm3.Close;
      StoryForm2.Show;

    end;
  end;
end;

procedure TGameForm3.restartClick(Sender: TObject);
var i, j:integer;
begin
  for i := 1 to m do
  begin
    for j := 1 to n do
    begin
      masOfImages[i,j].Enabled := true;
      masOfImages[i,j].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[i,j].Tag := 0;

      masOfZifr[i,j] := 0;
    end;
  end;

  masOfImages[8,1].Picture.LoadFromFile(dir + '1.3.bmp');
  masOfImages[8,1].Tag := 13;
  masOfZifr[8,1] := 1;

  masOfImages[8,2].Picture.LoadFromFile(dir + '1.2.bmp');
  masOfImages[8,2].Tag := 12;
  masOfZifr[8,2] := 1;

  masOfImages[8,3].Picture.LoadFromFile(dir + '1.1.bmp');
  masOfImages[8,3].Tag := 11;
  masOfZifr[8,3] := 1;

  masOfImages[8,7].Picture.LoadFromFile(dir + '2.1.bmp');
  masOfImages[8,7].Tag := 21;
  masOfZifr[8,7] := 2;

  masOfImages[9,7].Picture.LoadFromFile(dir + '2.2.bmp');
  masOfImages[9,7].Tag := 22;
  masOfZifr[9,7] := 2;

  masOfImages[10,7].Picture.LoadFromFile(dir + '2.3.bmp');
  masOfImages[10,7].Tag := 23;
  masOfZifr[10,7] := 2;

  masOfImages[1,2].Picture.LoadFromFile(dir + '3.1.bmp');
  masOfImages[1,2].Tag := 31;
  masOfZifr[1,2] := 3;

  masOfImages[1,3].Picture.LoadFromFile(dir + '3.2.bmp');
  masOfImages[1,3].Tag := 32;
  masOfZifr[1,3] := 3;

  masOfImages[1,4].Picture.LoadFromFile(dir + '3.3.bmp');
  masOfImages[1,4].Tag := 33;
  masOfZifr[1,4] := 3;

  masOfImages[3,6].Picture.LoadFromFile(dir + '4.1.bmp');
  masOfImages[3,6].Tag := 41;
  masOfZifr[3,6] := 4;

  masOfImages[4,6].Picture.LoadFromFile(dir + '4.2.bmp');
  masOfImages[4,6].Tag := 42;
  masOfZifr[4,6] := 4;

  masOfImages[5,6].Picture.LoadFromFile(dir + '4.3.bmp');
  masOfImages[5,6].Tag := 43;
  masOfZifr[5,6] := 4;

  masOfImages[3,2].Picture.LoadFromFile(dir + '5.1.bmp');
  masOfImages[3,2].Tag := 51;
  masOfZifr[3,2] := 5;

  masOfImages[3,3].Picture.LoadFromFile(dir + '5.2.bmp');
  masOfImages[3,3].Tag := 52;
  masOfZifr[3,3] := 5;

  masOfImages[3,4].Picture.LoadFromFile(dir + '5.3.bmp');
  masOfImages[3,4].Tag := 53;
  masOfZifr[3,4] := 5;

  masOfImages[1,5].Picture.LoadFromFile(dir + '6.1.bmp');
  masOfImages[1,5].Tag := 61;
  masOfZifr[1,5] := 6;

  masOfImages[1,6].Picture.LoadFromFile(dir + '6.2.bmp');
  masOfImages[1,6].Tag := 62;
  masOfZifr[1,6] := 6;

  masOfImages[1,7].Picture.LoadFromFile(dir + '6.3.bmp');
  masOfImages[1,7].Tag := 63;
  masOfZifr[1,7] := 6;

  masOfImages[5,8].Picture.LoadFromFile(dir + '7.1.bmp');
  masOfImages[5,8].Tag := 71;
  masOfZifr[5,8] := 7;

  masOfImages[5,9].Picture.LoadFromFile(dir + '7.2.bmp');
  masOfImages[5,9].Tag := 72;
  masOfZifr[5,9] := 7;

  masOfImages[5,10].Picture.LoadFromFile(dir + '7.3.bmp');
  masOfImages[5,10].Tag := 73;
  masOfZifr[5,10] := 7;

  masOfImages[1,8].Picture.LoadFromFile(dir + '8.1.bmp');
  masOfImages[1,8].Tag := 81;
  masOfZifr[1,8] := 8;

  masOfImages[1,9].Picture.LoadFromFile(dir + '8.2.bmp');
  masOfImages[1,9].Tag := 82;
  masOfZifr[1,9] := 8;

  masOfImages[1,10].Picture.LoadFromFile(dir + '8.3.bmp');
  masOfImages[1,10].Tag := 83;
  masOfZifr[1,10] := 8;

  masOfImages[5,1].Picture.LoadFromFile(dir + '10.3.bmp');
  masOfImages[5,1].Tag := 103;
  masOfZifr[5,1] := 10;

  masOfImages[5,2].Picture.LoadFromFile(dir + '10.2.bmp');
  masOfImages[5,2].Tag := 102;
  masOfZifr[5,2] := 10;

  masOfImages[5,3].Picture.LoadFromFile(dir + '10.1.bmp');
  masOfImages[5,3].Tag := 101;
  masOfZifr[5,3] := 10;

  masOfImages[2,8].Picture.LoadFromFile(dir + '11.3.bmp');
  masOfImages[2,8].Tag := 113;
  masOfZifr[2,8] := 11;

  masOfImages[2,9].Picture.LoadFromFile(dir + '11.2.bmp');
  masOfImages[2,9].Tag := 112;
  masOfZifr[2,9] := 11;

  masOfImages[2,10].Picture.LoadFromFile(dir + '11.1.bmp');
  masOfImages[2,10].Tag := 111;
  masOfZifr[2,10] := 11;

  masOfImages[7,4].Picture.LoadFromFile(dir + '12.1.bmp');
  masOfImages[7,4].Tag := 121;
  masOfZifr[7,4] := 12;

  masOfImages[8,4].Picture.LoadFromFile(dir + '12.2.bmp');
  masOfImages[8,4].Tag := 122;
  masOfZifr[8,4] := 12;

  masOfImages[9,4].Picture.LoadFromFile(dir + '12.3.bmp');
  masOfImages[9,4].Tag := 123;
  masOfZifr[9,4] := 12;

  masOfImages[9,3].Picture.LoadFromFile(dir + '13.1.bmp');
  masOfImages[9,3].Tag := 131;
  masOfZifr[9,3] := 13;

  masOfImages[9,2].Picture.LoadFromFile(dir + '13.2.bmp');
  masOfImages[9,2].Tag := 132;
  masOfZifr[9,2] := 13;

  masOfImages[9,1].Picture.LoadFromFile(dir + '13.3.bmp');
  masOfImages[9,1].Tag := 133;
  masOfZifr[9,1] := 13;

  masOfImages[10,3].Picture.LoadFromFile(dir + '14.1.bmp');
  masOfImages[10,3].Tag := 141;
  masOfZifr[10,3] := 14;

  masOfImages[10,2].Picture.LoadFromFile(dir + '14.2.bmp');
  masOfImages[10,2].Tag := 142;
  masOfZifr[10,2] := 14;

  masOfImages[10,1].Picture.LoadFromFile(dir + '14.3.bmp');
  masOfImages[10,1].Tag := 143;
  masOfZifr[10,1] := 14;

  masOfImages[1,1].Picture.LoadFromFile(dir + '15.3.bmp');
  masOfImages[1,1].Tag := 153;
  masOfZifr[1,1] := 15;

  masOfImages[2,1].Picture.LoadFromFile(dir + '15.2.bmp');
  masOfImages[2,1].Tag := 152;
  masOfZifr[2,1] := 15;

  masOfImages[3,1].Picture.LoadFromFile(dir + '15.1.bmp');
  masOfImages[3,1].Tag := 151;
  masOfZifr[3,1] := 15;

  masOfImages[7,8].Picture.LoadFromFile(dir + '16.1.bmp');
  masOfImages[7,8].Tag := 161;
  masOfZifr[7,8] := 16;

  masOfImages[7,9].Picture.LoadFromFile(dir + '16.2.bmp');
  masOfImages[7,9].Tag := 162;
  masOfZifr[7,9] := 16;

  masOfImages[7,10].Picture.LoadFromFile(dir + '16.3.bmp');
  masOfImages[7,10].Tag := 163;
  masOfZifr[7,10] := 16;

  masOfImages[10,5].Picture.LoadFromFile(dir + '17.1.bmp');
  masOfImages[10,5].Tag := 171;
  masOfZifr[10,5] := 17;

  masOfImages[9,5].Picture.LoadFromFile(dir + '17.2.bmp');
  masOfImages[9,5].Tag := 172;
  masOfZifr[9,5] := 17;

  masOfImages[8,5].Picture.LoadFromFile(dir + '17.3.bmp');
  masOfImages[8,5].Tag := 173;
  masOfZifr[8,5] := 17;

  masOfImages[8,10].Picture.LoadFromFile(dir + '9.3.bmp');
  masOfImages[8,10].Tag := 93;
  masOfZifr[8,10] := 9;

  masOfImages[9,10].Picture.LoadFromFile(dir + '9.2.bmp');
  masOfImages[9,10].Tag := 92;
  masOfZifr[9,10] := 9;

  masOfImages[10,10].Picture.LoadFromFile(dir + '9.1.bmp');
  masOfImages[10,10].Tag := 91;
  masOfZifr[10,10] := 9;

  masOfImages[3,5].Picture.LoadFromFile(dir + '-1.bmp');
  masOfImages[3,5].Tag := -1;
  masOfZifr[3,5] := -1;

  masOfImages[5,5].Picture.LoadFromFile(dir + '-1.bmp');
  masOfImages[5,5].Tag := -1;
  masOfZifr[5,5] := -1;

  masOfImages[6,4].Picture.LoadFromFile(dir + '-1.bmp');
  masOfImages[6,4].Tag := -1;
  masOfZifr[6,4] := -1;

  masOfImages[7,6].Picture.LoadFromFile(dir + '-1.bmp');
  masOfImages[7,6].Tag := -1;
  masOfZifr[7,6] := -1;

  masOfImages[10,9].Picture.LoadFromFile(dir + '-1.bmp');
  masOfImages[10,9].Tag := -1;
  masOfZifr[10,9] := -1;

  masOfImages[6,5].Picture.LoadFromFile(dir + 'star.bmp');
  masOfImages[6,5].Tag := -2;
  masOfZifr[6,5] := -2;

  masOfImages[7,1].Picture.LoadFromFile(dir + 'star.bmp');
  masOfImages[7,1].Tag := -2;
  masOfZifr[7,1] := -2;

  masOfImages[10,8].Picture.LoadFromFile(dir + 'star.bmp');
  masOfImages[10,8].Tag := -2;
  masOfZifr[10,8] := -2;

  initialValues;
  restartButton.Destroy;

  timeLabel.Caption := '';
  timer.Enabled := true;
  timeStart := Time;
end;

end.
