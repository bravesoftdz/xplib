{$IFDEF ShellPIDL}
{$DEFINE DEBUG_UNIT}
{$ENDIF}
{$I ShellLib.inc}
{$WARN SYMBOL_PLATFORM OFF } //Uma cacetada de simbolos de plataforma
unit ShellPIDL;

interface

uses Windows, Winapi.ShlObj;

{ ************************************************  Public enumerated types ******************************************************* }
type
	TkbsdSpecialLocation = (kbsdPath, rfDesktop, rfPrograms, rfControlPanel, rfPrinters, rfPersonal { Meus Documentos },
		{ TODO -oRoger -cLIB : Retomar conversao das enumeracoes }
		kbsdFavorites, kbsdStartup, kbsdRecent, kbsdSendTo, kbsdRecycleBin, kbsdStartMenu, kbsdDesktopDirectory, kbsdDrives,
		kbsdNetwork, kbsdNethoodDirectory, kbsdFonts, kbsdTemplates, kbsdCommonStartMenu, kbsdCommonProgramFiles, kbsdCommonStartup,
		kbsdCommonDesktopDirectory, kbsdCommonAppData, kbsdCommonPrinters);

	TRootFolder = (rfMyComputer, rfNetwork, rfRecycleBin, rfAppData, rfCommonDesktopDirectory, rfCommonPrograms, rfCommonStartMenu,
		rfCommonStartup, rfDesktopDirectory, rfFavorites, rfFonts, rfInternet, rfPrintHood, rfRecent, rfSendTo, rfStartMenu,
		rfStartup, rfTemplates);

	{ ************************************** Public set types ***************************************** }
type
	TkbsdSpecialLocations = set of TkbsdSpecialLocation;

	{ ************************************ Public PIDL manipulation method interfaces ******************************************* }
//procedure FreePIDL(PIDL: PItemIDList); stdcall;
function GetPathFromPIDL(AbsolutePIDL: PItemIDList): string; stdcall;
function GetPIDLFromPath(ThePath: string): PItemIDList; stdcall;
function GetSpecialLocationPIDL(Location: TkbsdSpecialLocation): PItemIDList; stdcall;

// ******************************************************
//Public enum/const conversion function interfaces
// ******************************************************
function SpecialLocationEnumToConst(Location: TkbsdSpecialLocation): DWORD;
function SpecialLocationConstToEnum(Location: DWORD): TkbsdSpecialLocation;

implementation

uses SysUtils;

{ ******************************* Private unit constants ****************************************** }
const
	Shell32 = 'shell32.dll';

	// *******************************************************
	//Public PIDL manipulation method implementations
	// *******************************************************
//procedure FreePIDL; external Shell32 index 155; //Frees a PIDL.  Direct call to undocumented Windows function.

function GetPathFromPIDL(AbsolutePIDL: PItemIDList): string; stdcall; //Gets a DOS path from a PIDL. Requires an absolute PIDL.
var
	PathBuffer: array[0 .. MAX_PATH] of Char;
begin
	{ Initialize return value. }
	Result := EmptyStr;

	{ Check that the PIDL parameter is not nil. }
	if (AbsolutePIDL = nil) then begin
		Exit;
	end;

	{ Convert the absolute PIDL into a DOS path and return the string. }
	SHGetPathFromIDList(AbsolutePIDL, PathBuffer);
	Result := StrPas(PathBuffer);
end;

function GetPIDLFromPath(ThePath: string): PItemIDList; stdcall;
{ Creates an absolute PIDL from a DOS path string.  The PIDL must be freed with the OLE allocator after use, as usual. }
var
	Buffer: array[0 .. MAX_PATH] of WideChar;
begin
	{$WARN UNSAFE_CODE OFF}
	StringToWideChar(ThePath, Buffer, (high(Buffer) - low(Buffer) + 1));
	{ Convert Path into PIDL }
	Result := ILCreateFromPath(Buffer);
	{$WARN UNSAFE_CODE ON}
end;

function GetSpecialLocationPIDL(Location: TkbsdSpecialLocation): PItemIDList; stdcall;
{ Retrieves an absolute PIDL to a special folder location. The PIDL must be freed with the OLE allocator after use, as usual. }
begin
	SHGetSpecialFolderLocation(0, SpecialLocationEnumToConst(Location), Result);
end;

