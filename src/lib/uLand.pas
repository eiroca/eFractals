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
 Version:  1.0
 Creation Date: 01/09/1996
 Last Modify Date: 30/12/06
*)
unit uLand;

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
  SysUtils, Classes, Graphics, Math, uGraph;

const
  SIZELN2 = 8;
  SIZE    = (1 shl SIZELN2);
  SIZEP1  = (1 shl SIZELN2) + 1;
  MAX_VAL = 256;

  COL_NUV = 64;
  COL_MAR = 64;
  COL_PAL = 64;

type

  TLandMap = array[0..SIZE,0..SIZE] of integer;

  TLand1Graphic = class(TOffscreenGraphic)
    public
    private
     map: TLandMap;
     pal: array[0..255] of TColor;
    private
     function CalcX(x, y:integer): integer;
     function CalcY(x, y:integer): integer;
    public
     constructor Create;

     procedure MakeMap;
     procedure DrawMap2D;
     procedure DrawMap3D;

  end;

  TLand2Graphic = class(TOffscreenGraphic)
    private
     pal_te1: array[0..COL_PAL-1] of TColor;
     pal_te2: array[0..COL_PAL-1] of TColor;
     pal_te3: array[0..COL_PAL-1] of TColor;
     pal_nuv: array[0..COL_NUV-1] of TColor;
     pal_mar: array[0..COL_NUV-1] of TColor;
     map: TLandMap;
     prop: double;
     mx2: double;
     my2: double;
     cs: double;
     sn: double;
    public
     altmax: integer;
     livmare: integer;
     lato: word;
     dimen: double;
     df: double;
     ang: integer;
     altz: double;
     solx: integer;
     soly: integer;
    private
     procedure GeneratePalette;
     function  check(altezza: integer): integer;
     function  Random2(max: integer): integer;
     procedure ToScreen(Xp, y, z: double; var xs, ys: integer);
     function  Color(penden: integer; lumin: double; zz, ac: integer): TColor;
     procedure Nuvole(mx, my: integer);
    public
     constructor Create;

     procedure MakeMap;
     procedure DrawMap3D;

  end;

implementation

const
  lxmax = SIZE*2;
  passo = lxmax/(SIZE*2)+0.5;
  r     = 0.8;
  kk    = 1;

  deg2rad = PI/180.0;
  rad2deg = 180/PI;
  pimez   = 6.2831852/4.0;

constructor TLand1Graphic.Create;
begin
  inherited Create(lxmax, lxmax);
  fillChar(map, sizeof(map), 0);
  randomize;
  fade( 32,  32,  64,   0,   0, 255, pal,   0, 127);
  fade( 16, 240,  16,  80,  72,  64, pal, 128, 255);
end;

function TLand1Graphic.CalcX(x, y:integer):integer;
begin
  CalcX:=round(x*passo+r*y*passo);
end;

function TLand1Graphic.CalcY(x, y: integer): integer;
var
  q: integer;
begin
  q:= map[x,y] - (MAX_VAL div 2);
  if q<0 then begin
    q:=0;
  end;
  CalcY:=round(y*passo*r-q*kk)+110;
end;

procedure TLand1Graphic.MakeMap;
var
  h1, h2, h3, h4: integer;
  i, z, x, y, xx, yy: integer;
  step, l2, al: integer;
  function rum: integer;
  var
    r: integer;
  begin
    r:= round((random()-0.5) * step / SIZE * MAX_VAL);
    Result:= r;
  end;
  function check(x: integer): integer;
  begin
    if (x < 0) then Result:= 0
    else if (x > (MAX_VAL-1)) then Result:= (MAX_VAL-1)
    else Result:= x;
  end;
