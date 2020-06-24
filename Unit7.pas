unit Unit7;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TsandBoxForm = class(TForm)
    bgSandBoxForm: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure changeWidth(Sender: TObject);
    procedure changeHeight(Sender: TObject);
    procedure createPole(Sender: TObject);
    procedure changeCovering(Sender: TObject);
    procedure fillCovering(Sender: TObject);
    procedure changeCar(Sender: TObject);
    procedure rotateCar(Sender: TObject);
    procedure MC(Sender: TObject);
    procedure MC2(Sender: TObject);
    procedure erase(Sender: TObject);
    procedure nextStep(Sender: TObject);
    function setTaxi:boolean;
    procedure changeDecor(Sender: TObject);
    procedure createLevel(Sender: TObject);
    procedure MD(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MU(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    procedure approveCoordinats(Sender: TObject);
    procedure approveCoordinatsStar(Sender: TObject);
    function win(indexI, indexJ: integer):boolean;
    function star(indexI2, indexJ2: integer):boolean;
    function setStar:boolean;
  end;

const
dir = '..\..\images\sandbox\';

var
  sandBoxForm: TsandBoxForm;
  labelWidth, labelHeight, labelCovering, labelCar, labelDecor: TLabel;
  boxWidth, boxHeight, boxCovering, boxCar, boxDecor: TComboBox;
  createPoleBtn, fillCoveringBtn, rotateCarBtn, fillCarBtn, nextStepBtn,
  createLevelBtn, approveCoordinatsBtn, approveCoordinatsStarBtn: TButton;
  eraseBtn: TBitBtn;
  exitEdit, starEdit: TEdit;
  n, m: integer;
  setWidth, setHeight, setCovering, setCar, horizontal, vertical, SCH, PCH, ZCH :boolean;
  masOfImages: array of array of Timage;
  masOfZifr: array of array of integer;
  masOfPreview: array[1..3,1..3] of TImage;
  curCover: string;
  curI, curJ, curNumber, rotateCounter, eraseCounter, exitI, exitJ, starI, starJ: integer;

implementation

{$R *.dfm}

Uses Unit2, Unit3, Unit4, Unit5, Unit6, Unit1;

procedure TsandBoxForm.FormCreate(Sender: TObject);
var i: integer;
begin
  labelWidth := TLabel.Create(sandBoxForm);
  labelWidth.Parent := sandBoxForm;
  labelWidth.Font.Size := 20;
  labelWidth.Caption := 'Set width';
  labelWidth.Transparent := true;
  labelWidth.Top := 100;
  labelWidth.Left := 100;

  labelHeight := TLabel.Create(sandBoxForm);
  labelHeight.Parent := sandBoxForm;
  labelHeight.Font.Size := 20;
  labelHeight.Caption := 'Set height';
  labelHeight.Transparent := true;
  labelHeight.Top := 100;
  labelHeight.Left := 300;

  boxWidth := TComboBox.Create(sandBoxForm);
  boxWidth.Parent := sandBoxForm;
  boxWidth.Top := 200;
  boxWidth.Left := 100;
  for i := 1 to 10 do
  begin
    boxWidth.Items.Add(IntToStr(i));
  end;
  boxwidth.Text := 'Choose';
  boxWidth.OnChange := changeWidth;

  boxHeight := TComboBox.Create(sandBoxForm);
  boxHeight.Parent := sandBoxForm;
  boxHeight.Top := 200;
  boxHeight.Left := 300;
  for i := 1 to 10 do
  begin
    boxHeight.Items.Add(IntToStr(i));
  end;
  boxHeight.Text := 'Choose';
  boxHeight.OnChange := changeHeight;

  createPoleBtn := TButton.Create(sandBoxForm);
  createPoleBtn.Parent := sandBoxForm;
  createPoleBtn.Width := 200;
  createPoleBtn.Height := 50;
  createPoleBtn.Font.Size := 20;
  createPoleBtn.Caption := 'Create pole';
  createPoleBtn.Top := 300;
  createPoleBtn.Left := 150;
  createPoleBtn.Enabled := false;
  createPoleBtn.OnClick := createPole;
end;

procedure TsandBoxForm.changeWidth(Sender: TObject);
begin
  setWidth := true;
  n := StrToInt(boxWidth.Text);

  if setWidth and setHeight then
  begin
    createPoleBtn.Enabled := true;
  end;
end;

procedure TsandBoxForm.changeHeight(Sender: TObject);
begin
  setHeight := true;
  m := StrToInt(boxHeight.Text);

  if setWidth and setHeight then
  begin
    createPoleBtn.Enabled := true;
  end;
end;

procedure TsandBoxForm.createPole(Sender: TObject);
var i, j: integer;
begin
  labelWidth.Destroy;
  labelHeight.Destroy;
  boxWidth.Destroy;
  boxHeight.Destroy;
  createPoleBtn.Destroy;

  SetLength(masOfImages, m, n);
  SetLength(masOfZifr, m, n);

  for i := 0 to m - 1 do
  begin
    for j := 0 to n - 1 do
    begin
      masOfImages[i,j] := TImage.Create(sandBoxForm);
      masOfImages[i,j].Parent := sandBoxForm;
      masOfImages[i,j].Width := 40;
      masOfImages[i,j].Height := 40;
      masOfImages[i,j].Stretch := true;
      masOfImages[i,j].Top := 10 + i * 40;
      masOfImages[i,j].Left := 10 + j * 40;
      masOfImages[i,j].Picture.LoadFromFile(dir + '0.bmp');
      masOfImages[i,j].Tag := 0;
      masOfImages[i,j].OnClick := MC;

      masOfZifr[i,j] := 0;
    end;
  end;

  labelCovering := TLabel.Create(sandBoxForm);
  labelCovering.Parent := sandBoxForm;
  labelCovering.Font.Size := 20;
  labelCovering.Caption := '1) Set covering';
  labelCovering.Transparent := true;
  labelCovering.Top := 50;
  labelCovering.Left := (n + 1) * 40;

  boxCovering := TComboBox.Create(sandBoxForm);
  boxCovering.Parent := sandBoxForm;
  boxCovering.Top := 120;
  boxCovering.Left := (n + 1) * 40;
  boxCovering.Items.Add('Gray');
  boxCovering.Items.Add('Plaid');
  boxCovering.Items.Add('Purple');
  boxCovering.Text := 'Choose';
  boxCovering.OnChange := changeCovering;

  fillCoveringBtn := TButton.Create(sandBoxForm);
  fillCoveringBtn.Parent := sandBoxForm;
  fillCoveringBtn.Width := 100;
  fillCoveringBtn.Height := 50;
  fillCoveringBtn.Font.Size := 20;
  fillCoveringBtn.Caption := 'Fill';
  fillCoveringBtn.Top := (m + 1) * 40;
  fillCoveringBtn.Left := (n + 1) * 40;
  fillCoveringBtn.Enabled := false;
  fillCoveringBtn.OnClick := fillCovering;
end;

procedure TsandBoxForm.changeCovering(Sender: TObject);
var i,j: integer;
str: string;
begin
  if boxCovering.Text = 'Gray' then
  begin
    str := '0s.bmp';
    curCover := 's';
  end
  else if boxCovering.Text = 'Plaid' then
  begin
    str := '0b.bmp';
    curCover := 'b';
  end
  else if boxCovering.Text = 'Purple' then
  begin
    str := '0f.bmp';
    curCover := 'f';
  end;
  for i := 0 to m - 1 do
  begin
    for j := 0 to n - 1 do
    begin
      masOfImages[i,j].Picture.LoadFromFile(dir + str);
    end;
  end;

  setCovering := true;

  if setCovering then
  begin
    fillCoveringBtn.Enabled := true;
  end;
end;

procedure TsandBoxForm.fillCovering(Sender: TObject);
var i, j: integer;
begin
  labelCovering.Destroy;
  boxCovering.Destroy;
  fillCoveringBtn.Destroy;

  labelCar := TLabel.Create(sandBoxForm);
  labelCar.Parent := sandBoxForm;
  labelCar.Font.Size := 20;
  labelCar.Caption := '2) Set cars';
  labelCar.Transparent := true;
  labelCar.Top := 50;
  labelCar.Left := (n + 1) * 40;

  boxCar := TComboBox.Create(sandBoxForm);
  boxCar.Parent := sandBoxForm;
  boxCar.Top := 120;
  boxCar.Left := (n + 1) * 40;
  boxCar.Items.Add('Police');
  boxCar.Items.Add('Blue');
  boxCar.Items.Add('Red');
  boxCar.Items.Add('Purple');
  boxCar.Items.Add('Gray');
  boxCar.Items.Add('Brown');
  boxCar.Items.Add('Violet');
  boxCar.Items.Add('Yellow');
  boxCar.Items.Add('Truck');
  boxCar.Items.Add('Taxi');
  boxCar.Text := 'Choose';
  boxCar.OnChange := changeCar;

  rotateCarBtn := TButton.Create(sandBoxForm);
  rotateCarBtn.Parent := sandBoxForm;
  rotateCarBtn.Width := 100;
  rotateCarBtn.Height := 50;
  rotateCarBtn.Font.Size := 20;
  rotateCarBtn.Caption := 'Rotate';
  rotateCarBtn.Top := 220;
  rotateCarBtn.Left := (n + 1) * 40;
  rotateCarBtn.OnClick := rotateCar;

  nextStepBtn := TButton.Create(sandBoxForm);
  nextStepBtn.Parent := sandBoxForm;
  nextStepBtn.Width := 150;
  nextStepBtn.Height := 60;
  nextStepBtn.Font.Size := 20;
  nextStepBtn.Caption := 'Next Step';
  nextStepBtn.Top := (m + 1) * 40;
  nextStepBtn.Left := (n - 4) * 40;
  nextStepBtn.OnClick := nextStep;

  eraseBtn := TBitBtn.Create(sandBoxForm);
  eraseBtn.Parent := sandBoxForm;
  eraseBtn.Width := 150;
  eraseBtn.Height := 50;
  eraseBtn.Font.Size := 20;
  eraseBtn.Caption := 'Erase';
  eraseBtn.Top := 410;
  eraseBtn.Left := (n + 1) * 40;
  eraseBtn.OnClick := erase;
  eraseBtn.Glyph.LoadFromFile(dir + 'off.bmp');

  for i := 1 to 3 do
  begin
    for j := 1 to 3 do
    begin
      masOfPreview[i,j] := TImage.Create(sandBoxForm);
      masOfPreview[i,j].Parent := sandBoxForm;
      masOfPreview[i,j].Width := 40;
      masOfPreview[i,j].Height := 40;
      masOfPreview[i,j].Stretch := true;
      masOfPreview[i,j].Top := 240 + i * 40;
      masOfPreview[i,j].Left := n * 40 + j * 40;
      masOfPreview[i,j].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
    end;
  end;
end;

procedure TsandBoxForm.changeCar(Sender: TObject);
var i, j, k: integer;
begin
  rotateCounter := 1;
  vertical := true;
  horizontal := false;
  eraseCounter := 1;

  if boxCar.Text = 'Police' then
  begin
    curNumber := 1;
  end
  else if boxCar.Text = 'Blue' then
  begin
    curNumber := 2;
  end
  else if boxCar.Text = 'Red' then
  begin
    curNumber := 3;
  end
  else if boxCar.Text = 'Purple' then
  begin
    curNumber := 4;
  end
  else if boxCar.Text = 'Gray' then
  begin
    curNumber := 5;
  end
  else if boxCar.Text = 'Brown' then
  begin
    curNumber := 6;
  end
  else if boxCar.Text = 'Violet' then
  begin
    curNumber := 7;
  end
  else if boxCar.Text = 'Yellow' then
  begin
    curNumber := 8;
  end
  else if boxCar.Text = 'Truck' then
  begin
    curNumber := 12;
  end
  else if boxCar.Text = 'Taxi' then
  begin
    curNumber := 9;
  end;

  for j := 1 to 3 do
  begin
    for k := 1 to 3 do
    begin
      masOfPreview[j,k].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
    end;
  end;

  for i := 1 to 3 do
  begin
    masOfPreview[i,2].Picture.LoadFromFile(dir + curCover + '\' +
    IntToStr(curNumber) + '.' + IntToStr(i) + 't.bmp');
  end;
end;

procedure TsandBoxForm.rotateCar(Sender: TObject);
var i, j, k: integer;
begin
  for j := 1 to 3 do
  begin
    for k := 1 to 3 do
    begin
      masOfPreview[j,k].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
    end;
  end;

  case rotateCounter of
    1:
    begin
      for i := 1 to 3 do
      begin
        masOfPreview[i,2].Picture.LoadFromFile(dir + curCover + '\' +
        IntToStr(curNumber) + '.' + IntToStr(i) + 't.bmp');
      end;

      rotateCounter := rotateCounter + 1;
      vertical := true;
      horizontal := false;
    end;
    2:
    begin
      for i := 3 downto 1 do
      begin
        masOfPreview[2,i].Picture.LoadFromFile(dir + curCover + '\' +
        IntToStr(curNumber) + '.' + IntToStr(4 - i) + 'r.bmp');
      end;

      rotateCounter := rotateCounter + 1;
      horizontal := true;
      vertical := false;
    end;
    3:
    begin
      for i := 3 downto 1 do
      begin
        masOfPreview[i,2].Picture.LoadFromFile(dir + curCover + '\' +
        IntToStr(curNumber) + '.' + IntToStr(4 - i) + 'b.bmp');
      end;

      rotateCounter := rotateCounter + 1;
      vertical := true;
      horizontal := false;
    end;
    4:
    begin
      for i := 1 to 3 do
      begin
        masOfPreview[2,i].Picture.LoadFromFile(dir + curCover + '\' +
        IntToStr(curNumber) + '.' + IntToStr(i) + 'l.bmp');
      end;

      rotateCounter := 1;
      horizontal := true;
      vertical := false;
    end;
  end;
end;

procedure TsandBoxForm.erase(Sender: TObject);
var i, j: integer;
begin
  if eraseCounter = 1 then
  begin
    for i := 0 to m - 1 do
    begin
      for j := 0 to n - 1 do
      begin
        masOfImages[i,j].OnClick := MC2;
      end;
    end;
    eraseBtn.Glyph.LoadFromFile(dir + 'on.bmp');
    eraseCounter := 2;
  end
  else if eraseCounter = 2 then
  begin
    for i := 0 to m - 1 do
    begin
      for j := 0 to n - 1 do
      begin
        masOfImages[i,j].OnClick := MC;
      end;
    end;
    eraseBtn.Glyph.LoadFromFile(dir + 'off.bmp');
    eraseCounter := 1;
  end;
end;
//проверка поставил ли человек такси
function TsandBoxForm.setTaxi;
var i, j:integer;
isSet: boolean;
begin
  isSet := false;

  for i := 0 to m - 1 do
  begin
    for j := 0 to n - 1 do
    begin
      if masOfZifr[i][j] = 9 then
      begin
        isSet := true;
        break;
      end;
    end;
  end;

  if isSet then
  begin
    result := true;
  end
  else
  begin
    result := false;
  end;
end;
//проверка поставил ли человек звезду
function TsandBoxForm.setStar;
var i, j:integer;
isSet: boolean;
begin
  isSet := false;

  for i := 0 to m - 1 do
  begin
    for j := 0 to n - 1 do
    begin
      if masOfZifr[i][j] = -2 then
      begin
        isSet := true;
        break;
      end;
    end;
  end;

  if isSet then
  begin
    result := true;
  end
  else
  begin
    result := false;
  end;
end;

procedure TsandBoxForm.nextStep(Sender: TObject);
var i, j: integer;
begin
  if setTaxi then
  begin
    labelCar.Destroy;
    boxCar.Destroy;
    rotateCarBtn.Destroy;

    labelDecor := TLabel.Create(sandBoxForm);
    labelDecor.Parent := sandBoxForm;
    labelDecor.Font.Size := 20;
    labelDecor.Caption := '3) Set decor';
    labelDecor.Transparent := true;
    labelDecor.Top := 50;
    labelDecor.Left := (n + 1) * 40;

    boxDecor := TComboBox.Create(sandBoxForm);
    boxDecor.Parent := sandBoxForm;
    boxDecor.Top := 120;
    boxDecor.Left := (n + 1) * 40;
    boxDecor.Items.Add('Box');
    boxDecor.Items.Add('Star');
    boxDecor.Text := 'Choose';
    boxDecor.OnChange := changeDecor;

    for i := 1 to 3 do
    begin
      for j := 1 to 3 do
      begin
        masOfPreview[i,j].Destroy;
      end;
    end;

    nextStepBtn.Destroy;

    createLevelBtn := TButton.Create(sandBoxForm);
    createLevelBtn.Parent := sandBoxForm;
    createLevelBtn.Width := 160;
    createLevelBtn.Height := 50;
    createLevelBtn.Font.Size := 20;
    createLevelBtn.Caption := 'Create level';
    createLevelBtn.Top := (m + 1) * 40;
    createLevelBtn.Left := (n - 4) * 40;
    createLevelBtn.OnClick := createLevel;

    eraseBtn.Top := (m + 1) * 40;
  end
  else
  begin
    showMessage('Поставьте такси');
  end;
end;
procedure TsandBoxForm.changeDecor(Sender: TObject);
begin
  if boxDecor.Text = 'Box' then
  begin
    curNumber := -1;
  end
  else if boxDecor.Text = 'Star' then
  begin
    curNumber := -2;
  end;
end;

procedure TsandBoxForm.MC(Sender: TObject);
var i, j, k, z: integer;
insert: boolean;
begin
  for i := 0 to m - 1 do
  begin
    for j := 0 to n - 1 do
    begin
      if masOfImages[i,j] = Sender then
      begin
        curI := i;
        curJ := j;
      end;
    end;
  end;

  if (curNumber <> -1) and (curNumber <> -2) then
  begin
    insert := true;

    if (horizontal) and (curJ <> 0) and (curJ <> n - 1) then
    begin
      for z := 1 to 3 do
      begin
        for k := 1 to 3 do
        begin
          if masOfZifr[curI,curJ - 2 + k] <> 0 then
          begin
            insert := false;
            break;
          end;
        end;
      end;

      if insert then
      begin
        if rotateCounter = 3 then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI,curJ - 2 + k].Picture.LoadFromFile(dir + curCover + '\' +
            IntToStr(curNumber) + '.' + IntToStr(4 - k) + 'r.bmp');

            masOfImages[curI, curJ - 2 + k].Tag := curNumber * 10 + (4 - k);
            masOfZifr[curI, curJ - 2 + k] := curNumber;
          end;
        end
        else if rotateCounter = 1 then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI,curJ - 2 + k].Picture.LoadFromFile(dir + curCover + '\' +
            IntToStr(curNumber) + '.' + IntToStr(k) + 'l.bmp');

            masOfImages[curI, curJ - 2 + k].Tag := curNumber * 10 + k;
            masOfZifr[curI, curJ - 2 + k] := curNumber;
          end;
        end;
      end;
    end;
    if (vertical) and (curI <> 0) and (curI <> m - 1) then
    begin
      for z := 1 to 3 do
      begin
        for k := 1 to 3 do
        begin
          if masOfZifr[curI - 2 + k,curJ] <> 0 then
          begin
            insert := false;
            break;
          end;
        end;
      end;

      if insert then
      begin
        if rotateCounter = 2 then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI - 2 + k,curJ].Picture.LoadFromFile(dir + curCover + '\' +
            IntToStr(curNumber) + '.' + IntToStr(k) + 't.bmp');

            masOfImages[curI - 2 + k, curJ].Tag := curNumber * 10 + k;
            masOfZifr[curI - 2 + k, curJ] := curNumber;
          end;
        end
        else if rotateCounter = 4 then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI - 2 + k,curJ].Picture.LoadFromFile(dir + curCover + '\' +
            IntToStr(curNumber) + '.' + IntToStr(4 - k) + 'b.bmp');

            masOfImages[curI - 2 + k, curJ].Tag := curNumber * 10 + (4 - k);
            masOfZifr[curI - 2 + k, curJ] := curNumber;
          end;
        end;
      end;
    end;

    if (setTaxi) and (boxCar.Items.Count = 10) then
    begin
      boxCar.Items.Delete(9);
      boxCar.Text := 'Choose';
      curNumber := 0;
    end;
  end
  else
  begin
    if masOfZifr[curI, curJ] = 0 then
    begin
      masOfImages[curI, curJ].Picture.LoadFromFile(dir + curCover + '\' +
      IntToStr(curNumber) + '.bmp');

      masOfImages[curI, curJ].Tag := curNumber;
      masOfZifr[curI, curJ] := curNumber;

      if (setStar) and (boxDecor.Items.Count = 2) then
      begin
        boxDecor.Items.Delete(1);
        boxDecor.Text := 'Choose';
        curNumber := 0;
      end;
    end;
  end;
