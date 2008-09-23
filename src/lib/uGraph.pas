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
unit uGraph;

interface

uses
  SysUtils, Windows, Graphics;

type

  TOffscreenGraphic = class
    public
     bitmap: TBitmap;
     bgColor: TColor;
    protected
      procedure fade(r1, g1, b1, r2, g2, b2: integer; var pal: array of TColor; min, max: integer);
    public
     constructor Create(w, h: integer);
     destructor Destroy; override;

     procedure Clear;
  end;

implementation

constructor TOffscreenGraphic.Create(w, h: integer);
begin
  bgColor:= 0;
  bitmap:= TBitmap.Create;
  bitmap.Width:= w;
  bitmap.Height:= h;
  Clear;
end;

destructor TOffscreenGraphic.Destroy;
begin
  bitmap.Free;
end;

procedure TOffscreenGraphic.Clear;
var
  r: TRect;
begin
  r.Left:= 0;
  r.Top:= 0;
  r.Right:= bitmap.Width;
  r.Bottom:= bitmap.Height;
  bitmap.Canvas.Brush.Color:= bgColor;
  bitmap.Canvas.FillRect(r);
end;

procedure TOffscreenGraphic.fade(r1, g1, b1, r2, g2, b2: integer; var pal: array of TColor; min, max: integer);
var
  i : integer;
  sz: integer;
begin
  SZ:= max - min;
  for i:= 0 to sz do begin
    pal[min+i]:= RGB(MulDiv((r2-r1),i,SZ)+r1, MulDiv((g2-g1),i,SZ)+g1, MulDiv((b2-b1),i,SZ)+b1);
  end;
end;

end.

