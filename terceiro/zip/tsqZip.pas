{ TtsqZip delphi freeware component
  Copyright (c) 2003, Siqing Tang
  Email: tsq@softhome.net

This component compresses files using Info-zip's implementations. It generates
PKZIP-compatible archives, which are recognized by most popular compressors
like Winzip and WinRar.

The component uses zip32.dll, which is also included along and can be
downloaded from info-zip's http://www.info-zip.org. For the licence regarding
using of zip32.dll, read the accompanying file 'LICENCE'.

This component(TtsqZip) is distributed under the terms of the MPL 1.1. In short,
there is no WARRANTY of any kind, you use it at your risk. You can use this
component for any purpose, including commercial one. For details, read the
accompanying files 'MPL-1.1.txt' and 'copyright'.

Theodoros Bebekis<bebekis@otenet.gr> made a wonderful translation(zip32.pas) of
zip32.dll. Marcus Wirth <mwirth@generali-int.de> updated zip32.pas to make it
work with zip32.dll(v2.3). This component is based on the zip32.pas translated
by them. Many thanks to Theodoros Bebekis & Marcus Wirth.

The main advantage of this component is that it compresses files very fast(
should be at the same speed level as winzip since both this component and winzip
use the same C core code). It is also very stable as Info-zip's implementations
are stable as far as I know. However, there is also a disadvanage: it requires
that zip32.dll be distributed along with an application.

To get started, read TtsqZip_HowTo.htm

For the latest information of the component, please visit my webpage at 
http://free.hostdepartment.com/j/johntang/.

Any bug or feedback please send to:
 Siqing Tang <tsq@softhome.net>
 New Zealand
 September 2003

version 1.0 --- 2 September 2003. 
}


unit tsqZip;

interface

uses
  Windows, Messages, SysUtils, Classes, Zip32;

type
  //Functions avaliable in zip32.dll.
  TZpVersion    = procedure(var ZipVer: TZpVer); stdcall;
  TZpInit       = function(var lpZipUserFunc: TZipUserFunctions): Integer; stdcall;
  TZpSetOptions = function(var Opts: TZPOpt): Bool; stdcall;
  TZpGetOptions = function: TZPOpt; stdcall;
  TZpArchive    = function(C: TZCL): Integer; stdcall;