begin
  map[0,0]:= random(MAX_VAL);
  map[0,SIZE]:= random(MAX_VAL);
  map[SIZE,SIZE]:=random(MAX_VAL);
  map[SIZE,0]:= random(MAX_VAL);
  for i:= 0 to SIZELN2-1 do begin
    step:= 1 shl (8-i);
    al:= SIZE-step;
    l2:= step shr 1;
    z:= (al div step);
    for xx:=0 to z do begin
      x:= xx*step;
      for yy:=0 to z do begin
        y:= yy*step;
        h1:= map[x, y];
        h2:= map[x+step, y];
        h3:= map[x+step, y+step];
        h4:= map[x, y+step];
        map[x+l2,y+l2]:= check((h1+h2+h3+h4) div 4 + rum);
        map[x+l2,y]:= check((h1+h2) div 2 + rum);
        map[x,y+l2]:= check((h1+h4) div 2 + rum);
      end;
    end;
  end;
end;

procedure TLand1Graphic.DrawMap2D;
var
  x, y: integer;
  c: TColor;
begin
  for y:=0 to SIZE-1 do begin
    for x:=0 to SIZE-1 do begin
      c:= pal[map[x,y]];
      bitmap.canvas.Pixels[x, y]:= c;
    end;
  end;
end;

procedure TLand1Graphic.DrawMap3D;
var
  x, y: integer;
  c: TColor;
  p: array[0..3] of TPoint;
begin
  for y:= 0 to SIZE-1 do begin
    for x:= 0 to SIZE-1 do begin
      c:= pal[map[x,y]];
      p[0].X:= CalcX(x, y);
      p[0].Y:= CalcY(x, y);
      p[1].X:= CalcX(x+1, y);
      p[1].Y:= CalcY(x+1, y);
      p[2].X:= CalcX(x+1, y+1);
      p[2].Y:= CalcY(x+1, y+1);
      p[3].X:= CalcX(x, y+1);
      p[3].Y:= CalcY(x, y+1);
      bitmap.Canvas.Brush.Color:= c;
      bitmap.Canvas.Brush.Style:= bsSolid;
      bitmap.Canvas.Pen.Color:= c;
      bitmap.Canvas.Pen.Style:= psClear;
      bitmap.Canvas.Polygon(p);
    end;
  end;
end;

constructor TLand2Graphic.Create;
begin
  inherited Create(1024, 768);
  GeneratePalette;
  FillChar(map, sizeOf(map), 0);
  Clear;
  altmax:= 10000;
  livmare:= 5000;
  lato:= 30000;
  dimen:= 2.3;
  df:= 1.1;
  ang:= 0;
  altz:= 100.0;
  solx:= 315;
  soly:= 45;
end;

(* Imposta la palette con i colori del paesaggio *)
procedure TLand2Graphic.GeneratePalette;
begin
  fade(016, 048, 016, 048, 144, 048, pal_te1, 0, COL_PAL-1);
  fade(064, 048, 032, 160, 144, 128, pal_te2, 0, COL_PAL-1);
  fade(048, 048, 048, 144, 144, 144, pal_te3, 0, COL_PAL-1);
  fade(016, 064, 128, 016, 064, 224, pal_mar, 0, COL_MAR-1);
  fade(040, 160, 255, 255, 255, 255, pal_nuv, 0, COL_NUV-1);
end;


(* funzione per il controllo del supermaneto sul limite di altezza *)
function TLand2Graphic.check(altezza: integer): integer;
begin
  if (altezza>altmax) then altezza:= altmax
  else if (altezza<0) then altezza:= 0;
  check:= altezza;
end;

function TLand2Graphic.Random2(max: integer): integer;
begin
  Result:= random(max*2)-max;
end;

(* procedura per la creazione del frattale *)
procedure TLand2Graphic.MakeMap;
var
  j,i,max,m2,dd: integer;
  lat: double;
  div1,div2: integer;
