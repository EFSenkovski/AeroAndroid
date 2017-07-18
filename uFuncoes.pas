unit uFuncoes;

interface

uses
  FireDAC.Comp.Client,
  IniFiles,
  System.SysUtils,
  IdIPWatch,
  Generics.Collections;

type
  TFuncoes = Class
  private
    // sEstacao          : string;
    _oDictSql   : TDictionary<string, string>;
    _sEnderecoIP: string;
  public
    // property Estacao          : String read sEstacao Write sEstacao;
    property dictSql   : TDictionary<string, string> read _oDictSql Write _oDictSql; // <REC_DOC, REC_SEQ>
    property EnderecoIP: string read _sEnderecoIP Write _sEnderecoIP; // <REC_DOC, REC_SEQ>
    function DeleteSql(sTabela: string): Boolean;
    function InsertSql(sTabela: string): Boolean;
    function UpdateSql(sTabela: string): Boolean;
    constructor Create;
  end;

implementation

uses
  dmMainAndroid;

{ TFuncoes }

constructor TFuncoes.Create;
begin
  _oDictSql    := TDictionary<string, string>.Create();
  _sEnderecoIP := 'http://localhost:2424/?user=AERO&senha=aero2001&';
end;

// Exclui registro de tabelas
// Rodrigo Germano Reis Nunes 25/03/2014

function TFuncoes.DeleteSql(sTabela: string): Boolean;
var
  sSql                          : string;
  pairDict                      : TPair<string, string>;
  sCampos, sValores, sTipoColuna: string;
  sWhere                        : string;
begin
  sWhere := '';

  // Inicia transação
  for pairDict in _oDictSql do begin
    sValores := QuotedStr(pairDict.Value);
    if (pairDict.Key = 'REC_SAL') then begin
      sValores := QuotedStr(pairDict.Value.Replace(',', '.'));
    end;
    if (pairDict.Key.Contains(':')) then begin
      if (sWhere.length > 0) then
        sWhere := sWhere + ' AND ';
      sWhere   := sWhere + pairDict.Key.Replace(':', '') + ' = ' + sValores;
    end else begin
      if (sCampos.length > 0) then
        sCampos := sCampos + ',';
      sCampos   := sCampos + pairDict.Key.Replace(':', '') + ' = ' + sValores;
    end;
  end;

  sSql := 'DELETE FROM ' + sTabela + ' WHERE ' + sWhere;

  DM_Main.IdHTTP.Get(_sEnderecoIP + 'sql=' + sSql);

  _oDictSql.Clear;
end;

// Inseri registro com transação
// Rodrigo Germano Reis Nunes 17/02/2014
function TFuncoes.InsertSql(sTabela: string): Boolean;
var
  sSqlReg                       : string;
  pairDict                      : TPair<string, string>;
  sCampos, sValores, sTipoColuna: string;
begin
  // Inicia transação
  for pairDict in _oDictSql do begin
    sCampos := sCampos + pairDict.Key.Replace(':', '') + ',';
    // sTipoColuna := GetTypeColumnImport(pairDict.Key.Replace(':', ''));
    if (pairDict.Key = 'HIS_VLR') then begin
      sValores := sValores + QuotedStr(pairDict.Value.Replace(',', '.'))+ ',';
    end else begin
      sValores := sValores + QuotedStr(pairDict.Value) + ',';
    end;
  end;
  sSqlReg := 'INSERT INTO ' + sTabela + '(' + Copy(sCampos, 0, sCampos.length - 1) + ') VALUES(' + Copy(sValores, 0, sValores.length - 1) + ');';
  DM_Main.IdHTTP.Get(_sEnderecoIP + 'sql=' + sSqlReg);
  _oDictSql.Clear;

end;

// Update registro com transação
// Rodrigo Germano Reis Nunes 17/02/2014
function TFuncoes.UpdateSql(sTabela: string): Boolean;
var
  pairDict                 : TPair<string, string>;
  sCampos, sValores, sWhere: string;
  iCount                   : integer;
  sSql                     : string;
begin
  sWhere := '';

  // Inicia transação
  for pairDict in _oDictSql do begin
    sValores := QuotedStr(pairDict.Value);
    if (pairDict.Key = 'REC_SAL') then begin
      sValores := QuotedStr(pairDict.Value.Replace(',', '.'));
    end;
    if (pairDict.Key.Contains(':')) then begin
      if (sWhere.length > 0) then
        sWhere := sWhere + ' AND ';
      sWhere   := sWhere + pairDict.Key.Replace(':', '') + ' = ' + sValores;
    end else begin
      if (sCampos.length > 0) then
        sCampos := sCampos + ',';
      sCampos   := sCampos + pairDict.Key.Replace(':', '') + ' = ' + sValores;
    end;
  end;

  sSql := 'UPDATE ' + sTabela + ' SET ' + sCampos + ' WHERE ' + sWhere;
  DM_Main.IdHTTP.Get(_sEnderecoIP + 'sql=' + sSql);
  _oDictSql.Clear;
end;

end.
