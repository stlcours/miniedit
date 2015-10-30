unit DebugClasses;
{$mode objfpc}{$H+}
{$ModeSwitch advancedrecords}
{$INTERFACES CORBA}
{**
 * Mini Edit
 *
 * @license    GPL 2 (http://www.gnu.org/licenses/gpl.html)
 * @author    Zaher Dirkey <zaher at parmaja dot com>
 *}

interface

uses
  Classes, SysUtils, Contnrs;

type

  TmneRunMode = (runShell, runConsole, runTerminal, runProcess, runURL);

  { TmneRunInfo }

  TmneRunInfo = record
    Root: string; //cur dir for the project
    Mode: TmneRunMode;
    Pause: Boolean;
    URL: string;
    Command: string; //file to run
    Params: string; //file to run
    RunFile: string; //file to run
    function GetCommandLine: string;
  end;

  TDebugWatchInfo = record
    VarName: string;
    VarType: string;
    Value: variant;
  end;

  TDebugBreakpointInfo = record
    Handle: Integer;
    FileName: string;
    Line: Integer;
  end;

  { TCallStackItem }

  TCallStackItem = class(TObject)
  private
    FLine: Integer;
    FFileName: string;
  public
  published
    property FileName: string read FFileName write FFileName;
    property Line: integer read FLine write FLine;
  end;

  { TCallStackItems }

  TCallStackItems = class(TObjectList)
  private
    function GetItem(Index: integer): TCallStackItem;
  protected
  public
    function Add(vItem: TCallStackItem): integer; overload;
    function Add(FileName: string; Line: integer): integer; overload;
    procedure AssignFrom(vItems: TCallStackItems);
    property Items[Index: integer]: TCallStackItem read GetItem; default;
  end;

implementation

{ TmneRunInfo }

function TmneRunInfo.GetCommandLine: string;
begin
  Result := Command;
  if Params <> '' then
    Result := Result + ' ' + Params;
  if RunFile <> '' then
    Result := Result + ' ' + RunFile;
end;

{ TCallStackItems }

function TCallStackItems.GetItem(Index: integer): TCallStackItem;
begin
  Result := inherited Items[Index] as TCallStackItem;
end;

function TCallStackItems.Add(vItem: TCallStackItem): integer;
begin
  Result := inherited Add(vItem);
end;

function TCallStackItems.Add(FileName: string; Line: integer): integer;
var
  aItem: TCallStackItem;
begin
  aItem := TCallStackItem.Create;
  aItem.FileName := FileName;
  aItem.Line := Line;
  Result := Add(aItem);
end;

procedure TCallStackItems.AssignFrom(vItems: TCallStackItems);
var
  i: Integer;
begin
  Clear;
  if vItems <> nil then
    for i := 0 to vItems.Count -1 do
    begin
       Add(vItems[i].FileName, vItems[i].Line);
    end;
end;

end.