begin
  map[0,0]:= Random(altmax);
  map[0,SIZEP1-1]:= Random(altmax);
  map[SIZEP1-1,SIZEP1-1]:= Random(altmax);
  map[SIZEP1-1,0]:= Random(altmax);
  for dd:= 1 to SIZELN2 do begin
    max:= (SIZEP1-1) div (1 shl (dd-1));
    m2:= max shr 1;
    lat:= lato / (1 shl (dd-1));
    div1:= round(lat / power(sqrt(2.0), 3.0-dimen));
    div2:= round(lat / power(2.0, 3.0-dimen));
    (* calcolo dei punti centro per i quadrati *)
    j:= 0;
    while j<SIZEP1-1 do begin
      i:= 0;
      while i<SIZEP1-1 do begin
        map[i+m2,j+m2]:= check(((map[i,j]+map[i+max,j]+map[i+max,j+max]+map[i,j+max]) div 4) + Random2(div1));
        inc(i, max);
      end;
      inc(j, max);
    end;
    if (dd > 1) then begin
      (* calcolo dei punti sui lati, non presenti sui bordi del frattale *)
      j:= max;
      while j<SIZEP1-1 do begin
        i:= 0;
	while i<SIZEP1-1 do begin
	  map[i+m2,j]:= check(((map[i,j]+map[i+max,j]+map[i+m2,j-m2]+map[i+m2,j+m2]) div 4) + Random2(div2));
          inc(i,max);
        end;
        inc(j, max);
      end;
      j:= 0;
      while j<SIZEP1-1 do begin
        i:= max;
	while i<SIZEP1-1 do begin
	  map[i,j+m2]:= check(((map[i,j]+map[i,j+max]+map[i-m2,j+m2]+map[i+m2,j+m2]) div 4) + Random2(div2));
          inc(i, max);
        end;
        inc(j, max);
      end;
    end;
    (* calcolo dei punti sui lati, presenti sui bordi del frattale *)
    i:= 0;
    while i<SIZEP1-1 do begin
      map[i+m2,0]:= check((map[i,0]+map[i+max,0]+map[i+m2,m2]) div 3 + Random2(div2));
      map[i+m2,SIZEP1-1]:= check((map[i,SIZEP1-1]+map[i+max,SIZEP1-1]+ map[i+m2,(SIZEP1-1)-m2]) div 3 + Random2(div2));
      map[0,i+m2]:= check((map[0,i]+map[0,i+max]+map[m2,i+m2]) div 3 + Random2(div2));
      map[SIZEP1-1,i+m2]:= check((map[SIZEP1-1,i]+map[SIZEP1-1,i+max]+ map[(SIZEP1-1)-m2,i+m2]) div 3 + Random2(div2));
      inc(i, max);
    end;
  end;
end;

