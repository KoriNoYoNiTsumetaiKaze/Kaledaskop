unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, DXSprite, StdCtrls;

type
  TForm1 = class(TDXForm)
    DXDraw1: TDXDraw;
    DXSpriteEngine1: TDXSpriteEngine;
    DXTimer1: TDXTimer;
    DXImageList1: TDXImageList;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
 TMySprite = class(TImageSpriteEx)
   maxY:integer;//конечно поля не должны быть пубилчными
   typeA:byte;
   KofHA:integer;
   constructor Create(AParent: TSprite); override;
   procedure DoMove(movecount: Integer); override;
 end;

type
 TSrcSprite = class(TImageSprite)
   constructor Create(AParent: TSprite); override;
   procedure DoMove(movecount: Integer); override;
 end;

const ArrLeng   = 4;

var
  Form1: TForm1;
  img:array[1..ArrLeng] of TMySprite;//для простоты статический массив, но если нужно оптимизировать по памяти и под разный экран можно и динамический
  src:TSrcSprite;
  nomA:integer;

implementation

{$R *.DFM}

constructor TMySprite.Create(AParent: TSprite);
begin
  //регистрация в спрайтовом движке
  inherited Create(AParent);
  KofHA:=1;
end;

procedure TMySprite.DoMove(movecount : Integer);
begin
  inherited DoMove(movecount);
  Y:=Y+1;
  if Y>maxY then Y:=-Image.Height;
  if typeA=1 then
   begin
    X:=0;
    Width:=100;
    if Angle=256 then Angle:=0
     else Angle:=Angle+1;
   end
   else
    if typeA=2 then
     begin
      Angle:=0;
      Width:=Width-KofHA-KofHA;
      X:=X+KofHA;
      if Width=0 then KofHA:=-1
       else
        if X=0 then KofHA:=1;
     end
     else
      if typeA=3 then
       begin
        if Angle=256 then Angle:=0
         else Angle:=Angle+1;
        Width:=Width-KofHA-KofHA;
        X:=X+KofHA;
        if Width=0 then KofHA:=-1
         else
          if X=0 then KofHA:=1;
       end;
end;

constructor TSrcSprite.Create(AParent: TSprite);
begin
  //регистрация в спрайтовом движке
  inherited Create(AParent);
end;

procedure TSrcSprite.DoMove(movecount : Integer);
begin
  inherited DoMove(movecount);
end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
Var i,j:integer;
    min:Double;
begin
  if not DxDraw1.CanDraw then exit; // Если нет DirectX выходим
  DXSpriteEngine1.Move(1); // перемещает спрайт
  DXSpriteEngine1.Dead; // Уничтожает...
  DXDraw1.Surface.Fill(0); // Отражает изменения (спрайты и т.д.)
  DXSpriteEngine1.Draw; // Рисует...
  DXDraw1.Flip; // Посылает содержимое Surface экрану
end;

procedure TForm1.FormCreate(Sender: TObject);
Var i,j:integer;
begin
  nomA:=0;
  j:=DXImageList1.Items.Count-1;
  src:=TSrcSprite.Create(DXSpriteEngine1.Engine);
  src.Image:=DXImageList1.Items.Items[j];
  src.Width:=100;
  src.Height:=100;
  src.X:=0;
  src.Y:=0;
  for i:=1 to ArrLeng do
   begin
    img[i]:=TMySprite.Create(DXSpriteEngine1.Engine);
    img[i].Image:=DXImageList1.Items.Items[j];
    img[i].Width:=100;
    img[i].Height:=100;
    img[i].X:=0;
    img[i].Y:=(i-1)*img[i].Height;
    img[i].maxY:=DXDraw1.Height;
    if j=0 then
     j:=DXImageList1.Items.Count-1
     else
      j:=j-1;
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 src.Height:=src.Height-1;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
src.Height:=src.Height+1;
end;

function getImin():integer;
Var i,j:integer;
    min:Double;
 begin
   min:=100000;
   j:=1;
   for i:=1 to ArrLeng do
    begin
     if min>img[i].Y then
      begin
       min:=img[i].Y;
       j:=i;
      end;
    end;
  getImin:=j;
 end;

procedure TForm1.Button3Click(Sender: TObject);
Var j:integer;
begin
 if nomA=0 then
  begin
    j:=getImin();
    img[j].typeA:=1;
    nomA:=j;
  end
  else
   img[nomA].typeA:=1;
end;

procedure TForm1.Button4Click(Sender: TObject);
Var j:integer;
begin
 if nomA=0 then
  begin
    j:=getImin();
    img[j].typeA:=2;
    nomA:=j;
  end
  else
   img[nomA].typeA:=2;
end;

procedure TForm1.Button5Click(Sender: TObject);
Var j:integer;
begin
 if nomA=0 then
  begin
    j:=getImin();
    img[j].typeA:=3;
    nomA:=j;
  end
  else
   img[nomA].typeA:=3;
end;

end.