end;
procedure TsandBoxForm.MC2(Sender: TObject);
var i, j: integer;
begin
  for i := 0 to m - 1 do
  begin
    for j := 0 to n - 1 do
    begin
      if masOfImages[i,j] = Sender then
      begin
        curI := i;
        curJ := j;
      end;
    end;
  end;

  masOfImages[curI, curJ].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
  masOfImages[curI, curJ].Tag := 0;
  masOfZifr[curI, curJ] := 0;
end;
procedure TsandBoxForm.approveCoordinats(Sender: TObject);
var s1, s2: string;
l, i, indProb: integer;
begin
  s1 := exitEdit.Text;
  s2 := s1;
  l := Length(s1);
  indProb := 0;

  if l >= 3 then
  begin
    for i := 0 to l do
    begin
      if s1[i] = ' ' then
      begin
        indProb := i;
        break;
      end;
    end;
  end;
  Delete(s1, indProb, l - indProb + 1);
  exitI := StrToInt(s1) - 1;
  Delete(s2, 1, indProb);
  exitJ := StrToInt(s2) - 1;

  exitEdit.Destroy;
  approveCoordinatsBtn.Destroy;
end;

procedure TsandBoxForm.approveCoordinatsStar(Sender: TObject);
var s1, s2: string;
l, i, indProb: integer;
begin
  s1 := starEdit.Text;
  s2 := s1;
  l := Length(s1);
  indProb := 0;

  if l >= 3 then
  begin
    for i := 0 to l do
    begin
      if s1[i] = ' ' then
      begin
        indProb := i;
        break;
      end;
    end;
  end;
  Delete(s1, indProb, l - indProb + 1);
  starI := StrToInt(s1) - 1;
  Delete(s2, 1, indProb);
  starJ := StrToInt(s2) - 1;

  starEdit.Destroy;
  approveCoordinatsStarBtn.Destroy;
