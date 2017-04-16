(*

-----------------------------------------------------------------------------------------
                                     STATE
-----------------------------------------------------------------------------------------
 THIS SOFTWARE IS FREEWARE AND IS PROVIDED AS IS AND COMES WITH NO WARRANTY OF ANY
 KIND, EITHER EXPRESSED OR IMPLIED. IN NO EVENT WILL THE AUTHOR(S) BE LIABLE FOR
 ANY DAMAGES RESULTING FROM THE USE OF THIS SOFTWARE.
-----------------------------------------------------------------------------------------
                                  INFORMATION
-----------------------------------------------------------------------------------------
 Description : Info-Zip's header files for its UnZip32.dll ( version 5.4 ) translated to
               Pascal (Delphi)
 Tested      : Delphi 2, 3, 4, 5
 Author      : Theo Bebekis <bebekis@otenet.gr> 
 More info   : For more information and information regarding Copyright and Distribution
               rights of the Info-Zip's work contact Info-Zip at
               http://www.cdrom.com/pub/infozip/
               InfoZip provides the Wiz.exe, a Windows application for zipping and
               unzipping files. You can find examples for the dll calls in the Wiz.exe
               sources (C language) which you can obtain from the above site.
 License     : Check Info-Zip's license in the accompanying license.htm
 Thanks to   : Davide Moretti
	       Marcel van Brakel
	       Rudy Velthuis
	       Danny Thorpe
               from the Delphi-JEDI@onelist.com mailing list who helped me with their
               advises to finish this translation.
 JEDI        : http://www.delphi-jedi.org/
-----------------------------------------------------------------------------------------
                                     HISTORY
-----------------------------------------------------------------------------------------
 Version   Date          Changes - Additions                                By
-----------------------------------------------------------------------------------------
 0.01      30.06.1999    Initial Version                                    Theo Bebekis
 0.02      28.08.2003    Updated to unzip v5.5                              Siqing Tang
                                                                            tsq@softhome.net
-----------------------------------------------------------------------------------------

*)

unit UnZip32;


interface


uses
  Windows;




const
  UNZIP_DLL = 'UNZIP32.DLL';


{ unzver.h }
const
  UNZIP_DLL_VERSION = '5.5';
  COMPANY_NAME = 'Info-ZIP';


{ windll.h }
const
  IDM_REPLACE_NO        = 100;
  IDM_REPLACE_TEXT      = 101;
  IDM_REPLACE_YES       = 102;
  IDM_REPLACE_ALL       = 103;
  IDM_REPLACE_NONE      = 104;
  IDM_REPLACE_RENAME    = 105;
  IDM_REPLACE_HELP      = 106;


{ structs.h }
const
  PATH_MAX = 260;

{ user functions for use with the TUserFunctions structure }
type
  TDllPrnt = function(Buffer: PChar; Size: ULONG): integer; stdcall; //Sqing: LPSTR, unsigned long)
  TDllPassword = function(P: PChar; N: Integer; M, Name: PChar): integer; stdcall;
  TDllService = function (CurFile: PChar; Size: ULONG): integer; stdcall;
  TDllSnd = procedure; stdcall;
  TDllReplace = function(FileName: PChar): integer; stdcall;
  TDllMessage = procedure (UnCompSize : ULONG;
                           CompSize   : ULONG;
                           Factor     : UINT;
                           Month      : UINT;
                           Day        : UINT;
                           Year       : UINT;
                           Hour       : UINT;
                           Minute     : UINT;
                           C          : Char;
                           FileName   : PChar;
                           MethBuf    : PChar;
                           CRC        : ULONG;
                           Crypt      : Char); stdcall;


type
  PUserFunctions = ^TUnzipUserFunctions;
  USERFUNCTIONS = packed record
    Print                  : TDllPrnt;
    Sound                  : TDllSnd;
    Replace                : TDllReplace;
    Password               : TDllPassword;
    SendApplicationMessage : TDllMessage;
    ServCallBk             : TDllService;
    TotalSizeComp          : ULONG;
    TotalSize              : ULONG;
    CompFactor             : ULONG; //Siqing's change: changed from Integer
    NumMembers             : ULONG; //Siqing's change: changed from UINT. But ULONG = UINT.
    cchComment             : Word;  //Siqing's fix: changed from UINT(bug!)
  end;
  // TUserFunctions = USERFUNCTIONS;
  TUnzipUserFunctions = USERFUNCTIONS;


  { unzip options }
