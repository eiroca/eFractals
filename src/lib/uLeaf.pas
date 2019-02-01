(* GPL > 3.0
Copyright (C) 1996-2014 eIrOcA Enrico Croce & Simona Burzio

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
(*
 Disegna una foglia frattale. L'algoritmo e' adattato dalle Communications
 of ACM, July 1990, p. 23; potete provare a giocare sui  valori di alcune
 costanti del programma per modificare il disegnino che ne viene fuori.
*)
unit uLeaf;

{$IFDEF FPC}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Graphics, uGraph, Math;

type

  TLeafGraphic = class(TOffscreenGraphic)
     col1: TColor;
     col2: TColor;
    public
     constructor Create;
     procedure Draw;
  end;

  TTreeGraphic = class(TOffscreenGraphic)
     col1: TColor;
     col2: TColor;
     inc,FirstDirection: double;
     Depth,Scale:integer;
     StartX,StartY:integer;
     asp: double;
    public
     procedure Tree(x,y: integer; Dir: double; Level: integer);
     constructor Create;
     procedure Draw;
  end;

implementation

const
 IFS: array[0..3,0..2,0..3] of integer = (
 ((  0,   0,  0,  0), ( 0, 20,  0,  0), (0,   0,  0,  0)),
 (( 85,   0,  0,  0), ( 0, 85, 11, 70), (0, -10, 85,  0)),
 (( 31, -41,  0,  0), (10, 21,  0, 21), (0,   0, 30,  0)),
 ((-29,  40,  0,  0), (10, 19,  0, 56), (0,   0, 30,  0)));

constructor TLeafGraphic.Create;
begin
  inherited Create(640, 480);
  col1:= RGB(255, 255, 255);
  col2:= RGB( 64, 255,  64);
end;

procedure TLeafGraphic.Draw;
var
 b: array [0..99] of integer;
 x, y, z, newx, newy: integer;
 k: integer;
 cl: TColor;
 step: integer;
begin
  randomize;
  x:= 0;
  y:= 0;
  z:= 0;
  for step:= 0 to 1000 do begin
    for k := 0 to 99 do begin
      b[k]:= random(10);
      if b[k] > 3 then b[k] := 1;
    end;
    if step>100 then cl:= col2
    else cl:= col1;
    for k := 0 to 99 do begin
      newx := (IFS[b[k],0,0] * x + IFS[b[k],0,1] * y + IFS[b[k],0,2] * z) div 100 + IFS[b[k],0,3];
      newy := (IFS[b[k],1,0] * x + IFS[b[k],1,1] * y + IFS[b[k],1,2] * z) div 100 + IFS[b[k],1,3];
      z :=    (IFS[b[k],2,0] * x + IFS[b[k],2,1] * y + IFS[b[k],2,2] * z) div 100 + IFS[b[k],2,3];
      x := newx;
      y := newy;
      (* Disegna il punto di date coordinate *)
      bitmap.canvas.Pixels[320 - x + z, 400 - y]:= cl;
    end;
  end;
end;

constructor TTreeGraphic.Create;
var
  width: integer;
  height: integer;
begin
  width:= 640;
  height:= 480;
  inherited Create(width, height);
  col1:= RGB(160, 144, 128);
  col2:= RGB( 64, 255,  64);
  FirstDirection:= -pi/2;  {Negative since y increases down the screen.}
  inc:= pi/4;
  Scale:= 6;
  Depth:= 11;
  StartX:= round(width/2);
  StartY:= round(0.95*height);
  asp:= height/width; {Find aspect ratio}
end;

const MinDir : double = -pi;
const MaxDir : double = 0;

procedure TTreeGraphic.Tree(x,y: integer; Dir: double; Level: integer);
var
  XNew, YNew: integer;
  NewDir1: double;
  NewDir2: double;
begin
  if Level>0 then begin   {At level zero, recursion ends.}
    XNew:= round(Level*Scale*cos(Dir))+x;      {Multiplying by level }
    YNew:= round(asp*Level*Scale*sin(Dir))+y;  {varies the branch size.}
    if Level<5 then begin
      bitmap.canvas.Pen.Color:= col2;
      bitmap.canvas.Pen.Width:= 1;
    end
    else begin
      bitmap.canvas.Pen.Color:= col1; {Green leaves}
      bitmap.canvas.Pen.Width:= 2;
      if Level>9 then begin
        bitmap.canvas.Pen.Width:= 4;
      end
      else if Level>7 then begin
        bitmap.canvas.Pen.Width:= 3;
      end;
    end;
    bitmap.canvas.MoveTo(x,y);
    bitmap.canvas.LineTo(XNew,YNew);
    NewDir1:= Dir+Random*inc;
    NewDir2:= Dir-Random*inc;
    if (Level>5) then begin
      NewDir1:= Min(NewDir1, MaxDir);
      NewDir2:= Min(NewDir2, MaxDir);
      NewDir1:= Max(NewDir1, MinDir);
      NewDir2:= Max(NewDir2, MinDir);
    end;
    Tree(XNew,YNew,NewDir1,Level-1); {Two recursive calls - one}
    Tree(XNew,YNew,NewDir2,Level-1); {for each new branch.}
  end;
end;

procedure TTreeGraphic.Draw;
begin
  randomize;
  Tree(StartX, StartY, FirstDirection, Depth);
end;

end.