{ ******************************  Public enum/const conversion function implementations ********************************* }
function SpecialLocationEnumToConst(Location: TkbsdSpecialLocation): DWORD;
begin
	case (Location) of
		kbsdPath:
			Result := 0;
		rfDesktop:
			Result := CSIDL_DESKTOP;
		rfPrograms:
			Result := CSIDL_PROGRAMS;
		rfControlPanel:
			Result := CSIDL_CONTROLS;
		rfPrinters:
			Result := CSIDL_PRINTERS;
		rfPersonal { My Docs }:
			Result := CSIDL_PERSONAL;
		kbsdFavorites:
			Result := CSIDL_FAVORITES;
		kbsdStartup:
			Result := CSIDL_STARTUP;
		kbsdRecent:
			Result := CSIDL_RECENT;
		kbsdSendTo:
			Result := CSIDL_SENDTO;
		kbsdRecycleBin:
			Result := CSIDL_BITBUCKET;
		kbsdStartMenu:
			Result := CSIDL_STARTMENU;
		kbsdDesktopDirectory:
			Result := CSIDL_DESKTOPDIRECTORY;
		kbsdDrives:
			Result := CSIDL_DRIVES;
		kbsdNetwork:
			Result := CSIDL_NETWORK;
		kbsdNethoodDirectory:
			Result := CSIDL_NETHOOD;
		kbsdFonts:
			Result := CSIDL_FONTS;
		kbsdTemplates:
			Result := CSIDL_TEMPLATES;
		kbsdCommonStartMenu:
			Result := CSIDL_COMMON_STARTMENU;
		kbsdCommonProgramFiles:
			Result := CSIDL_COMMON_PROGRAMS;
		kbsdCommonStartup:
			Result := CSIDL_COMMON_STARTUP;
		kbsdCommonDesktopDirectory:
			Result := CSIDL_COMMON_DESKTOPDIRECTORY;
		kbsdCommonAppData:
			Result := CSIDL_APPDATA;
		kbsdCommonPrinters:
			Result := CSIDL_PRINTHOOD;
	else
		Result := 0;
	end;
end;

function SpecialLocationConstToEnum(Location: DWORD): TkbsdSpecialLocation;
begin
	case (Location) of
		CSIDL_DESKTOP:
			Result := rfDesktop;
		CSIDL_PROGRAMS:
			Result := rfPrograms;
		CSIDL_CONTROLS:
			Result := rfControlPanel;
		CSIDL_PRINTERS:
			Result := rfPrinters;
		CSIDL_PERSONAL:
			Result := rfPersonal { My Docs };
		CSIDL_FAVORITES:
			Result := kbsdFavorites;
		CSIDL_STARTUP:
			Result := kbsdStartup;
		CSIDL_RECENT:
			Result := kbsdRecent;
		CSIDL_SENDTO:
			Result := kbsdSendTo;
		CSIDL_BITBUCKET:
			Result := kbsdRecycleBin;
		CSIDL_STARTMENU:
			Result := kbsdStartMenu;
		CSIDL_DESKTOPDIRECTORY:
			Result := kbsdDesktopDirectory;
		CSIDL_DRIVES:
			Result := kbsdDrives;
		CSIDL_NETWORK:
			Result := kbsdNetwork;
		CSIDL_NETHOOD:
			Result := kbsdNethoodDirectory;
		CSIDL_FONTS:
			Result := kbsdFonts;
		CSIDL_TEMPLATES:
			Result := kbsdTemplates;
		CSIDL_COMMON_STARTMENU:
			Result := kbsdCommonStartMenu;
		CSIDL_COMMON_PROGRAMS:
			Result := kbsdCommonProgramFiles;
		CSIDL_COMMON_STARTUP:
			Result := kbsdCommonStartup;
		CSIDL_COMMON_DESKTOPDIRECTORY:
			Result := kbsdCommonDesktopDirectory;
		CSIDL_APPDATA:
			Result := kbsdCommonAppData;
		CSIDL_PRINTHOOD:
			Result := kbsdCommonPrinters;
	else
		Result := kbsdPath;
	end;
end;

function GetPIDLSize(PIDL: PItemIDList): Integer;
var
	CurrentID: PShItemID;
begin
	{ Check PIDL is not nil... }
	if (PIDL <> nil) then begin
		{ There will always be at least two bytes for the terminating cb. }
		Result := SizeOf(CurrentID.cb);
		{ Initialize the local item id pointer and walk through the list until the terminating cb = 0 is encountered.  Add the value of
		  each cb along the way to the result. }
		CurrentID := PShItemID(PIDL);
		while (CurrentID.cb) <> 0 do begin
			Inc(Result, CurrentID.cb);
			Inc(PChar(CurrentID), CurrentID.cb);
		end
	end else begin { If PIDL is nil, return 0 size }
		Result := 0;
	end;
end;

end.