end;

procedure TsandBoxForm.createLevel(Sender: TObject);
var i, j: integer;
begin
  labelDecor.Destroy;
  boxDecor.Destroy;
  eraseBtn.Destroy;
  createLevelBtn.Destroy;
  
  if setTaxi then
  begin
    exitEdit := TEdit.Create(sandBoxForm);
    exitEdit.Parent := sandBoxForm;
    exitEdit.Width := 100;
    exitEdit.Height := 30;
    exitEdit.Font.Size := 12;
    exitEdit.Text := 'Index Exit';
    exitEdit.Top := 50;
    exitEdit.Left := (n + 1) * 40;

    approveCoordinatsBtn := TButton.Create(sandBoxForm);
    approveCoordinatsBtn.Parent := sandBoxForm;
    approveCoordinatsBtn.Width := 130;
    approveCoordinatsBtn.Height := 60;
    approveCoordinatsBtn.Font.Size := 20;
    approveCoordinatsBtn.Caption := 'Approve';
    approveCoordinatsBtn.Top := 80;
    approveCoordinatsBtn.Left := (n + 1) * 40;
    approveCoordinatsBtn.OnClick := approveCoordinats;
  end;
  
  if setStar then
  begin
    starEdit := TEdit.Create(sandBoxForm);
    starEdit.Parent := sandBoxForm;
    starEdit.Width := 100;
    starEdit.Height := 30;
    starEdit.Font.Size := 12;
    starEdit.Text := 'Index Star';
    starEdit.Top := 150;
    starEdit.Left := (n + 1) * 40;

    approveCoordinatsStarBtn := TButton.Create(sandBoxForm);
    approveCoordinatsStarBtn.Parent := sandBoxForm;
    approveCoordinatsStarBtn.Width := 130;
    approveCoordinatsStarBtn.Height := 60;
    approveCoordinatsStarBtn.Font.Size := 20;
    approveCoordinatsStarBtn.Caption := 'Approve';
    approveCoordinatsStarBtn.Top := 180;
    approveCoordinatsStarBtn.Left := (n + 1) * 40;
    approveCoordinatsStarBtn.OnClick := approveCoordinatsStar;
  end;

  for i := 0 to m - 1 do
  begin
    for j := 0 to n - 1 do
    begin
      masOfImages[i][j].OnClick := nil;
      masOfImages[i][j].OnMouseDown := MD;
      masOfImages[i][j].OnMouseUp := MU;
    end;
  end;