type
  //Second Leleve callback functions
  TZipPrint     = procedure(Buffer: PChar; Size: ULONG; var PResult: Integer) of object;
  TZipPassword  = procedure(P: PChar; N: Integer; M, Name: PChar; var PResult: Integer) of object;
  TZipComment   = procedure(Buffer: PChar; var PResult: Integer) of object;
  TZipService   = procedure(Buffer: PChar; Size: ULONG; var PResult: Integer) of object;

  TZipFlagOption = (
      zfoUseTempDir,          //Use temporary directory '-b' during zipping }
      zfoIncludeSuffixes,     //Include suffixes (not implemented)
      zfoEncryptFiles,        //Encrypt files. Read EncryptionSupported() to decide if this should be set to True
      zfoIncludeSystemFiles,  //Include system and hidden files
      zfoIncludeVolumeLabel,  //Include volume label
      zfoExcludeExtraAttributes, //Exclude extra attributes
      zfoNoDirEntries,        //Do not add directory entries
      zfoExcludeDate,         //Exclude files earlier than specified date
      zfoIncludeDate,         //Include only files earlier than specified date
      zfoVerbose,             //
      zfoQuiet,               //Quiet operation
      zfoCRLF_TO_LF,          //Translate CR/LF to LF
      zfoLF_TO_CRLF,          //Translate LF to CR/LF }
      zfoJunkDir,             //Junk directory names
      zfoGrow,                //Allow appending to a zip file
      zfoDosNameEntries,      //Make entries using DOS names (k for Katz)
      zfoDeleteFileAfterZip,  //Delete files added or updated in zip file }
      zfoDeleteEntries,       //Delete files from zip file
      zfoUpdateZipFile,       //Update zip file--overwrite only if newer
      zfoFreshenZipFile,      //Freshen zip file--overwrite only
      zfoJunkSFX,             //Junk SFX prefix
      zfoLatestTime,          //Set zip file time to time of latest file in it
      zfoCommentZipFile,      //Put comment in zip file
      zfoUpdateSFXOffsets,    //Update archive offsets for SFX files
      zfoUsePrivilege);

  TZipFlagOptions = set of TZipFlagOption;

  //Compress Level
  TZipCompressLevel = (
    zcl0NoCompression,
    zcl1Lowest,
    zcl2,
    zcl3,
    zcl4,
    zcl5,
    zcl6,
    zcl7,
    zcl8,
    zcl9Highest);

  TRecurseSubDir = (rsdNotRecursive, rsdRecursive {-r}, rsdRecursiveFromCurDir {-R});

  TZipOptions = class; //forward declaration

  //TtsqZip component
  TtsqZip = class(TComponent)
  private
    { Private declarations }
    FZipOptions: TZipOptions;

    FFilesToZip: TStrings;
    FZipFileName: string;

    FOnZipPrint: TZipPrint;
    FOnZipPassword: TZipPassword;
    FOnZipComment: TZipComment;
    FOnZipService: TZipService;

    function GetEncryptionSupported: Boolean;
    procedure SetFilesToZip(PFilesToZip: TStrings);

    function GetZip32DLLVersion: string;
    procedure SetZip32DLLVersion(const PVersion: string);

    function GetVersion: string;
    procedure SetVersion(const PVersion: string);
  protected
    { Protected declarations }
    procedure ZipInit(var PZipUserFuncRec: TZipUserFunctions); dynamic;
    procedure SetZipOptions; virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Execute: Integer; virtual;

    property EncryptionSupported: Boolean read GetEncryptionSupported;                //TRUE if encryption supported, else FALSE. This is a read only flag
  published
    { Published declarations }
    //zip options

    property ZipOptions: TZipOptions read FZipOptions write FZipOptions;

    property FilesToZip: TStrings read FFilesToZip write SetFilesToZip;
    property ZipFileName: string read FZipFileName write FZipFileName;

    property Zip32DLLVersion: string read GetZip32DLLVersion write SetZip32DLLVersion stored false;
    property Version: string read GetVersion write SetVersion stored False;

    //event properties
    property OnPrint: TZipPrint read FOnZipPrint write FOnZipPrint;
    property OnPassword: TZipPassword read FOnZipPassword write FOnZipPassword;
    property OnComment: TZipComment read FOnZipComment write FOnZipComment;
    property OnService: TZipService read FOnZipService write FOnZipService;
  end;

  TZipOptions = class(TPersistent)
  private
    FZipOwner: TtsqZip;

    //zip options
    FRepair: Integer;
    FRecurseSubDirs: TRecurseSubDir;
    FCompressLevel: TZipCompressLevel;
    FDateAfter: string;
    FTempDir: string;
    FRootDir: string;
    FZipFlagOptions: TZipFlagOptions;
  private
    procedure SetDateAfter(const PDateAfter: string);
    function GetEncryptionSupported: Boolean;
    function GetEncryptionSupportedStr: string;
    procedure SetEncryptionSupported(const PEncryptSupported: string);
    procedure SetRootDir(const PRootDir: string);
  public
    constructor Create(POwner: TtsqZip); virtual;
    property EncryptionSupported: Boolean read GetEncryptionSupported;                //TRUE if encryption supported, else FALSE. This is a read only flag
  published
    property DateAfter: string read FDateAfter write SetDateAfter;  //Date to include after (US format e.g. "12/31/98")
    property RootDir: string read FRootDir write SetRootDir;        //Directory to use as base for zipping
    property TempDir: string read FTempDir write FTempDir;          //Temporary directory used during zipping
    property RecurseSubDirs: TRecurseSubDir read FRecurseSubDirs write FRecurseSubDirs default rsdNotRecursive;
    property Repair: Integer read FRepair write FRepair default 0;                              //Repair archive. 1 => -F, 2 => -FF
    property CompressLevel: TZipCompressLevel read FCompressLevel write FCompressLevel default zcl6;
    property ZipFlagOptions: TZipFlagOptions read FZipFlagOptions write FZipFlagOptions;

    //read only property
    property Encryption: string read GetEncryptionSupportedStr write SetEncryptionSupported stored False; //readonly property
  end;

procedure LoadZip32DLL(const PZip32DLLFileName: string = ZIP_DLL);
procedure UnLoadZip32DLL(PForceUnload: Boolean = False);

procedure ZpVersion(var PZipVer: TZpVer);
function  ZpInit(var PZipUserFuncRec: TZipUserFunctions): Integer;
function  ZpSetOptions(var PZipOpts: TZPOpt): Boolean;
function  ZpGetOptions: TZPOpt;
function  ZpArchive(PZCL: TZCL): Integer;

