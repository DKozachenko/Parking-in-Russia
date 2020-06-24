unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TgameForm = class(TForm)
    bgGameForm: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure initialValues;
    procedure MD(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MU(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    function win:boolean;
    procedure disableAll;
    procedure exitClick(Sender: TObject);
  end;

const n = 7;
m = 4;
l = 2;
z = 1;
exitI = 4;
exitJ = 7;
dir = '..\..\images\firstLevel\';

var
  gameForm: TgameForm;
  masOfImages: array[1..m, 1..n] of Timage;
  masOfExitImages: array[1..l, 1..z] of TImage;
  masOfZifr:  array[1..m, 1..n] of integer;
  exitButton: TButton;
  curI, curJ, exitCounter, numberOfLevel: integer;
  horizontal, vertical, ZCH, PCH, SCH: boolean;

implementation

{$R *.dfm}

Uses Unit1, Unit2, Unit4, Unit5;
procedure TgameForm.initialValues;
begin
  exitCounter := 0;

  horizontal := false;
  vertical := false;

  ZCH := false;
  PCH := false;
  SCH := false;
end;

//осноные действия при создании формы
procedure TgameForm.FormCreate(Sender: TObject);
var i, j: integer;
begin
  bgGameForm.Picture.LoadFromFile(dir + 'firstLevel.bmp');
  for i := 1 to m do
  begin
    for j := 1 to n do
    begin
      masOfImages[i,j] := TImage.Create(gameForm);
      masOfImages[i,j].Parent := gameForm;
      masOfImages[i,j].Width := 40;
      masOfImages[i,j].Height := 40;
      masOfImages[i,j].Stretch := true;
      masOfImages[i,j].Top := 124 + i * 40;
      masOfImages[i,j].Left := -3 + j * 40;
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
      masOfExitImages[i,j] := TImage.Create(gameForm);
      masOfExitImages[i,j].Parent := gameForm;
      masOfExitImages[i,j].Width := 40;
      masOfExitImages[i,j].Height := 40;
      masOfExitImages[i,j].Stretch := true;
      masOfExitImages[i,j].Top := 284 + i * 40;
      masOfExitImages[i,j].Left := 237 + j * 40;
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

  masOfImages[2,1].Picture.LoadFromFile(dir + '2.1.bmp');
  masOfImages[2,1].Tag := 21;
  masOfZifr[2,1] := 2;

  masOfImages[3,1].Picture.LoadFromFile(dir + '2.2.bmp');
  masOfImages[3,1].Tag := 22;
  masOfZifr[3,1] := 2;

  masOfImages[4,1].Picture.LoadFromFile(dir + '2.3.bmp');
  masOfImages[4,1].Tag := 23;
  masOfZifr[4,1] := 2;

  masOfImages[4,2].Picture.LoadFromFile(dir + '3.3.bmp');
  masOfImages[4,2].Tag := 33;
  masOfZifr[4,2] := 3;

  masOfImages[4,3].Picture.LoadFromFile(dir + '3.2.bmp');
  masOfImages[4,3].Tag := 32;
  masOfZifr[4,3] := 3;

  masOfImages[4,4].Picture.LoadFromFile(dir + '3.1.bmp');
  masOfImages[4,4].Tag := 31;
  masOfZifr[4,4] := 3;

  masOfImages[4,5].Picture.LoadFromFile(dir + '4.1.bmp');
  masOfImages[4,5].Tag := 41;
  masOfZifr[4,5] := 4;

  masOfImages[4,6].Picture.LoadFromFile(dir + '4.2.bmp');
  masOfImages[4,6].Tag := 42;
  masOfZifr[4,6] := 4;

  masOfImages[4,7].Picture.LoadFromFile(dir + '4.3.bmp');
  masOfImages[4,7].Tag := 43;
  masOfZifr[4,7] := 4;

  masOfImages[1,7].Picture.LoadFromFile(dir + '9.3.bmp');
  masOfImages[1,7].Tag := 93;
  masOfZifr[1,7] := 9;

  masOfImages[2,7].Picture.LoadFromFile(dir + '9.2.bmp');
  masOfImages[2,7].Tag := 92;
  masOfZifr[2,7] := 9;

  masOfImages[3,7].Picture.LoadFromFile(dir + '9.1.bmp');
  masOfImages[3,7].Tag := 91;
  masOfZifr[3,7] := 9;

  initialValues;
end;

//событие на нажатие мыши
procedure TgameForm.MD(Sender: TObject; Button: TMouseButton;
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
    if (curJ > 1) and (curJ < 7) and (curI > 1) and (curI < 4) then
    begin //если самая середина
      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI, curJ - 1].Tag.ToString[1])) then
        horizontal := true;

      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1, curJ].Tag.ToString[1])) then
        vertical := true;
    end
    else if (curJ = 1) and (curI <> 1) and (curI <> 4) then
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
    else if (curJ = 1) and (curI = 4) then
    begin //если левый нижний
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1]) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curJ = 7) and (curI <> 1) and (curI <> 4) then
    begin //если правая стена
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ - 1].Tag.ToString[1]) then
        horizontal := true;

      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1, curJ].Tag.ToString[1])) then
        vertical := true;
    end
    else if (curJ = 7) and (curI = 1) then
    begin //если правый верхний
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ - 1].Tag.ToString[1]) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curJ = 7) and (curI = 4) then
    begin //если правый нижний
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ - 1].Tag.ToString[1]) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curI = 1) and (curJ <> 1) and (curJ <> 7) then
    begin //если верхняя стена
      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI, curJ - 1].Tag.ToString[1])) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curI = 4) and (curJ <> 1) and (curJ <> 7) then
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
procedure TgameForm.MU(Sender: TObject; Button: TMouseButton;
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
    else if (ZCH) and (masOfImages[curI, curJ + 3].Tag = 0) then
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
    else if (PCH) and (masOfImages[curI, curJ + 3].Tag = 0) then
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
    else if (ZCH) and (masOfImages[curI, curJ - 1].Tag = 0) then
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
    else if (SCH) and (masOfImages[curI, curJ - 2].Tag = 0) then
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
    else if (ZCH) and (masOfImages[curI, curJ - 3].Tag = 0) then
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
    else if (PCH) and (masOfImages[curI, curJ - 3].Tag = 0) then
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
    else if (ZCH) and (masOfImages[curI + 3, curJ].Tag = 0) then
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
    else if (PCH) and (masOfImages[curI + 3, curJ].Tag = 0) then
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
    if (PCH) and (masOfImages[curI - 1, curJ].Tag = 0) then
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
    else if (ZCH) and (masOfImages[curI - 1, curJ].Tag = 0) then
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
    else if (SCH) and (masOfImages[curI - 2, curJ].Tag = 0) then
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
    else if (ZCH) and (masOfImages[curI - 3, curJ].Tag = 0) then
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
    else if (PCH) and (masOfImages[curI - 3, curJ].Tag = 0) then
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
  if win then
  begin
    ShowMessage('Вы выиграли');
    disableAll;
    //создание кнопки выезда
    exitButton := TButton.Create(gameForm);
    exitButton.Parent := gameForm;
    exitButton.Width := 40;
    exitButton.Height := 40;
    exitButton.Left := 320;
    exitButton.Top := 320;
    exitButton.Caption := 'Выезд';
    exitButton.OnClick := exitClick;
  end;

  horizontal := false;
  vertical := false; 

  ZCH := false;
  PCH := false;
  SCH := false;
end;
//неактивные картинки
procedure TgameForm.disableAll;
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
//проверка на выигрыш
function TGameForm.win;
begin
  if masOfZifr[exitI, exitJ] = 9 then
    result := true
  else
    result := false;
end;
//красивый выезд со двора
procedure TGameForm.exitClick;
begin
  case exitCounter of
    0:
    begin
      masOfExitImages[1,1].Picture.LoadFromFile(dir + '9.1.bmp');
      masOfImages[exitI,exitJ].Picture.LoadFromFile(dir + '9.2.bmp');
      masOfImages[exitI - 1,exitJ].Picture.LoadFromFile(dir + '9.3.bmp');
      masOfImages[exitI - 2,exitJ].picture.LoadFromFile(dir + '0.bmp');

      exitCounter := exitCounter + 1;
    end;
    1:
    begin
       masOfExitImages[2,1].Picture.LoadFromFile(dir + '9.1.bmp');
      masOfExitImages[1,1].Picture.LoadFromFile(dir + '9.2.bmp');
      masOfImages[exitI,exitJ].picture.LoadFromFile(dir + '9.3.bmp');
      masOfImages[exitI - 1,exitJ].Picture.LoadFromFile(dir + '0.bmp');

      exitCounter := exitCounter + 1;
    end;
    2:
    begin
      masOfExitImages[2,1].Picture.LoadFromFile(dir + '9.2.bmp');
      masOfExitImages[1,1].Picture.LoadFromFile(dir + '9.3.bmp');
      masOfImages[exitI,exitJ].picture.LoadFromFile(dir + '0.bmp');

      exitCounter := exitCounter + 1;
    end;
    3:
    begin
      masOfExitImages[2,1].Picture.LoadFromFile(dir + '9.3.bmp');
      masOfExitImages[1,1].Picture.LoadFromFile(dir + '0.bmp');

      exitCounter := exitCounter + 1;
    end;
    4:
    begin
      masOfExitImages[2,1].Picture.LoadFromFile(dir + '0.bmp');
      ShowMessage('Нажмите ок, и вы перейдете на след уровень');

      gameForm.Close;
      gameForm2.Show;

    end;
  end;
end;

procedure TGameForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

end.
