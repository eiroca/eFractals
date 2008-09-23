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
program eFractals2006;

uses
  Forms,
  uGraph in 'lib\uGraph.pas',
  uLand in 'lib\uLand.pas',
  uIFS in 'lib\uIFS.pas',
  uLeaf in 'lib\uLeaf.pas',
  uDLA in 'lib\uDLA.pas',
  uBrownian in 'lib\uBrownian.pas',
  FConf in 'gui\FConf.pas' {fmConf},
  FMain in 'gui\FMain.pas' {fmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmConf, fmConf);
  Application.Run;
end.