//helper functions
function GetZipVersion(PFull: Boolean): string;

procedure Register;

implementation

var
  //function pointers to dll functions.
  MdllZpVersion : TZpVersion = nil;
  MdllZpInit: TZpInit = nil;
  MdllZpSetOptions: TZpSetOptions = nil;
  MdllZpGetOptions: TZpGetOptions = nil;
  MdllZpArchive: TZpArchive = nil;

  //object method points to TtsqZip events.
  MObjZipPrint: TZipPrint = nil;
  MObjZipPassword: TZipPassword = nil;
  MObjZipComment: TZipComment = nil;
  MObjZipService: TZipService = nil;

  //Instance numer of loaded zip32.dll
  MInstanceNumOfZip32DllLoaded: Integer = 0;

  MZip32DLLHandle: THandle = 0;

const
  CTtsqZipVersion = '1.0';

procedure Register;
begin
  RegisterComponents('tsq', [TtsqZip]);
end;

procedure LoadZip32DLL(const PZip32DLLFileName: string);

  function LoadDllFunction(const PFunctionName, PDLLName: string): FARPROC;
  begin
    Result := GetProcAddress(MZip32DLLHandle, PChar(PFunctionName));
    if not Assigned(Result) then begin
      raise Exception.Create('Failed to load function "' + PFunctionName
          + '" from ' + PDLLName);
    end;
  end;

var
  LVersionFromDll: string;
