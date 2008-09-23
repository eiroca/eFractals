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
unit FConf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfmConf = class(TForm)
    Label1: TLabel;
    iAngolo: TEdit;
    Label2: TLabel;
    iDistF: TEdit;
    iLato: TEdit;
    Label3: TLabel;
    iAltMax: TEdit;
    Label4: TLabel;
    iAltezzaMare: TEdit;
    Label5: TLabel;
    iAltVista: TEdit;
    Label6: TLabel;
    iDimensione: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    iSeed: TEdit;
    Label9: TLabel;
    iDirSole: TEdit;
    iAltSole: TEdit;
    Label10: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmConf: TfmConf;

implementation

{$R *.dfm}

procedure TfmConf.BitBtn3Click(Sender: TObject);
begin
  iSeed.Text:= IntToStr(random(1000000));
end;

procedure TfmConf.FormCreate(Sender: TObject);
begin
  randomize;
  iSeed.Text:= IntToStr(random(1000000));
end;

end.
