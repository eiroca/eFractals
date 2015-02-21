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
unit uDLA;

interface

uses
  SysUtils, Windows, Graphics, uGraph, Math;

type

  TDLAGraphic = class(TOffscreenGraphic)
    private
     p: array of TPoint;
     SizeX: integer;
     SizeY: integer;
     colStep: integer;
     function  chooseColor(c: TColor): TColor;
    public
     constructor Create(dx, dy: integer);
     procedure Shoot(iter: integer);
     procedure Aggregate;
     procedure CloseHoles;
     procedure AddPoints(pts: integer);
  end;

implementation

const
  DIRS: array[0..7] of TPoint = (
    (x:-1; y:-1), (x: 0; y:-1), (x:+1; y:-1),
    (x:-1; y: 0),               (x:+1; y: 0),
    (x:-1; y:+1), (x: 0; y:+1), (x:+1; y:+1)
  );

constructor TDLAGraphic.Create(dx, dy: integer);
begin
  SizeX:= dx;
  SizeY:= dy;
  inherited Create(SizeX, SizeY);
  colStep:= 1;
end;

procedure TDLAGraphic.AddPoints(pts: integer);
var
  i: integer;
  base: integer;
begin
  base:= high(p);
  SetLength(p, pts + length(p));
  for i:= 1 to pts do begin
    with p[base+i] do begin
      X:= random(SizeX);
      Y:= random(SizeY);
      bitmap.canvas.Pixels[X, Y]:= RGB(255,255,255);
    end;
  end;
end;

function TDLAGraphic.chooseColor(c: TColor): TColor;
var
  cc: integer;
  rr, gg, bb: integer;
begin
  cc:= ColorToRGB(c);
  rr:= (cc shr 16) and $FF;
  gg:= (cc shr  8) and $FF;
  bb:= (cc       ) and $FF;
  dec(rr, colStep); if (rr<0) then rr:= 0;
  dec(gg, colStep); if (rr<0) then gg:= 0;
  dec(bb, colStep); if (rr<0) then bb:= 0;
  Result:= rr shl 16 + gg shl 8 + bb;
end;

procedure TDLAGraphic.Shoot(iter: integer);
var
  i: integer;
  OldX, OldY: integer;
  NewX, NewY: integer;
  c: TColor;
  dir: integer;
  cnt: integer;
begin
  for i := 0 to iter -1 do begin
    oldx:= random(SizeX);
    oldy:= random(SizeY);
    c:= bitmap.canvas.Pixels[oldx, oldy];
    if c <> 0 then continue;
    cnt:= 0;
    repeat
      dir:= random(8);
      newx:= (oldx+DIRS[dir].x+SizeX) mod SizeX;
      newy:= (oldy+DIRS[dir].y+SizeY) mod SizeY;
      c:= bitmap.canvas.Pixels[newx, newy];
      if c <> 0 then begin
        bitmap.canvas.Pixels[oldx,oldy]:= chooseColor(c);
        break;
      end;
      oldx:= newx;
      oldy:= newy;
      inc(cnt);
    until cnt=5000;
  end;
end;

procedure TDLAGraphic.Aggregate;
var
  sz: integer;
  i: integer;
  OldX, OldY: integer;
  NewX, NewY: integer;
  col, oldCol: TColor;
  dir: integer;
begin
  sz:= Length(p);
  for i := 0 to sz-1 do begin
    with p[i] do begin
      oldx:= x;
      oldy:= Y;
    end;
    oldCol:= bitmap.canvas.Pixels[OldX, OldY];
    repeat
      dir:= random(8);
      newx:= (oldx+DIRS[dir].x+SizeX) mod SizeX;
      newy:= (oldy+DIRS[dir].y+SizeY) mod SizeY;
      col:= bitmap.canvas.Pixels[newx, newy];
      if col = 0 then begin
        bitmap.canvas.Pixels[NewX,NewY]:= chooseColor(oldCol);
        break;
      end;
      oldCol:= col;
      OldX:= NewX;
      OldY:= NewY;
    until false;
  end;
end;

procedure TDLAGraphic.CloseHoles;
var
  x, y: integer;
  OldX, OldY: integer;
  NewX, NewY: integer;
  c: TColor;
  dir: integer;
begin
  for y:= 0 to SizeY - 1 do begin
    for x := 0 to SizeX - 1 do begin
      oldx:= x;
      oldy:= Y;
      c:= bitmap.canvas.Pixels[OldX, OldY];
      if c <> 0 then continue;
      repeat
        dir:= random(8);
        newx:= (oldx+DIRS[dir].x+SizeX) mod SizeX;
        newy:= (oldy+DIRS[dir].y+SizeY) mod SizeY;
        c:= bitmap.canvas.Pixels[newx, newy];
        if c <> 0 then begin
          bitmap.canvas.Pixels[oldx,oldy]:= chooseColor(c);
          break;
        end;
        oldx:= newx;
        oldy:= newy;
      until false;
    end;
  end;
end;

end.

