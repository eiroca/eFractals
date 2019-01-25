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
unit uBrownian;

{$IFDEF FPC}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Graphics, uGraph, Math;

const
  MaxLevelData = 9;
  NN = 1 shl MaxLevelData;

type
  PTerr = ^TTerr;
  TTerr = array[0..NN+1, 0..NN+1] of double;

  Data = array[0..1 shl MaxLevelData] of double;

  TBrownianMotionGraphic = class(TOffscreenGraphic)
    private
     X : Data;
     Delta: Data;
     T: TTerr;
    private
     procedure Plot;
     procedure MidPointRecursion(var X: Data; index0, index2, level, MaxLevel: integer);
     procedure MidPointBM(var X: Data; MaxLevel: integer; sigma: double);
     procedure MidPointFM1D(var X: Data; maxlevel: integer; sigma, H: double);
     procedure AdditionsFM1D(var X: Data; maxlevel: integer; sigma, H: double);
     procedure MidPointFM2d(var X: TTerr; MaxLevel: integer; sigma, H: double; addition: boolean);
    public
     constructor Create;
     procedure Draw(mode: integer; col: TColor);
     procedure Draw2;
  end;

implementation

function Gauss: double;
begin
  Gauss := abs(random - random);
end;

function f3(delta,x0,x1,x2: double): double;
begin
  f3 := (x0+x1+x2)/3 + delta * Gauss;
end;

function f4(delta,x0,x1,x2,x3: double): double;
begin
  f4:= (x0+x1+x2+x3)/4 + delta * Gauss;
end;

constructor TBrownianMotionGraphic.Create;
begin
  inherited Create(NN, NN);
end;

procedure TBrownianMotionGraphic.MidPointRecursion(var X: Data; index0, index2, level, MaxLevel: integer);
var index1: integer;
begin
  index1:= succ(index0 + index2) shr 1;
  X[index1]:= 0.5*(X[index0]+ X[index2]) + delta[level] * Gauss;
  if level <= Maxlevel then begin
    MidPointRecursion(X, index0, index1, succ(level), maxlevel);
    MidPointRecursion(X, index1, index2, succ(level), maxlevel);
  end;
end;

procedure TBrownianMotionGraphic.MidPointBM(var X: Data; MaxLevel: integer; sigma: double);
{Brownian motion via midpoint sisplacement,
sigma initial standard deviation}
var
  i, N : integer;
begin
  for i:= 1 to MaxLevel do begin
    delta[i]:= sigma * power(0.5, (i+1) / 2);
  end;
  N := 1 shl MaxLevel;
  X[0]:= sigma* Gauss;
  X[1]:= sigma * Gauss;
  MidPointRecursion(X, 0, N, 1, MaxLevel);
end;

procedure TBrownianMotionGraphic.MidPointFM1D(var X: Data; maxlevel: integer; sigma, H: double);
{One dimensiona fractal motion via midpoint displacement,
sigma initial stantard deviation,
H (0 < H < 1) determines fractal dimension D = 2 - H}
var i, N: integer;
begin
  for i:= 1 to maxlevel do begin
    delta[i]:= sigma * power(0.5, i*H) * sqrt(1 - power(2, 2 * H - 2));
  end;
  N:= 1 shl MaxLevel;
  X[0]:= 0;
  X[N]:= sigma * Gauss;
  MidPointRecursion(X, 0, N, 1, maxlevel);
end;

procedure TBrownianMotionGraphic.AdditionsFM1D(var X: Data; maxlevel: integer; sigma, H: double);
{One dimensiona fractal motion via successive random additions,
sigma initial stantard deviation,
H (0 < H < 1) determines fractal dimension D= 2-H }
var
  i, N,
  dd, D,
  level : integer;
begin
  for i := 1 to MaxLevel do begin
    delta[i]:= sigma * power(0.5, i * H) * sqrt(0.5)*sqrt(1-power(2, 2*H-2));
  end;
  N := 1 shl MaxLevel;
  FillChar(X,Sizeof(X),0);
  X[0]:= 0;
  X[N]:= sigma * Gauss;
  D:= N;
  dd:= succ(D) shr 1;
  level:= 0;
  while (level <= MaxLevel) do begin
    i:= dd;
    repeat
      X[i]:= 0.5 * (X[i-dd] + X[i+dd]);
      inc(i, D);
    until i > N-dd;
    i:= 0;
    repeat
      X[i]:= X[i] + delta[level] * Gauss;
      inc(i, dd);
    until i > N;
    D:= succ(D) shr 1;
    dd:= succ(dd) shr 1;
    inc(level);
  end;
end;

procedure TBrownianMotionGraphic.Plot;
var
  i : integer;
  a : double;
  MY: integer;
  y: integer;
  N: integer;