procedure TLand2Graphic.ToScreen(Xp, y, z: double; var xs, ys: integer);
var yp, zp: double;
begin
  (* effettua la rotazione di un punto (x,y,z) attorno all'asse X;
   i risultati sono riportati nelle variabili (Xp,Yp,Zp) *)
  (* Xp:= Xp; *)
  Yp:= cs*y+sn* z;
  Zp:= cs*z-sn*y;
  (* calcolo della prospettiva; il punto dello schermo cosi' calcolato
   e' riportato nelle variabili (Xp,Yp) *)
  Xp:= (Xp*df)/(Yp+df);
  Yp:= (Zp*df)/(Yp+df);
  xs:= trunc(Xp*prop+mx2);
  ys:= trunc(my2-Yp*prop);
end;

(* calcola il colore di una faccia in base alla pendenza, luminosità e altezza;
   se ac vale -1, allora la faccia appartiene al mare *)
function TLand2Graphic.Color(penden: integer; lumin: double; zz, ac: integer): TColor;
var
  lum, anglim: integer;
begin
  if (lumin < 0) then lumin:= 0;
  if (zz < 0) then zz:= 0;
  if (ac > -1) then begin
    lum:= trunc(lumin*(COL_PAL-1)); (* calcolo dell'indice luminosit… da 0 a 47 *)
    zz:= zz-livmare;
    (* determina il colore in base all'altezza ed alla pendenza *)
    if (zz < 2000) then begin
      anglim:= MulDiv(-45,zz,2000)+90;
      if (penden < anglim) then begin
        Result:= pal_te1[lum];
      end
      else begin
        Result:= pal_te2[lum];
      end;
    end
    else if (zz < 5000) then begin
      anglim:= MulDiv(-45,zz-2000,3000)+45;
      if (penden < anglim) then begin
        Result:= pal_te1[lum];
      end
      else begin
        anglim:= MulDiv(-30,zz-2000,3000)+90;
        if (penden < anglim) then begin
          Result:= pal_te2[lum];
        end
        else begin
          Result:= pal_te3[lum];
        end;
      end;
    end
    else if (zz < 7000) then begin
      anglim:= MulDiv(-60,zz,2000)+60;
      if (penden < anglim) then begin
        Result:= pal_te2[lum];
      end
      else begin
        Result:= pal_te3[lum];
      end;
    end
    else begin
      Result:= pal_te3[lum];
    end;
  end
  else begin
    (* nel caso del mare viene utilizzato direttamente il colore marino *)
    Result:= pal_mar[trunc(lumin * (COL_MAR-1))];
  end;
end;

(* procedura per il disegno delle nuvole; questa procedura e' simile a Visual,
   tranne che non viene calcolata luminosit… e pendenza della faccia, dato che
   il colore di quest'ultima viene calcolato solo in base all'altezza *)
procedure TLand2Graphic.Nuvole(mx, my: integer);
var
  j,i,l: integer;
  x1,x2,x3,
  y1,y2,y3,
  z1,z2,z3,
  z: integer;
  col: integer;
  Alt: double;
begin
  prop:= mx;
  mx2:= mx * 0.5;
  my2:= my * 0.5;
  cs:= cos(ang*deg2rad);
  sn:= sin(ang*deg2rad);
  l:= lato div (SIZEP1-1);
  z:= map[(SIZEP1-1) shr 1, SIZEP1-1];
  x1:= 0; x2:= 0; x3:= 0;
  y1:= 0; y2:= 0; y3:= 0;
  if (z > livmare) then Alt:= altz + z else Alt:= altz + livmare;
  for j:= 0 to SIZEP1-2 do begin
    for i:= 0 to SIZEP1-2 do begin
      z1:= map[(SIZEP1-1)-i,(SIZEP1-1)-j];
      z2:= map[(SIZEP1-2)-i,(SIZEP1-1)-j];
      z3:= map[(SIZEP1-1)-i,(SIZEP1-2)-j];
      z:= (z1+z2+z3) div 3;
      z1:= MulDiv(altmax,j,SIZEP1-1)+livmare;
      z2:= z1;
      z3:= MulDiv(altmax,j+1,SIZEP1-1)+livmare;
      if (i>0) then begin
        x3:= x1;
        y3:= y1;
        x1:= x2;
        y1:= y2;
      end
      else begin
        ToScreen(i*l-lato shr 1,lato - j*l,z1-Alt, x1, y1);
        ToScreen(i*l-lato shr 1,lato - (j*l+l),z3-Alt, x3, y3);
      end;
      ToScreen(i*l+l-lato shr 1,lato-j*l,z2-Alt, x2, y2);
      if ((x1>=0) and (x1<=mx) and (y1>=0) and (y1<=my)) or ((x2>=0) and (x2<=mx) and (y2>=0) and (y2<=my)) or ((x3>=0) and (x3<=mx) and (y3>=0) and (y3<=my)) then begin
	col:= pal_nuv[MulDiv(z, COL_NUV-1, altmax+1)];
        DrawTriangle(bitmap.Canvas, x1, y1, x2, y2, x3, y3, col);
      end;
      z1:= map[(SIZEP1-2)-i,(SIZEP1-2)-j];
      z2:= map[(SIZEP1-2)-i,(SIZEP1-1)-j];
      z3:= map[(SIZEP1-1)-i,(SIZEP1-2)-j];
      z:= (z1+z2+z3) div 3;
      z1:= altmax * (j+1) div (SIZEP1-1) + livmare;
      ToScreen(i*l+l-lato shr 1,lato-(j*l+l),z1-Alt, x1, y1);
      if ((x1>=0) and (x1<=mx) and (y1>=0) and (y1<=my)) or ((x2>=0) and (x2<=mx) and (y2>=0) and (y2<=my)) or ((x3>=0) and (x3<=mx) and (y3>=0) and (y3<=my)) then begin
        col:= pal_nuv[MulDiv(z, COL_NUV-1, altmax+1)];
        DrawTriangle(bitmap.Canvas, x1, y1, x2, y2, x3, y3, col);
      end;
    end;
  end;
end;

(* procedura per la generazione dell'immagine finale *)
procedure TLand2Graphic.DrawMap3D;
var
  mx, my: integer;
  j,i,l: integer;
  x1,x2,x3,
  y1,y2,y3,
  z1,z2,z3,
  z: integer;
  pend, col: integer;
  Alt, dis1: double;
  nrmi, nrmj, nrmk, si, sj, sk, modv, lum, lat: double;
begin
  (* apre lo schermo nella risoluzione indicata *)
  mx:= bitmap.Width;
  my:= bitmap.Height;
  x1:= 0; x2:= 0; x3:= 0;
  y1:= 0; y2:= 0; y3:= 0;
  (* genera le nuvole prima *)
  Nuvole(mx, my);
  (* calcola le componenti del vettore per i raggi luminosi; il modulo di questo vettore Š 1 *)
  si:= cos(solx*deg2rad) * cos(soly*deg2rad);
  sj:= sin(solx*deg2rad) * cos(soly*deg2rad);
  sk:= sin(soly*deg2rad);
  (* determina alcune variabili precalcolate *)
  lat:= lato/(SIZEP1-1);
  prop:= mx; mx2:= mx * 0.5; my2:= my *0.5;
  (* determina l'altezza del rilievo sotto i piedi dell'osservatore e ci somma il valore altezza indicata nei parametri *)
  z:= map[(SIZEP1-1) shr 1,SIZEP1-1];
  if (z > livmare) then Alt:= altz + z else Alt:= altz + livmare;
  (* precalcola i valori del coseno e seno per la rotazione *)
  cs:= cos(ang*deg2rad);
  sn:= sin(ang*deg2rad);
  l:= lato div (SIZEP1-1);
  (* inizia il ciclo per ogni faccia del rilievo *)
  for j:= 0 to SIZEP1-2 do begin
    for i:= 0 to SIZEP1-2 do begin
      (* preleva le coordinate di altezza dei punti *)
      z1:= map[i,j];
      z2:= map[i+1,j];
      z3:= map[i,j+1];
      z:= (z1+z2+z3) div 3;
      (* controlla le altezza inferiori al livello del mare *)
      if (z1 < livmare) and (z2 < livmare) and (z3 < livmare) then pend:= -1 else pend:= 0;
      if (z1 < livmare) then z1:= livmare;
      if (z2 < livmare) then z2:= livmare;
      if (z3 < livmare) then z3:= livmare;
      if (pend = -1) then begin
        (* la faccia Š sul mare, per cui viene calcolata l'altezza in base alle formule del moto ondoso *)
        if (z1 = livmare) then begin
          dis1:= sqrt(((i-SIZEP1)*(i-SIZEP1)+(j-SIZEP1)*(j-SIZEP1)));
          z1:= livmare + trunc(sin(dis1*pimez)*50.0);
        end;
        if (z2 = livmare) then begin
          dis1:= sqrt(((i+1-SIZEP1)*(i+1-SIZEP1)+(j-SIZEP1)*(j-SIZEP1)));
          z2:= livmare + trunc(sin(dis1*pimez)*50.0);
        end;
        if (z3 = livmare) then begin
          dis1:= sqrt(((i-SIZEP1)*(i-SIZEP1)+(j+1-SIZEP1)*(j+1-SIZEP1)));
          z3:= livmare + trunc(sin(dis1*pimez)*50.0);
        end;
      end;
      (* vengono riutilizzati i due punti gi… calcolati della faccia precedente *)
      if (i>0) then begin
        x3:= x1;
        y3:= y1;
        x1:= x2;
        y1:= y2;
      end
      else begin
        (* ruota e calcola la prospettiva dei punti *)
        ToScreen(i*l-lato shr 1,lato-j*l,z1-Alt, x1, y1);
        ToScreen(i*l-lato shr 1,lato-(j*l+l),z3-Alt, x2, y3);
      end;
      (* calcola le coordinate effettive dei punti sullo schermo, giacchŠ quelle attualmente inserite sono misurate in metri *)
      ToScreen(i*l+l-lato shr 1,lato-j*l,z2-Alt,x2, y2);
      (* se almeno un vertice della faccia Š contenuto nello schermo, disegnala *)
      if ((x1>=0) and (x1<=mx) and (y1>=0) and (y1<=my)) or ((x2>=0) and (x2<=mx) and (y2>=0) and (y2<=my)) or ((x3>=0) and (x3<=mx) and (y3>=0) and (y3<=my)) then begin
        (* calcola i componenti del vettore normale alla faccia, utilizzando
        il prodotto vettoriale *)
        nrmi:= (z1-z2);
        nrmj:= (z3-z1);
        nrmk:= lat;
        modv:= sqrt(nrmi*nrmi + nrmj*nrmj + nrmk*nrmk);
        (* se la faccia non appartiene al mare, calcola la pendenza mediante il prodotto scalare; dato che solo la terza componente del vettore che si dirige verso l'alto vale 1, mentre le altre due sono nile, allora viene considerato solo nrmk *)
        if (pend > -1) then pend:= trunc(abs(arccos(nrmk/modv)*rad2deg));
        (* calcola la luminosit… della faccia con il prodotto scalare tra la normale ed il vettore dei raggi *)
        lum:= (nrmi*si + nrmj*sj + nrmk*sk) / modv;
        (* determina il colore della faccia *)
        col:= Color(pend, lum, z, pend);
        (* disegna la faccia con il colore calcolato *)
        DrawTriangle(bitmap.Canvas, x1, y1, x2, y2, x3, y3, col);
      end;
      (* rieffettua le stesse operazione sino ad ora illustrate, per la seconda faccia del quadrato *)
      z1:= map[i+1,j+1];
      z2:= map[i+1,j];
      z3:= map[i,j+1];
      z:= (z1+z2+z3) div 3;
      if (z1 < livmare) and (z2 < livmare) and (z3 < livmare) then pend:= -1 else pend:= 0;
      if (z1 < livmare) then z1:= livmare;
      if (z2 < livmare) then z2:= livmare;
      if (z3 < livmare) then z3:= livmare;
      if (pend = -1) then begin
        if (z1 = livmare) then begin
          dis1:= sqrt(((i+1-SIZEP1)*(i+1-SIZEP1)+(j+1-SIZEP1)*(j+1-SIZEP1)));
          z1:= livmare + trunc(sin(dis1*pimez)*50.0);
        end;
        if (z2 = livmare) then begin
          dis1:= sqrt(((i+1-SIZEP1)*(i+1-SIZEP1)+(j-SIZEP1)*(j-SIZEP1)));
          z2:= livmare + trunc(sin(dis1*pimez)*50.0);
        end;
        if (z3 = livmare) then begin
          dis1:= sqrt(((i-SIZEP1)*(i-SIZEP1)+(j+1-SIZEP1)*(j+1-SIZEP1)));
          z3:= livmare + trunc(sin(dis1*pimez)*50.0);
        end;
      end;
      ToScreen(i*l+l-lato shr 1,(lato-(j*l+l)),z1-Alt,x1,y1);
      if ((x1>=0) and (x1<=mx) and (y1>=0) and (y1<=my)) or ((x2>=0) and (x2<=mx) and (y2>=0) and (y2<=my)) or ((x3>=0) and (x3<=mx) and (y3>=0) and (y3<=my)) then begin
        nrmi:= (z3-z1);
        nrmj:= (z1-z2);
        nrmk:= lat;
        modv:= sqrt(nrmi*nrmi + nrmj*nrmj + nrmk*nrmk);
        if (pend > -1) then pend:= trunc(abs(arccos(nrmk/modv)*rad2deg));
        lum:= (nrmi*si + nrmj*sj + nrmk*sk) / modv;
        col:= Color(pend, lum, z, pend);
        DrawTriangle(bitmap.Canvas, x1, y1, x2, y2, x3, y3, col);
      end;
    end;
  end;
end;

end.