begin
  if MZip32DLLHandle = 0 then begin
    //Note: Even though zip32.dll can be in a system searching path,
    //      I prefer to place the .dll in the direcotory where an application resides,
    //      this avoids problems with .dll version conficts.
    IsExpectedZipDllVersion;    
    MZip32DLLHandle := LoadLibrary(PAnsiChar(PZip32DLLFileName));
    if MZip32DLLHandle = 0 then raise
        Exception.Create('Can''t load ' + PZip32DLLFileName);

    @MdllZpVersion    := LoadDllFunction('ZpVersion', PZip32DLLFileName);
    @MdllZpInit       := LoadDllFunction('ZpInit', PZip32DLLFileName);
    @MdllZpSetOptions := LoadDllFunction('ZpSetOptions', PZip32DLLFileName);
    @MdllZpGetOptions := LoadDllFunction('ZpGetOptions', PZip32DLLFileName);
    @MdllZpArchive    := LoadDllFunction('ZpArchive', PZip32DLLFileName);

    LVersionFromDll := GetZipVersion(False {short format: x.y});

    if ZIP_DLL_VERSION {our Delphi constrant} <> LVersionFromDll then begin
      raise Exception.Create('The version of Delphi translation from C headers doesn''t match that of ' + PZip32DLLFileName + '.'
        + #13#10 + 'The version of Delphi translation from C headers is ' + ZIP_DLL_VERSION + ', whereas '
        + #13#10 + 'The version of ' + PZip32DLLFileName + ' is ' + LVersionFromDll + '.');
    end;
    MInstanceNumOfZip32DllLoaded := 1;
  end
  else begin
    //already loaded. do not load again but increase reference count by 1
    Inc(MInstanceNumOfZip32DllLoaded);
  end;
end;

procedure UnLoadZip32DLL(PForceUnload: Boolean);
begin
  if (MZip32DLLHandle <> 0) then begin
    if PForceUnload then begin
      FreeLibrary(MZip32DLLHandle);
      MZip32DLLHandle := 0;
      MInstanceNumOfZip32DllLoaded := 0;
    end
    else begin
      if MInstanceNumOfZip32DllLoaded <= 1 then begin
        FreeLibrary(MZip32DLLHandle);
        MZip32DLLHandle := 0;
        MInstanceNumOfZip32DllLoaded := 0;
      end
      else begin
        //do not actually unload; reduce reference count by 1
        Dec(MInstanceNumOfZip32DllLoaded);
      end;
    end;
  end;
end;

function GetZipVersion(PFull: Boolean): string;
var
  LZipVersion: TZpVer;
  LBetaLevel, LDate, LZlibVersion: string;
begin
  ZpVersion(LZipVersion);
  with LZipVersion.Zip do begin
    Result := IntToStr(Major) + '.' + IntToStr(Minor);
    if PatchLevel <> 0 then Result := Result + IntToStr(PatchLevel);
  end;
  if PFull then begin
    with LZipVersion do begin
      LBetaLevel := BetaLevel;
      LDate := Date;
      LZlibVersion := ZLib_Version;
    end;
    if LBetaLevel <> '' then Result := Result + ', ' + LBetaLevel;
    if LDate <> '' then Result := Result + ', ' + LDate;
    if LZlibVersion <> '' then Result := Result + ', ' + LZlibVersion;
  end;
end;

// Start of jumpers functions to .dll
procedure ZpVersion(var PZipVer: TZpVer);
begin
  MdllZpVersion(PZipVer);
end;

function ZpInit(var PZipUserFuncRec: TZipUserFunctions): Integer;
begin
  Result := MdllZpInit(PZipUserFuncRec);
  //check return\\\
end;

function ZpSetOptions(var PZipOpts: TZPOpt): Boolean;
begin
  Result := MdllZpSetOptions(PZipOpts);
end;

function ZpGetOptions: TZPOpt;
begin
  Result := MdllZpGetOptions();
end;

function ZpArchive(PZCL: TZCL): Integer;
begin
  Result := MdllZpArchive(PZCL);
end;
// end of jumpers functions

//Module-scope callback functions.
function ZipPrintCallBack(Buffer: PChar; Size: ULONG): integer; stdcall;
begin
  Result := Size; //default
  if Assigned(MObjZipPrint) then MObjZipPrint(Buffer, Size, Result);
end;
//
function ZipPasswordCallBack(P: PChar; N: Integer; M, Name: PChar): integer; stdcall;
begin
  Result := 1; //default
  if Assigned(MObjZipPassword) then MObjZipPassword(P, N, M, Name, Result);
end;
//
//This function gets called if fComment = True
function ZipCommentCallBack(Buffer: PChar): Integer; stdcall;
begin
  Result := 1; //Changing this return value seems to make no difference.
  if Assigned(MObjZipComment) then MObjZipComment(Buffer, Result);
  //
  // To set comments, the developer needs to to put 0 ending string into Buffer.
  // For example, the following code will work
  //    Buffer[0] := 'o';
  //    Buffer[1] := 'k';
  //    Buffer[2] := chr(0);
  //
  // or simply call StrLCopy function:
  //    StrLCopy(Buffer, 'ok', 2) or StrLCopy(Buffer, PChar(s), Length(s); //where s is a string
  //
  // However, the code like this will not work(think it over why):
  //    Buffer := 'not working comments';
end;

//
function ZipServiceCallBack(Buffer: PChar; Size: ULONG): integer; stdcall;
begin
  Result := 0; //default
  //Assign non-zero will terminate the operation
  if Assigned(MObjZipService) then MObjZipService(Buffer, Size, Result);
end;

procedure SetZipObjectFunctions(
  PObjZipPrint: TZipPrint;
  PObjZipPassword: TZipPassword;
  PObjZipComment: TZipComment;
  PObjZipService: TZipService);
begin
  MObjZipPrint     := PObjZipPrint;
  MObjZipPassword  := PObjZipPassword;
  MObjZipComment   := PObjZipComment;
  MObjZipService   := PObjZipService;
end;

procedure SetZipCallBackFunctions(var PZipUserFunctions:TZipUserFunctions;
  PObjZipPrint: TZipPrint;
  PObjZipPassword: TZipPassword;
  PObjZipComment: TZipComment;
  PObjZipService: TZipService);
begin
  { prepare ZipUserFunctions structure }

  { What we do here is to set up two-level callback functions.
    The functions in the first level are
      ZipPrintCallBack
      ZipCommentCallBack
      ZipPasswordCallBack
      ZipServiceCallBack
    These functions will be called back when we perform a Zip
    action (compress, update, delete, etc). When each of these functions gets
    called, it then will call its corresponding object procedure(second level),
    which basically is an event handler of an instance of the TtsqZip component.
    We might show the process message, display how compressing progress and etc,
    depending the situation.
  }

  with PZipUserFunctions do begin
    @Print     := @ZipPrintCallBack;
    @Comment   := @ZipCommentCallBack;
    @Password  := @ZipPasswordCallBack;
    @Service   := @ZipServiceCallBack;
  end;
  SetZipObjectFunctions(PObjZipPrint, PObjZipPassword, PObjZipComment, PObjZipService);
end;

{ TZipOptions }

constructor TZipOptions.Create(POwner: TtsqZip);
begin
  FZipOwner := POwner;
  FCompressLevel := zcl6;
  FZipFlagOptions := [zfoExcludeExtraAttributes];
  FRecurseSubDirs := rsdNotRecursive;
end;

function TZipOptions.GetEncryptionSupported: Boolean;
begin
  Result := FZipOwner.GetEncryptionSupported;
end;

procedure TZipOptions.SetEncryptionSupported(
  const PEncryptSupported: string);
begin
 //Readonly property, do not put code here
end;

function TZipOptions.GetEncryptionSupportedStr: string;
const
  CSupport: array[False..True] of string = ('Not Supported', 'Supported');
begin
  Result := CSupport[GetEncryptionSupported];
end;

procedure TZipOptions.SetDateAfter(const PDateAfter: string);
begin
  FDateAfter := PDateAfter;
  //some validation needed in the future\\\.
end;

procedure TZipOptions.SetRootDir(const PRootDir: string);
begin
  if FRootDir <> PRootDir then begin
    if PRootDir = '' then begin
      FRootDir := PRootDir;
    end
    else begin
      FRootDir := IncludeTrailingPathDelimiter(PRootDir);
    end;
  end;
end;

{ TtsqZip }

constructor TtsqZip.Create(AOwner: TComponent);
begin
  inherited;
  LoadZip32DLL;
  FFilesToZip := TStringList.Create;
  FZipOptions := TZipOptions.Create(Self);
end;

destructor TtsqZip.Destroy;
begin
  FreeAndNil(FFilesToZip);
  FreeAndNil(FZipOptions);
  UnLoadZip32DLL(False);
  inherited;
end;

function TtsqZip.GetEncryptionSupported: Boolean;
var
  ZipOptions: TZPOpt;
begin
  ZipOptions := ZpGetOptions;
  Result := ZipOptions.fEncryption;
end;

procedure TtsqZip.SetFilesToZip(PFilesToZip: TStrings);
begin
  if FFilesToZip <> PFilesToZip then begin
    FFilesToZip.Assign(PFilesToZip);
  end;
end;

function TtsqZip.Execute: Integer;
var
  ZipRec   : TZCL;
  ZUF      : TZipUserFunctions;
  LFNVStart : PCharArray;
  i: Integer;
begin
  Result := 0; //assume success
  if FZipFileName = '' then begin
    raise Exception.Create('ZipFileName not provided.');
  end;

  if (FFilesToZip <> nil) and (FFilesToZip.Count > 0) then begin

    SetZipOptions;

    //The following code is copied from Theo Bebekis's zip demo program. Siqing Tang
    { initialize the dll with dummy functions }
    ZipInit(ZUF);

    { number of files to zip }
    ZipRec.argc := FFilesToZip.Count;

    { name of zip file - allocate room for null terminated string  }
    GetMem(ZipRec.lpszZipFN, Length(FZipFileName) + 1 );
    ZipRec.lpszZipFN := StrPCopy(ZipRec.lpszZipFN, FZipFileName);
    try
      { dynamic array allocation }
      GetMem(ZipRec.FNV, ZipRec.argc * SizeOf(PChar));
      LFNVStart := ZipRec.FNV;
      try
        { copy the file names from FileList to ZipRec.FNV dynamic array }
        for i := 0 to ZipRec.argc - 1 do
        begin
          GetMem(ZipRec.FNV^[i], Length(FFilesToZip[i]) + 1 );
          StrPCopy(ZipRec.FNV^[i], FFilesToZip[i]);
        end;
        try
          { send the data to the dll }
          Result := ZpArchive(ZipRec);
        finally
          { release the memory for the file list }
          ZipRec.FNV := LFNVStart;
          for i := (ZipRec.argc - 1) downto 0 do FreeMem(ZipRec.FNV^[i]);
        end;
      finally
        { release the memory for the ZipRec.FNV dynamic array }
        ZipRec.FNV := LFNVStart;
        FreeMem(ZipRec.FNV);
      end;
    finally
      { release the memory for the FileName }
      FreeMem(ZipRec.lpszZipFN);
    end;
  end;
end;

procedure TtsqZip.ZipInit(var PZipUserFuncRec: TZipUserFunctions);
begin
  SetZipCallBackFunctions(PZipUserFuncRec,
    FOnZipPrint,
    FOnZipPassword,
    FOnZipComment,
    FOnZipService);
  ZpInit(PZipUserFuncRec);
end;

procedure TtsqZip.SetZipOptions;
var
  ZipOptions : TZPOpt;
  LRootDir: string;
begin
  FillChar(ZipOptions, SizeOf(TZPOpt), 0);
  with ZipOptions do begin
    if FZipOptions.DateAfter <> '' then begin
      Date := PChar(FZipOptions.DateAfter);
    end
    else begin
      Date := nil;
    end;

    LRootDir := FZipOptions.RootDir;
    if LRootDir <> '' then begin
      LRootDir := IncludeTrailingPathDelimiter(LRootDir); //'\' must be at the end, important
      szRootDir := PChar(LRootDir);
    end
    else begin
      szRootDir := nil;
    end;

    if FZipOptions.TempDir <> '' then begin
      szTempDir := PChar(FZipOptions.TempDir);
    end
    else begin
      szTempDir := nil;
    end;

    fTemp           := zfoUseTempDir              in FZipOptions.ZipFlagOptions;
    fSuffix         := zfoIncludeSuffixes         in FZipOptions.ZipFlagOptions;
    fEncrypt        := zfoEncryptFiles            in FZipOptions.ZipFlagOptions;
    fSystem         := zfoIncludeSystemFiles      in FZipOptions.ZipFlagOptions;
    fVolume         := zfoIncludeVolumeLabel      in FZipOptions.ZipFlagOptions;
    fExtra          := zfoExcludeExtraAttributes  in FZipOptions.ZipFlagOptions;
    fNoDirEntries   := zfoNoDirEntries            in FZipOptions.ZipFlagOptions;
    fExcludeDate    := zfoExcludeDate             in FZipOptions.ZipFlagOptions;
    fIncludeDate    := zfoIncludeDate             in FZipOptions.ZipFlagOptions;
    fVerbose        := zfoVerbose                 in FZipOptions.ZipFlagOptions;
    fQuiet          := zfoQuiet                   in FZipOptions.ZipFlagOptions;
    fCRLF_LF        := zfoCRLF_TO_LF              in FZipOptions.ZipFlagOptions;
    fLF_CRLF        := zfoLF_TO_CRLF              in FZipOptions.ZipFlagOptions;
    fJunkDir        := zfoJunkDir                 in FZipOptions.ZipFlagOptions;
    fGrow           := zfoGrow                    in FZipOptions.ZipFlagOptions;
    fForce          := zfoDosNameEntries          in FZipOptions.ZipFlagOptions;
    fMove           := zfoDeleteFileAfterZip      in FZipOptions.ZipFlagOptions;
    fDeleteEntries  := zfoDeleteEntries           in FZipOptions.ZipFlagOptions;
    fUpdate         := zfoUpdateZipFile           in FZipOptions.ZipFlagOptions;
    fFreshen        := zfoFreshenZipFile          in FZipOptions.ZipFlagOptions;
    fJunkSFX        := zfoJunkSFX                 in FZipOptions.ZipFlagOptions;
    fLatestTime     := zfoLatestTime              in FZipOptions.ZipFlagOptions;
    fComment        := zfoCommentZipFile          in FZipOptions.ZipFlagOptions;
    fOffsets        := zfoUpdateSFXOffsets        in FZipOptions.ZipFlagOptions;
    fPrivilege      := zfoUsePrivilege            in FZipOptions.ZipFlagOptions;

    //fEncryption: readonly
    fRecurse        := Integer(FZipOptions.RecurseSubDirs);
    fRepair         := FZipOptions.Repair;
    fLevel          := Chr(Ord('0') + Integer(FZipOptions.CompressLevel));
  end;

  if not ZpSetOptions(ZipOptions) then begin
    raise Exception.Create('Failed to set Zip Options.');
  end;
end;

function TtsqZip.GetZip32DLLVersion: string;
begin
  Result := 'v' + GetZipVersion(True);
end;

procedure TtsqZip.SetZip32DLLVersion(const PVersion: string);
begin
  //does nothing. Do not put code here.
end;

function TtsqZip.GetVersion: string;
begin
  Result := CTtsqZipVersion;
end;

procedure TtsqZip.SetVersion(const PVersion: string);
begin
  //does nothing. Do not put code here.
end;

initialization
//

finalization
  UnLoadZip32DLL(True {force to unload zip32.dll});

end.

