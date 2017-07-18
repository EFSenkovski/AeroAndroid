unit uAndroidUdf;

interface

uses SysUtils;

function DateToString(dDtaC: TDateTime) : String;
function SQLString(sStr: String): String;

implementation


function DateToString(dDtaC: TDateTime) : String;
var
  iDia, iMes, iAno: Word;
  sRet: String;
begin
  DecodeDate(dDtaC, iAno, iMes, iDia);
  sRet := IntToStr(iDia) + '.' + IntToStr(iMes) + '.' + IntToStr(iAno);
  result := sRet;
end;

function SQLString(sStr: String): String;
begin
  result := #39 + sStr + #39;
end;

end.