type
  PDCL = ^TDCL;
  DCL = packed record
    ExtractOnlyNewer  : Integer; { true if you are to extract only newer }
    SpaceToUnderscore : Integer; { true if convert space to underscore }
    PromptToOverwrite : Integer; { true if prompt to overwrite is wanted }
    fQuiet            : Integer; { quiet flag. 1 = few messages, 2 = no messages, 0 = all messages }
    nCFlag            : Integer; { write to stdout if true }
    nTFlag            : Integer; { test zip file }
    nVFlag            : Integer; { 0: Extract or 1: List Contents}
    nfFlag            : Integer; { Freshen Existing} //it used be called nUFlag, Siqing Tang 
    nZFlag            : Integer; { display zip file comment }
    nDFlag            : Integer; { Honour Directories. (sub)directory recreation}
          // 0 = junk paths from filenames
          // 1 = "safe" usage of paths in filenames (skip "../" components)
          // 2 = allow also unsafe path components (directory traversal)
    nOFlag            : Integer; { true if you are to always over-write files, false if not }
    nAFlag            : Integer; { Convert CR to CRLF}
    nZIFlag           : Integer; { get zip info if true }
    C_flag            : Integer; { be case insensitive if TRUE }
    fPrivilege        : Integer; { 1 => restore Acl's, 2 => Use privileges }
    lpszZipFN         : PChar;   { zip file name }
    lpszExtractDir    : PChar;   { Directory to extract to. NULL for the current directory }
  end ;
  TDCL = DCL;


{ unzip.h }
type
  _UzpBuffer = packed record        { rxstr }
    StrLength : ULONG;       { length of string }
    StrPtr    : PChar;       { pointer to string }
  end ;
  TUzpBuffer = _UzpBuffer;
  
type
{  intended to be a private struct  }
  _ver = packed record
    Major      : UCHAR;        { e.g., integer 5 }
    Minor      : UCHAR;        { e.g., 2 }
    PatchLevel : UCHAR;        { e.g., 0 }
    Not_Used   : UCHAR;
  end ;
  TVersionType = _ver;

type
  PUzpVer = ^TUzpVer;
  _UzpVer = packed record
    StructLen    : ULONG;          { length of the struct being passed }
    Flag         : ULONG;          { bit 0: is_beta bit 1: uses_zlib }
    BetaLevel    : PChar;          { e.g., "g BETA" or "" }
    Date         : PChar;          { e.g., "4 Sep 95" (beta) or "4 September 1995" }
    ZLib_Version : PChar;          { e.g., "0.95" or NULL }
    UnZip        : TVersionType;
    ZipInfo      : TVersionType;
    OS2Dll       : TVersionType;
    WinDll       : TVersionType;
  end;
  TUzpVer = _UzpVer;

{ for Visual BASIC access to Windows DLLs }
type
  _UzpVer2 = record
    StructLen     : ULONG;                    { length of the struct being passed }
    Flag          : ULONG;                    { bit 0: is_beta bit 1: uses_zlib }
    BetaLevel     : array[0..10-1] of Char;   { e.g., "g BETA" or "" }
    Date          : array[0..20-1] of Char;   { e.g., "4 Sep 95" (beta) or "4 September 1995" }
    ZLib_Version  : array[0..10-1] of Char;   { e.g., "0.95" or NULL }
    UnZip         : TVersionType;
    ZipInfo       : TVersionType;
    OS2Dll        : TVersionType;
    WinDll        : TVersionType;
  end ;
  TUzpVer2 = _UzpVer2;

// what about "typedef struct central_directory_file_header { /* CENTRAL */" siqing?

const
  UZPVER_LEN = SizeOf(TUzpVer);

{ Return (and exit) values of the public UnZip API functions. }
const
{ external return codes  }
  PK_OK                 = 0; { no error }
  PK_COOL               = 0; { no error }
  PK_GNARLY             = 0; { no error }
  PK_WARN               = 1; { warning error }
  PK_ERR                = 2; { error in zipfile }
  PK_BADERR             = 3; { severe error in zipfile }
  PK_MEM                = 4; { insufficient memory (during initialization) }
  PK_MEM2               = 5; { insufficient memory (password failure) }
  PK_MEM3               = 6; { insufficient memory (file decompression) }
  PK_MEM4               = 7; { insufficient memory (memory decompression) }
  PK_MEM5               = 8; { insufficient memory (not yet used) }
  PK_NOZIP              = 9; { zipfile not found }
  PK_PARAM              = 10; { bad or illegal parameters specified }
  PK_FIND               = 11; { no files found }
  PK_DISK               = 50; { disk full }
  PK_EOF                = 51; { unexpected EOF }

  IZ_CTRLC              = 80; { user hit ^C to terminate }
  IZ_UNSUP              = 81; { no files found: all unsup. compr/encrypt. }
  IZ_BADPWD             = 82; { no files found: all had bad password }

{ internal and DLL-only return codes  }
  IZ_DIR                = 76; { potential zipfile is a directory }
  IZ_CREATED_DIR        = 77; { directory created: set time and permissions }
  IZ_VOL_LABEL          = 78; { volume label, but can't set on hard disk }
  IZ_EF_TRUNC           = 79; { local extra field truncated (PKZIP'd) }

{ return codes of password fetches (negative = user abort; positive = error)  }
  IZ_PW_ENTERED          = 0; { got some password string; use/try it }
  IZ_PW_CANCEL           = -1; { no password available (for this entry) }
  IZ_PW_CANCELALL        = -2; { no password, skip any further pwd. request }
  IZ_PW_ERROR            = 5; { = PK_MEM2 : failure (no mem, no tty, ...) }

{ flag values for status callback function  }
  UZ_ST_START_EXTRACT    = 1;
  UZ_ST_IN_PROGRESS      = 2;
  UZ_ST_FINISH_MEMBER    = 3;

{ return values of status callback function  }
  UZ_ST_CONTINUE         = 0;
  UZ_ST_BREAK            = 1;


type
  PPChar = ^PChar;

  { dll prototypes }

{ I prefer to load these functions dynamically, so I comment out all the
  following stuff and they are declared in my component uni: tsqUnZip.pas
  Siqing Tang, 31 August 2003
}

  { decs.h }
//procedure  Wiz_NoPrinting(Flag: Integer); stdcall;
//function   Wiz_Validate(Archive: PChar;  AllCodes: Integer): Integer; stdcall;
//function   Wiz_Init(var pG; var UserFunc: TUserFunctions): Bool; stdcall;
//function   Wiz_SetOpts(var pG; var Options: TDCL): Bool; stdcall;
//function   Wiz_Unzip(var pG; ifnc: Integer; ifnv: PPChar; xfnc: Integer; xfnv: PPChar): Integer; stdcall;
//function   Wiz_SingleEntryUnzip(ifnc: Integer; ifnv: PPChar; xfnc: Integer;
//                                xfnv: PPChar; var Options: TDCL;
//                                var UserFunc: TUserFunctions): Integer; stdcall;
//function   Wiz_UnzipToMemory(Zip: PChar;  FileName: PChar; var UserFunctions: TUserFunctions;
//                             var RetStr: TUzpBuffer): Integer; stdcall;
//function   Wiz_Grep(Archive: PChar; FileName: PChar; Pattern: PChar; Cmd: Integer;
//                    SkipBin: Integer; var UserFunctions: TUserFunctions): Integer; stdcall;
//
//  { unzip.h }
//procedure  UzpFreeMemBuffer(var RetStr: TUzpBuffer); stdcall;
//function   UzpVersion: PUzpVer; stdcall;
//procedure  UzpVersion2(var Version: TUzpVer2); stdcall;
//
//  { helper }
function IsExpectedUnZipDllVersion: boolean;

implementation

uses
  DLLCheckerUtl;

{ I prefer to load these functions dynamically, so I comment out all the
  following stuff and they are declared in my component uni: tsqZip.pas
  Siqing Tang, 31 August 2003
}

  { dll routines }

  { decs.h }
//procedure  Wiz_NoPrinting; external UNZIP_DLL name 'Wiz_NoPrinting';
//function   Wiz_Validate; external UNZIP_DLL name 'Wiz_Validate';
//function   Wiz_Init; external UNZIP_DLL name 'Wiz_Init';
//function   Wiz_SetOpts; external UNZIP_DLL name 'Wiz_SetOpts';
//function   Wiz_Unzip; external UNZIP_DLL name 'Wiz_Unzip';
//function   Wiz_SingleEntryUnzip; external UNZIP_DLL name 'Wiz_SingleEntryUnzip';
//function   Wiz_UnzipToMemory; external UNZIP_DLL name 'Wiz_UnzipToMemory';
//function   Wiz_Grep; external UNZIP_DLL name 'Wiz_Grep';

  { unzip.h }
//procedure  UzpFreeMemBuffer; external UNZIP_DLL name 'UzpFreeMemBuffer';
//function   UzpVersion; external UNZIP_DLL name 'UzpVersion';
//procedure  UzpVersion2; external UNZIP_DLL name 'UzpVersion2';


// Get_FileVersionInfo() is moved from this unit to DLLCheckerUtl
// by Siqing Tang

function IsExpectedUnZipDllVersion: boolean;
begin
  Result := IsExpectedDllVersion(UNZIP_DLL, UNZIP_DLL_VERSION, COMPANY_NAME);
end;

end.




