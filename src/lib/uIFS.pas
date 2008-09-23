(* GPL > 3.0
Copyright (C) 1996-2008 eIrOcA Enrico Croce & Simona Burzio

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)
(*
 @author(Enrico Croce)
*)
unit uIFS;

interface

uses
  SysUtils, Windows, Graphics, uGraph;

type

  TIFS = record
    x0, x1, x2: double;
    y0, y1, y2: double;
    p: double;
  end;

  TIFSGraphic = class(TOffscreenGraphic)
    protected
     xsc, ysc: double;
     XOff, YOff: integer;
     asp:  double;
     prob: array of double;
     color: TColor;
     ox, oy: double;
    protected
     function  FindTran: integer; virtual;
     procedure BuildProb; virtual;
     procedure MakeTran(var nx, ny: double); virtual;
    public
     constructor Create(mx, my: integer);
     procedure Draw(iter: integer);
  end;

  TForestGraphic = class(TIFSGraphic)
    private
     bx, by: double;
    protected
     procedure BuildProb; override;
     procedure MakeTran(var nx, ny: double); override;
    public
     drawForest: boolean;
    public
     constructor Create(mx, my: integer);

  end;

implementation

const

  {holds the IFS for a fern}
  IFS_fern: array[0..3] of TIFS =
   ((x0:  0.00; x1:  0.00; x2:   0.00; y0:  0.00; y1: 0.16; y2:    0.00; p: 0.020),
    (x0:  0.20; x1: -0.26; x2:   0.00; y0:  0.23; y1: 0.22; y2:  -24.00; p: 0.065),
    (x0: -0.15; x1:  0.28; x2:   0.00; y0:  0.26; y1: 0.24; y2:   -6.60; p: 0.065),
    (x0:  0.85; x1:  0.04; x2:   0.00; y0: -0.04; y1: 0.85; y2:  -24.00; p: 0.850));

  {holds additional IFS functions to produce the forest}
  IFS_forest: array[0..1] of TIFS =
   ((x0:  0.80; x1:  0.00; x2:  80.00; y0:  0.00; y1: 0.80; y2:  -65.00; p: 0.500),
    (x0:  0.80; x1:  0.00; x2: -80.00; y0:  0.00; y1: 0.80; y2:  -60.00; p: 0.500));

  IFS_Sierpinski:array[0..2] of TIFS =
   ((x0:  0.50; x1:  0.00; x2:   0.00; y0:  0.00; y1: 0.50; y2:    0.00; p: 0.333),
    (x0:  0.50; x1:  0.00; x2: 100.00; y0:  0.00; y1: 0.50; y2:    0.00; p: 0.333),
    (x0:  0.50; x1:  0.00; x2:  50.00; y0:  0.00; y1: 0.50; y2: -100.00; p: 0.333));

constructor TIFSGraphic.Create(mx, my: integer);
begin
  inherited Create(mx, my);
  xsc:= 1;
  ysc:= 1;
  XOff:= round(mx/2);
  YOff:= my-100;
  ox:=0;
  oy:=0;
  asp:=my/mx;
  color:= RGB(16, 255, 16);
  BuildProb;
end;

function TIFSGraphic.FindTran: integer;
var
  i: integer;
  w: double;
begin
  w:= Random;
  i:= 0;
  while w > prob[i] do i:=i+1;
  FindTran:= i;
end;

procedure TIFSGraphic.BuildProb;
var
  i: integer;
begin
  SetLength(prob, 3);
  prob[0]:= IFS_Sierpinski[0].p;
  for i:= 1 to 2 do begin
    prob[i]:= prob[i-1] + IFS_Sierpinski[i].p;
  end;
  prob[2]:= 1;
end;

procedure TIFSGraphic.MakeTran(var nx, ny: double);
var
  s: integer;
begin
  s:= FindTran;
  nx:= IFS_Sierpinski[s].x0*ox + IFS_Sierpinski[s].x1*oy + IFS_Sierpinski[s].x2;
  ny:= IFS_Sierpinski[s].y0*ox + IFS_Sierpinski[s].y1*oy + IFS_Sierpinski[s].y2;
  ox:= nx; oy:= ny;
end;

procedure TIFSGraphic.Draw(iter: integer);
var
  n: integer;
  nx, ny: double;
  x, y: integer;
begin
  for n:= 1 to iter do begin
    MakeTran(nx, ny);
    x:= round(nx*xsc)+XOff;
    y:= round(asp*ny*ysc)+YOff;
    bitmap.Canvas.Pixels[x, y]:= color;
  end;
end;

constructor TForestGraphic.Create(mx, my: integer);
begin
  inherited Create(mx, my);
  bx:=0;
  by:=0;
  drawForest:= true;
end;

procedure TForestGraphic.BuildProb;
begin
  SetLength(prob, 6);
  prob[0]:= 0.008;
  prob[1]:= 0.034;
  prob[2]:= 0.060;
  prob[3]:= 0.400;
  prob[4]:= 0.700;
  prob[5]:= 1.000;
end;

procedure TForestGraphic.MakeTran(var nx, ny: double);
var
  s: integer;
begin
  s:= FindTran;
  if s<4 then begin {Generate another point in the fern.}
    nx:= IFS_fern[s].x0*ox + IFS_fern[s].x1*oy + IFS_fern[s].x2;
    ny:= IFS_fern[s].y0*ox + IFS_fern[s].y1*oy + IFS_fern[s].y2;
    ox:=nx; oy:=ny;
    bx:=nx; by:=ny;
  end
  else if drawForest then begin    {Generate another point in the forest.}
    s:= s-4;
    nx:= IFS_forest[s].x0*bx + IFS_forest[s].x1*by + IFS_forest[s].x2;
    ny:= IFS_forest[s].y0*bx + IFS_forest[s].y1*by + IFS_forest[s].y2;
    bx:= nx; by:= ny;
  end;
end;

end.

