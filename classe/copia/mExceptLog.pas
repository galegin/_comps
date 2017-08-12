unit mExceptLog;

// Delphi Exception Logger
// http://www.jirihajek.net/delphi/ExceptLog.htm
// (c) Jiri Hajek 2003-2005
// E-mail: jh@jirihajek.net
// Created for MediaMonkey (http://www.mediamonkey.com), a free mp3 jukebox player and music library organizer

// Purpose: When you include this unit in your project, all exceptions that happens at run-time
// are automatically logged together with exception message, information about source of the
// exception and call stack content together with source files and line numbers information.

// Environment:
//  This unit was tested under Delphi 7, it would probably work under other Delphi versions
//  as well, but it might need some modifications in some magic constants in the code below.

// Usage:
//  1. Include this unit in your project
//  2. You'll also need an excellent leak detector for Delphi, MemCheck, from here:
//             http://v.mahon.free.fr/pro/freeware/memcheck/
//      (Exception Logger uses its methods to analyze callstack)
//  3. Modify OutputFile constant below so that logs are written to a file you want.
//  4. Recommended: Set your compiler options for debugging, this is described here:
//             http://v.mahon.free.fr/pro/freeware/memcheck/project_options.htm
//     It's a good idea to turn on "Project|Options|Linker|Include TD32 debug info"
//     because then you get complete reports about source files, procedure names and line numbers.
//     On the other hand, it makes your compiled exe file much bigger.
//  5. Compile and run! You can distribute such compiled file even to your users and they can
//     directly report any problem to you. Any exception that happens is written to the OutputFile
//     as specified below. It is also reported using OutputDebugString() method and so it can
//     be trapped for example by Debug View application from System Internals.

// License:
//   You can use this unit for any purpose, even commercial, as long as you leave this header here.
//   Author cannot be blamed for any problem with this unit. If you don't agree, don't use it.

interface

implementation

uses
  SysUtils, Windows, mMemCheck, mPath, mProjeto;

var
  OutputFile : String = 'except.log';

type
  PExceptionRecord = ^TExceptionRecord;
  TExceptionRecord =
  record
    ExceptionCode : LongWord;
    ExceptionFlags : LongWord;
    OuterException : PExceptionRecord;
    ExceptionAddress : Pointer;
    NumberParameters : Longint;
    case {IsOsException:} Boolean of
    True: (ExceptionInformation : array [0..14] of Longint);
    False: (ExceptAddr: Pointer; ExceptObject: Pointer);
  end;

var
  oldRTLUnwindProc : procedure; stdcall;
  writeToFile : boolean = false;

procedure MyRtlUnwind; stdcall;
var
  PER : PExceptionRecord;

  procedure DoIt;
  var             // This is done in a sub-routine because string variable is used and we want it finalized
    s : string;
    E : Exception;
    CS : TCallStack;
    t : TextFile;
  begin
    s := '--------------------------------------------------------'#13#10;
    s := s + 'New exception:'#13#10;

    if PER^.ExceptionFlags and 1=1 then begin // This seems to be an indication of internal Delphi exception,
                                              // thus we can access 'Exception' class
      try
        E := Exception(PER^.ExceptObject);
        if (E is Exception) then
          s := s + 'Delphi exception, type ' + E.ClassName + ', message: ' + E.Message + #13#10;
      except
      end;
    end;

    FillCallStack(CS, 5);    // 5 last entries seem to be unusable
    s := s + 'Date/Time: ' + FormatDateTime('yyyy/mm/dd hh:nn:ss', Now) + #13#10 +
             'Exception code: ' + IntToStr(PER^.ExceptionCode) + #13#10 +
             'Exception flags: ' + IntToStr(PER^.ExceptionFlags) + #13#10 +
             'Number of parameters: ' + IntToStr(PER^.NumberParameters) + #13#10 +
             TextualDebugInfoForAddress(Cardinal(PER^.ExceptionAddress)) + #13#10 +
             CallStackTextualRepresentation(CS, '') + #13#10 ;

    OutputDebugString(PChar(s));

    if writeToFile then begin
      try
        Assign(t, OutputFile);
        Append(t);
        Writeln(t, s);
        Close(t);
      except
      end;
    end;
  end;
begin
  asm
    mov eax, dword ptr [EBP+8+13*4] // magic numbers - works for Delphi 7
    mov PER, eax
  end;

  DoIt;
    
  asm
    mov esp, ebp
    pop ebp
    jmp oldRTLUnwindProc
  end;
end;

procedure InitExceptionLogging;
var
  f : TextFile;
begin
  try
    Assign(f, OutputFile);
    if FileExists(OutputFile) then
      Append(f)
    else
      Rewrite(f);
    Close(f);
    writeToFile := true;
  except
    writeToFile := false;
  end;
  oldRTLUnwindProc := RTLUnwindProc;
  RTLUnwindProc := @MyRtlUnwind;
end;

function GetNmOutputFile() : String;
begin
  Result := TmPath.Log() + mProjeto.Instance.Codigo + '.' + FormatDateTime('yyyymmdd', Date) + '.except';
  Result := Result;
end;

initialization
  OutputFile := GetNmOutputFile();
  InitExceptionLogging;

end.