end;

//событие на нажатие мыши
procedure TSandBoxForm.MD(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i, j: integer;
begin
  for i := 0 to m - 1 do
  begin
    for j := 0 to n - 1 do
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
    if (curJ > 0) and (curJ < n - 1) and (curI > 0) and (curI < m - 1) then
    begin //если самая середина
      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI, curJ - 1].Tag.ToString[1])) then
        horizontal := true;

      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1, curJ].Tag.ToString[1])) then
        vertical := true;
    end
    else if (curJ = 0) and (curI <> 0) and (curI <> m - 1) then
    begin //если левая стена
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1]) then
        horizontal := true;

      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1, curJ].Tag.ToString[1])) then
        vertical := true;
    end
    else if (curJ = 0) and (curI = 0) then
    begin //если левый верхний
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1]) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curJ = 0) and (curI = m - 1) then
    begin //если левый нижний
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1]) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curJ = n - 1) and (curI <> 0) and (curI <> m - 1) then
    begin //если правая стена
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ - 1].Tag.ToString[1]) then
        horizontal := true;

      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1, curJ].Tag.ToString[1])) then
        vertical := true;
    end
    else if (curJ = n - 1) and (curI = 0) then
    begin //если правый верхний
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ - 1].Tag.ToString[1]) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curJ = n - 1) and (curI = m - 1) then
    begin //если правый нижний
      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ - 1].Tag.ToString[1]) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI - 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curI = 0) and (curJ <> 0) and (curJ <> n - 1) then
    begin //если верхняя стена
      if ((masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI,curJ + 1].Tag.ToString[1])
      or (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI, curJ - 1].Tag.ToString[1])) then
        horizontal := true;

      if (masOfImages[curI, curJ].Tag.ToString[1] = masOfImages[curI + 1,curJ].Tag.ToString[1]) then
        vertical := true;
    end
    else if (curI = m - 1) and (curJ <> 0) and (curJ <> n - 1) then
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
procedure TSandBoxForm.MU(Sender: TObject; Button: TMouseButton;
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
          break;
        end;
      end;
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ + numOfKl + 1 - k].picture.LoadFromFile(dir + curCover + '\'
          + str + '.' + IntToStr(k) + 'r.bmp');


          masOfImages[curI, curJ + numOfKl + 1 - k].Tag := masOfImages[curI, curJ + 1 - k].Tag;
          masOfZifr[curI, curJ + numOfKl + 1 - k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ + numOfKl - 2 - b].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ + numOfKl + 1 - k].picture.LoadFromFile(dir + curCover + '\'
          + str + '.' + IntToStr(4 - k) + 'l.bmp');


          masOfImages[curI, curJ + numOfKl + 1 - k].Tag := masOfImages[curI, curJ + 1 - k].Tag;
          masOfZifr[curI, curJ + numOfKl + 1 - k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ + numOfKl - 2 - b].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
        //label3.Caption := BoolToStr(Move);
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI, curJ + numOfKl + 2 - k].picture.LoadFromFile(dir + curCover + '\'
            + str + '.' + IntToStr(k) + 'r.bmp');


            masOfImages[curI, curJ + numOfKl + 2 - k].Tag := masOfImages[curI, curJ + 2 - k].Tag;
            masOfZifr[curI, curJ + numOfKl + 2 - k] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI, curJ + numOfKl - 1 - b].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
        //label3.Caption := BoolToStr(Move);
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI, curJ + numOfKl + 2 - k].picture.LoadFromFile(dir + curCover + '\' +
            str + '.' + IntToStr(4 - k) + 'l.bmp');


            masOfImages[curI, curJ + numOfKl + 2 - k].Tag := masOfImages[curI, curJ + 2 - k].Tag;
            masOfZifr[curI, curJ + numOfKl + 2 - k] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI, curJ + numOfKl - 1 - b].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ + numOfKl + 3 - k].picture.LoadFromFile(dir + curCover + '\' +
          str + '.' + IntToStr(k) + 'r.bmp');


          masOfImages[curI, curJ + numOfKl + 3 - k].Tag := masOfImages[curI, curJ + 3 - k].Tag;
          masOfZifr[curI, curJ + numOfKl + 3 - k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ + numOfKl - b].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ + numOfKl + 3 - k].picture.LoadFromFile(dir + curCover + '\' +
          str + '.' + IntToStr(4 - k) + 'l.bmp');


          masOfImages[curI, curJ + numOfKl + 3 - k].Tag := masOfImages[curI, curJ + 3 - k].Tag;
          masOfZifr[curI, curJ + numOfKl + 3 - k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ + numOfKl - b].Picture.LoadFromFile(dir + '0' + curCover+ '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ - numOfKl - 1 + k].picture.LoadFromFile(dir + curCover + '\' +
          str + '.' + IntToStr(k) + 'l.bmp');


          masOfImages[curI, curJ - numOfKl - 1 + k].Tag := masOfImages[curI, curJ - 1 + k].Tag;
          masOfZifr[curI, curJ - numOfKl - 1 + k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ - numOfKl + 2 + b].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ - numOfKl - 1 + k].picture.LoadFromFile(dir + curCover + '\' +
          str + '.' + IntToStr(4 - k) + 'r.bmp');


          masOfImages[curI, curJ - numOfKl - 1 + k].Tag := masOfImages[curI, curJ - 1 + k].Tag;
          masOfZifr[curI, curJ - numOfKl - 1 + k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ - numOfKl + 2 + b].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
        //label3.Caption := BoolToStr(Move);
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI, curJ - numOfKl - 2 + k].picture.LoadFromFile(dir + curCover + '\' +
            str + '.' + IntToStr(k) + 'l.bmp');


            masOfImages[curI, curJ - numOfKl - 2 + k].Tag := masOfImages[curI, curJ - 2 + k].Tag;
            masOfZifr[curI, curJ - numOfKl - 2 + k] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI, curJ - numOfKl + 1 + b].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
        //label3.Caption := BoolToStr(Move);
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI, curJ - numOfKl - 2 + k].picture.LoadFromFile(dir + curCover + '\' +
            str + '.' + IntToStr(4 - k) + 'r.bmp');


            masOfImages[curI, curJ - numOfKl - 2 + k].Tag := masOfImages[curI, curJ - 2 + k].Tag;
            masOfZifr[curI, curJ - numOfKl - 2 + k] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI, curJ - numOfKl + 1 + b].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ - numOfKl - 3 + k].picture.LoadFromFile(dir + curCover + '\' +
          str + '.' + IntToStr(k) + 'l.bmp');


          masOfImages[curI, curJ - numOfKl - 3 + k].Tag := masOfImages[curI, curJ - 3 + k].Tag;
          masOfZifr[curI, curJ - numOfKl - 3 + k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ - numOfKl + b].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI, curJ - numOfKl - 3 + k].picture.LoadFromFile(dir + curCover + '\' +
          str + '.' + IntToStr(4 - k) + 'r.bmp');


          masOfImages[curI, curJ - numOfKl - 3 + k].Tag := masOfImages[curI, curJ - 3 + k].Tag;
          masOfZifr[curI, curJ - numOfKl - 3 + k] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI, curJ - numOfKl + b].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI + numOfKl + 1 - k, curJ].picture.LoadFromFile(dir + curCover + '\' +
          str + '.' + IntToStr(k) + 'b.bmp');


          masOfImages[curI + numOfKl + 1 - k, curJ].Tag := masOfImages[curI + 1 - k, curJ].Tag;
          masOfZifr[curI + numOfKl + 1 - k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI + numOfKl - 2 - b, curJ].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI + numOfKl + 1 - k, curJ].picture.LoadFromFile(dir + curCover + '\' +
          str + '.' + IntToStr(4 - k) + 't.bmp');


          masOfImages[curI + numOfKl + 1 - k, curJ].Tag := masOfImages[curI + 1 - k, curJ].Tag;
          masOfZifr[curI + numOfKl + 1 - k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI + numOfKl - 2 - b, curJ].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
        //label3.Caption := BoolToStr(Move);
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI + numOfKl + 2 - k, curJ].picture.LoadFromFile(dir + curCover + '\' +
            str + '.' + IntToStr(k) + 'b.bmp');


            masOfImages[curI + numOfKl + 2 - k, curJ].Tag := masOfImages[curI + 2 - k, curJ].Tag;
            masOfZifr[curI + numOfKl + 2 - k, curJ] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI + numOfKl - 1 - b, curJ].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
        //label3.Caption := BoolToStr(Move);
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI + numOfKl + 2 - k, curJ].picture.LoadFromFile(dir + curCover + '\' +
            str + '.' + IntToStr(4 - k) + 't.bmp');


            masOfImages[curI + numOfKl + 2 - k, curJ].Tag := masOfImages[curI + 2 - k, curJ].Tag;
            masOfZifr[curI + numOfKl + 2 - k, curJ] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI + numOfKl - 1 - b, curJ].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI + numOfKl + 3 - k, curJ].picture.LoadFromFile(dir + curCover + '\' +
          str + '.' + IntToStr(k) + 'b.bmp');


          masOfImages[curI + numOfKl + 3 - k, curJ].Tag := masOfImages[curI + 3 - k, curJ].Tag;
          masOfZifr[curI + numOfKl + 3 - k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfKl do
        begin
          masOfImages[curI + numOfKl - b, curJ].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI + numOfKl + 3 - k, curJ].picture.LoadFromFile(dir + curCover + '\' +
          str + '.' + IntToStr(4 - k) + 't.bmp');


          masOfImages[curI + numOfKl + 3 - k, curJ].Tag := masOfImages[curI + 3 - k, curJ].Tag;
          masOfZifr[curI + numOfKl + 3 - k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI + numOfKl - b, curJ].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI - numOfKl - 1 + k, curJ].picture.LoadFromFile(dir
            + curCover + '\' + str + '.' + IntToStr(k) + 't.bmp');


          masOfImages[curI - numOfKl - 1 + k, curJ].Tag := masOfImages[curI - 1 + k, curJ].Tag;
          masOfZifr[curI - numOfKl - 1 + k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI - numOfKl + 2 + b, curJ].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI - numOfKl - 1 + k, curJ].picture.LoadFromFile(dir + curCover + '\' +
          str + '.' + IntToStr(4 - k) + 'b.bmp');


          masOfImages[curI - numOfKl - 1 + k, curJ].Tag := masOfImages[curI - 1 + k, curJ].Tag;
          masOfZifr[curI - numOfKl - 1 + k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI - numOfKl + 2 + b, curJ].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
        //label3.Caption := BoolToStr(Move);
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI - numOfKl - 2 + k, curJ].picture.LoadFromFile(dir + curCover + '\' +
            str + '.' + IntToStr(k) + 't.bmp');


            masOfImages[curI - numOfKl - 2 + k, curJ].Tag := masOfImages[curI - 2 + k, curJ].Tag;
            masOfZifr[curI - numOfKl - 2 + k, curJ] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI - numOfKl + 1 + b, curJ].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
        //label3.Caption := BoolToStr(Move);
        if move then
        begin
          for k := 1 to 3 do
          begin
            masOfImages[curI - numOfKl - 2 + k, curJ].picture.LoadFromFile(dir + curCover + '\' +
            str + '.' + IntToStr(4 - k) + 'b.bmp');


            masOfImages[curI - numOfKl - 2 + k, curJ].Tag := masOfImages[curI - 2 + k, curJ].Tag;
            masOfZifr[curI - numOfKl - 2 + k, curJ] := masOfZifr[curI, curJ];
          end;
          for b := 1 to numOfKl do
          begin
            masOfImages[curI - numOfKl + 1 + b, curJ].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI - numOfKl - 3 + k, curJ].picture.LoadFromFile(dir + curCover + '\' +
          str + '.' + IntToStr(k) + 't.bmp');


          masOfImages[curI - numOfKl - 3 + k, curJ].Tag := masOfImages[curI - 3 + k, curJ].Tag;
          masOfZifr[curI - numOfKl - 3 + k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI - numOfKl + b, curJ].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
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
      //label3.Caption := BoolToStr(Move);
      if move then
      begin
        for k := 1 to 3 do
        begin
          masOfImages[curI - numOfKl - 3 + k, curJ].picture.LoadFromFile(dir + curCover + '\' +
          str + '.' + IntToStr(4 - k) + 'b.bmp');


          masOfImages[curI - numOfKl - 3 + k, curJ].Tag := masOfImages[curI - 3 + k, curJ].Tag;
          masOfZifr[curI - numOfKl - 3 + k, curJ] := masOfZifr[curI, curJ];
        end;
        for b := 1 to numOfkl do
        begin
          masOfImages[curI - numOfKl + b, curJ].Picture.LoadFromFile(dir + '0' + curCover + '.bmp');
          masOfImages[curI - numOfKl + b, curJ].Tag := 0;
          masOfZifr[curI - numOfKl + b, curJ] := 0;
        end;
      end;
    end;
  end;

  //проверка на выигрыш
  if (win(exitI, exitJ)) and (star(starI, starJ)) then
  begin
    ShowMessage('Вы выиграли');
    sandBoxForm.Close;
    menuForm.Show();
  end
  else if win(exitI, exitJ) then
  begin
    ShowMessage('Вы собрали не все звезды');
  end;


  horizontal := false;
  vertical := false;

  ZCH := false;
  PCH := false;
  SCH := false;
end;

//проверка на выигрыш
function TSandBoxForm.win(indexI, indexJ: integer):boolean;
begin
  if masOfZifr[indexI, indexJ] = 9 then
    result := true
  else
    result := false;
end;

function TSandBoxForm.star(indexI2, indexJ2: integer):boolean;
begin
  if masOfZifr[indexI2, indexJ2] <> -2 then
    result := true
  else
    result := false;
end;
end.