begin
  MY:= bitmap.Height;
  N:= 1 shl MaxLevelData;
  a:= abs(X[0]);
  for i:= 1 to N do begin
    if abs(X[i]) > a then a:= abs(X[i]);
  end;
  a:= 1/a;
  for i:= 0 to N do begin
    X[i] := X[i] * a;
  end;
  with bitmap.canvas do begin
    MoveTo(0, trunc(MY-X[0]*MY));
    for i:= 1 to N do begin
      y:= trunc(MY-X[i]*MY);
      LineTo(i, y);
    end;
  end;
end;

procedure TBrownianMotionGraphic.MidPointFM2d(var X: TTerr; MaxLevel: integer; sigma, H: double; addition: boolean);
{ X[][]     doubly indexed double array of size (n+1)^2
  MaxLevel  maximal number of recursions, N=2^MaxLevel
  sigma     initial standard deviation
  H         parameter H detrmines fractal dimension D = 3-H
  addition  turnos random additions on/off
}
var
  N, stage : integer;
  delta       : double; {holding standard deviation}
  xx,y,D,dd : integer;
begin
(*  InitGauss; *)
  N:= 1 shl MaxLevel;
  delta:= sigma;
  X[0, 0]:= delta * Gauss;
  X[0, N]:= delta * Gauss;
  X[N, 0]:= delta * Gauss;
  X[N, N]:= delta * Gauss;
  D:= N;
  dd:= N shr 1;
  for stage:= 1 to MaxLevel do begin (* going from grid type I to type II *)
    delta:= delta * power(0.5, 0.5 * H);
    xx:= dd;
    repeat
      y:= dd;
      repeat
       X[xx,y]:=f4(delta, X[xx+dd,y+dd], X[xx+dd,y-dd], X[xx-dd,y+dd], X[xx-dd,y-dd]);
       inc(y, D);
      until (y>N-dd);
      inc(xx, D);
    until (xx > N-dd);
    if addition then begin
      xx:= 0;
      repeat
        y:= 0;
        repeat
          X[xx,y] := X[xx,y] + delta * Gauss;
          inc(y, D);
        until (y > N);
        inc(xx, D);
      until (xx > N);
    end;
    (* going from grid type II to type I *)
    delta:= delta * power(0.5, 0.5*H);
    (* Interpolate and offset boundary grid points *)
    xx:= dd;
    while (xx <= (N-dd)) do begin
      y:= D;
      while (y<=N-dd) do begin
        X[xx,y]:=f4(delta, X[xx,y+dd], X[xx,y-dd], X[xx+dd,y], X[xx-dd,y]);
        inc(y, D);
      end;
      inc(xx, D);
    end;
    xx:= D;
    while (xx <= (N-dd)) do begin
      y:= dd;
      while (y<=N-dd) do begin
        X[xx,y]:= f4(delta, X[xx,y+dd], X[xx,y-dd], X[xx+dd,y], X[xx-dd,y]);
        inc(y, D);
      end;
      inc(xx, D);
    end;
    if addition then begin
      xx:= 0;
      repeat
        y:= 0;
        repeat
          X[xx,y] := X[xx,y] + delta * Gauss;
          inc(y, D);
        until (y > N);
        inc(xx, D);
      until (xx > N);
      xx:= dd;
      repeat
        y:= dd;
        repeat
          X[xx,y] := X[xx,y] + delta * Gauss;
          inc(y, D);
        until (y > N-dd);
        inc(xx, D);
      until (xx > N-dd);
    end;
    D:= D shr 1;
    dd:= dd shr 1;
  end;
end;

procedure TBrownianMotionGraphic.Draw(mode: integer; col: TColor);
begin
  bitmap.canvas.pen.Color:= col;
  case mode of
    0: MidPointBM(X, MaxLevelData, 1);
    1: MidPointFM1D(X, maxlevelData, 1, 0.5);
    2: AdditionsFM1D(X, maxlevelData, 1, 0.5);
  end;
  Plot;
end;

procedure TBrownianMotionGraphic.Draw2;
var
  N: integer;
  x, y: integer;
  m: double;
  c: integer;
begin
  MidPointFM2d(T, MaxLevelData, 2, 0.5, true);
  N:= 1 shl MaxLevelData;
  m:= 0;
  for y:= 0 to N-1 do begin
    for x:= 0 to N-1 do begin
      if abs(T[x,y]) > m then begin
        m:= abs(T[x,y]);
      end;
    end;
  end;
  for y:= 0 to N-1 do begin
    for x:= 0 to N-1 do begin
      c:= trunc(255 * abs(T[x,y])/m);
      bitmap.canvas.Pixels[x,y]:= RGB(c, c, c);
    end;
  end;
end;


end.

