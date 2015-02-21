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
unit FMain;

interface

uses
  uLand, uIFS, uLeaf, uDLA, uBrownian,
  Windows, Forms, Menus, Controls, StdCtrls, Classes, Dialogs, ExtCtrls;

type
  TfmMain = class(TForm)
    iImg: TImage;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    SaveBitmap1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    dlSave: TSaveDialog;
    Land11: TMenuItem;
    Land21: TMenuItem;
    Regenerate1: TMenuItem;
    Draw2D1: TMenuItem;
    Draw3D1: TMenuItem;
    DrawLand1: TMenuItem;
    Configure1: TMenuItem;
    Other1: TMenuItem;
    Forest1: TMenuItem;
    Leaf1: TMenuItem;
    ree1: TMenuItem;
    DLA1: TMenuItem;
    DLA2: TMenuItem;
    AddPoints1: TMenuItem;
    Aggregate1: TMenuItem;
    Shoot1: TMenuItem;
    CloseHole1: TMenuItem;
    aaa1: TMenuItem;
    aa1: TMenuItem;
    N2: TMenuItem;
    About1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SaveBitmap1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Regenerate1Click(Sender: TObject);
    procedure Draw2D1Click(Sender: TObject);
    procedure Draw3D1Click(Sender: TObject);
    procedure DrawLand1Click(Sender: TObject);
    procedure Configure1Click(Sender: TObject);
    procedure Forest1Click(Sender: TObject);
    procedure Leaf1Click(Sender: TObject);
    procedure ree1Click(Sender: TObject);
    procedure DLA1Click(Sender: TObject);
    procedure AddPoints1Click(Sender: TObject);
    procedure Aggregate1Click(Sender: TObject);
    procedure Shoot1Click(Sender: TObject);
    procedure CloseHole1Click(Sender: TObject);
    procedure aaa1Click(Sender: TObject);
    procedure aa1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    { Private declarations }
    land1: TLand1Graphic;
    land2: TLand2Graphic;
    dla: TDLAGraphic;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

uses
  eLibVCL,
  FConf, SysUtils;

{$R *.dfm}

procedure TfmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  land1:= TLand1Graphic.Create;
  land2:= TLand2Graphic.Create;
  land1.MakeMap;
  land2.MakeMap;
  dla:= TDLAGraphic.Create(640,480);
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  land1.Free;
  land2.Free;
  dla.Free;
end;

procedure TfmMain.Forest1Click(Sender: TObject);
var
  f: TIFSGraphic;
begin
  f:= TForestGraphic.Create(640, 480);
  f.Draw(40000);
  iImg.Picture.Assign(f.bitmap);
  f.Free;
end;

procedure TfmMain.Leaf1Click(Sender: TObject);
var
  f: TLeafGraphic;
begin
  f:= TLeafGraphic.Create;
  f.Draw;
  iImg.Picture.Assign(f.bitmap);
  f.Free;
end;

procedure TfmMain.ree1Click(Sender: TObject);
var
  f: TTreeGraphic;
begin
  f:= TTreeGraphic.Create;
  f.Draw;
  iImg.Picture.Assign(f.bitmap);
  f.Free;
end;

procedure TfmMain.Regenerate1Click(Sender: TObject);
begin
  land1.MakeMap;
end;

procedure TfmMain.aa1Click(Sender: TObject);
var
  f: TBrownianMotionGraphic;
  i: Integer;
begin
  f:= TBrownianMotionGraphic.Create;
  for i:= 0 to 2 do begin
    f.Draw(i, RGB(i*20+50, i*20+50, i*20+50));
  end;
  iImg.Picture.Assign(f.bitmap);
  f.Free;
end;

procedure TfmMain.aaa1Click(Sender: TObject);
var
  f: TBrownianMotionGraphic;
begin
  f:= TBrownianMotionGraphic.Create;
  f.Draw2;
  iImg.Picture.Assign(f.bitmap);
  f.Free;
end;

procedure TfmMain.About1Click(Sender: TObject);
begin
  AboutGPL(Application.Title);
end;

procedure TfmMain.AddPoints1Click(Sender: TObject);
begin
  dla.AddPoints(10);
  iImg.Picture.Assign(dla.bitmap);
end;

procedure TfmMain.Aggregate1Click(Sender: TObject);
begin
  dla.Aggregate;
  iImg.Picture.Assign(dla.bitmap);
end;

procedure TfmMain.CloseHole1Click(Sender: TObject);
begin
  dla.CloseHoles;
  iImg.Picture.Assign(dla.bitmap);
end;

procedure TfmMain.Configure1Click(Sender: TObject);
begin
  if fmConf.ShowModal = mrOk then begin
    Application.ProcessMessages;
    RandSeed:= StrToIntDef(fmConf.iSeed.Text, 0);
    land2.ang:= StrToIntDef(fmConf.iAngolo.Text, 0);
    land2.df:= StrToFloatDef(fmConf.iDistF.Text, 0);
    land2.lato:= StrToIntDef(fmConf.iLato.Text, 0);
    land2.altmax:= StrToIntDef(fmConf.iAltMax.Text, 0);
    land2.livmare:= StrToIntDef(fmConf.iAltezzaMare.Text, 0);
    land2.altz:= StrToFloatDef(fmConf.iAltVista.Text, 0);
    land2.dimen:= StrToFloatDef(fmConf.iDimensione.Text, 0);
    land2.solx:= StrToIntDef(fmConf.iDirSole.Text, 0);
    land2.soly:= StrToIntDef(fmConf.iAltSole.Text, 0);
    land2.MakeMap;
  end;
end;

procedure TfmMain.DLA1Click(Sender: TObject);
begin
  dla.clear;
  iImg.Picture.Assign(dla.bitmap);
end;

procedure TfmMain.Draw2D1Click(Sender: TObject);
begin
  land1.Clear;
  land1.DrawMap2D;
  iImg.Picture.Assign(land1.bitmap);
end;

procedure TfmMain.Draw3D1Click(Sender: TObject);
begin
  land1.Clear;
  land1.DrawMap3D;
  iImg.Picture.Assign(land1.bitmap);
end;

procedure TfmMain.DrawLand1Click(Sender: TObject);
begin
  land2.DrawMap3D;
  iImg.Picture.Assign(land2.bitmap);
end;

procedure TfmMain.SaveBitmap1Click(Sender: TObject);
var
  path: string;
begin
  if dlSave.Execute then begin
    path:= dlSave.FileName;
    iImg.Picture.SaveToFile(path);
  end;
end;

procedure TfmMain.Shoot1Click(Sender: TObject);
begin
  dla.Shoot(1000);
  iImg.Picture.Assign(dla.bitmap);
end;

end.
