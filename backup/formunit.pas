unit formunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, fractal;

type

  { TForm1 }

  TForm1 = class(TForm)
    DepthBarLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    DepthBar: TTrackBar;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    ZoomBar: TTrackBar;
    procedure DepthBarChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure ZoomBarChange(Sender: TObject);
  private
    fr:^mink;
    camera:veci;
    zoomx:integer;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
    new(fr);
    fr^:= mink.con;
    zoomx :=1;
    camera.x:= 0;
    camera.y :=0;
end;

procedure TForm1.DepthBarChange(Sender: TObject);
begin
  fr^.tolevel(depthbar.Position+1);
  formpaint(self);
end;

procedure TForm1.FormPaint(Sender: TObject);
var l:pch;
x,y,nx,ny:integer;
begin
     l:=fr^.head;
     x:=0;
     y:=512;
     // Set the border color
     Canvas.Pen.Color := clBlue;
     Canvas.Pen.Width := 2;
     Canvas.Pen.Style := psSolid;
     Canvas.Fillrect(0,0,1024,1024);
     repeat begin
        nx:= round(x+1024*l^.v.x);ny:=round(y+1024*l^.v.y);
        Canvas.line((x-camera.x*32)*zoomx,(y-camera.y*32)*zoomx,(nx-camera.x*32)*zoomx,(ny-camera.y*32)*zoomx);
        x:=nx;y:=ny;
        l:=l^.next;
     end until l=nil;
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin

end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  camera.x:=trackbar1.position;
  formpaint(self);
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
   camera.y:=trackbar2.position;
  formpaint(self);
end;

procedure TForm1.ZoomBarChange(Sender: TObject);
begin
  zoomx := zoombar.position;
  formpaint(self);
end;

end.

