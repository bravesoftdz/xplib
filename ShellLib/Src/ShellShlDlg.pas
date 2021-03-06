{$IFDEF ShellShlDlg}
{$DEFINE DEBUG_UNIT}
{$ENDIF}
{$I ShellLib.inc}
{$WARN SYMBOL_PLATFORM OFF }  //� uma festa de simbolos exclusivos do Windows aqui

{TODO -oroger -clib : Extrair isoladamente todos os componentes que possam deixar de ser dependentes da plataforma e implementados com o firedac}

//diretivas originais abaixo
{ -$IFDEF ShellShlDlg }
{ -$A+,B-,C-,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O-,P+,Q-,R+,S-,T-,U-,V+,W-,X+,Y+,Z1 }
{ -$DEBUGINFO ON }
{ -$ELSE }
{ -$A+,B-,C-,D-,E-,F-,G+,H+,I+,J+,K-,L-,M-,N+,O+,P+,Q+,R+,S-,T-,U-,V+,W-,X+,Y-,Z4 }
{ -$ENDIF }

unit ShellShlDlg deprecated;

interface

uses Windows, Messages, ShlObj, SysUtils, Classes, Forms, Graphics, ShellPIDL, ShellAPIFuncs;

{ ******************************* Undocumented Windows Shell Dialog API interface ****************************************** }

const                         { SHFormatDrive FormatID parameter values }
	SHFMT_ID_DEFAULT = $FFFF; { Use the default format scheme }

const                          { SHFormatDrive Options parameter flags }
	SHFMT_OPT_FULL    = $0001; { Check "Quick Format" by default. }
	SHFMT_OPT_SYSONLY = $0002; { Check "Sys Only" by default. }

const                           { SHFormatDrive returned error values }
	SHFMT_ERROR    = $FFFFFFFF; { Error on last format, but drive may be formattable }
	SHFMT_CANCEL   = $FFFFFFFE; { Last format was canceled }
	SHFMT_NOFORMAT = $FFFFFFFD; { Drive is not formatable }

const                        { RunFileDlg Flags }
	RFF_NOBROWSE      = $01; { Removes the browse button }
	RFF_NODEFAULT     = $02; { No default item selected }
	RFF_CALCDIRECTORY = $04; { Determines the work directory from the file name. }
	RFF_NOLABEL       = $08; { Removes the edit box label }
	RFF_NOSEPARATEMEM = $20; { Removes the Separate Memory Space check box }

type { RunFileDlg record type }
	TNM_RunFileDlg = packed record
		hdr: TNMHdr;
		lpFile: Pointer;
		lpDirectory: Pointer;
		nShow: longbool;
	end;

	PNM_RunFileDlg = ^TNM_RunFileDlg;

const { RunFileDlg Notification Code }
	RFN_VALIDATE = -510;

const                { RunFileDlg notification message return values }
	RF_OK     = $00; { Allow the application to run }
	RF_CANCEL = $01; { Cancel the operation and close the dialog }
	RF_RETRY  = $02; { Cancel the operation, but leave the dialog open }

const { Additional flags for RestartDialog }
	EW_RESTARTWINDOWS = $42;
	EW_REBOOTSYSTEM   = $43;
	EW_EXITANDEXECAPP = $44;

const { SHObjectProperties Flags }
	OPF_PRINTERNAME = $01;
	OPF_PATHNAME    = $02;

	//Inicio das rotinas implementadas de forma mais segura
function SHNetConnectionDialog(Owner: HWND; ResourceName: Pointer; ResourceType: DWORD): DWORD; stdcall;

//fim das rotinas implementadas de forma mais segura

procedure RunFileDlg(Owner: HWND; IconHandle: HICON; WorkPath: Pointer; Caption: Pointer; Description: Pointer;
	Flags: UINT); stdcall;

function SHFindFiles(Root: PItemIDList; SavedSearchFile: PItemIDList): longbool; stdcall;

function SHFindComputer(Reserved1: PItemIDList; Reserved2: PItemIDList): longbool; stdcall;

procedure ExitWindowsDialog(Owner: HWND); stdcall;

function RestartDialog(Owner: HWND; Reason: Pointer; Flags: UINT): DWORD; stdcall;

function GetFileNameFromBrowse(Owner: HWND; FileName: Pointer; MaxFileNameChars: DWORD; InitialDirectory: Pointer;
	DefaultExtension: Pointer; Filter: Pointer; Caption: Pointer): longbool; stdcall;

function SHObjectProperties(Owner: HWND; Flags: UINT; ObjectName: Pointer; InitialTabName: Pointer): longbool; stdcall;

function SHStartNetConnectionDialog(Owner: HWND; ResourceName: PWideChar; ResourceType: DWORD): DWORD; stdcall;

function SHOutOfMemoryMessageBox(Owner: HWND; Caption: Pointer; Style: UINT): Integer; stdcall;

procedure SHHandleDiskFull(Owner: HWND; uDrive: UINT); stdcall;

function ShellMessageBox(Instance: THandle; Owner: HWND; Text: PWideChar; Caption: PWideChar; Style: UINT;
	Parameters: array of Pointer): Integer; cdecl;

function ShellMessageBoxA(Instance: THandle; Owner: HWND; Text: PChar; Caption: PChar; Style: UINT; Parameters: array of Pointer)
	: Integer; cdecl;

function ShellMessageBoxW(Instance: THandle; Owner: HWND; Text: PWideChar; Caption: PWideChar; Style: UINT;
	Parameters: array of Pointer): Integer; cdecl;

{ ********************************************** Public enumerated types ***************************************************** }
type
	TkbBrowseFilter = (kbsdBrowseForAnything, kbsdBrowseForComputers, kbsdBrowseForDirectories, kbsdBrowseForFileAncestors,
		kbsdBrowseForPrinters);

	TkbOKState = (kbsdDefaultState, kbsdEnableOK, kbsdDisableOK);

	TkbDriveLetter = (kbsdDriveA, kbsdDriveB, kbsdDriveC, kbsdDriveD, kbsdDriveE, kbsdDriveF, kbsdDriveG, kbsdDriveH, kbsdDriveI,
		kbsdDriveJ, kbsdDriveK, kbsdDriveL, kbsdDriveM, kbsdDriveN, kbsdDriveO, kbsdDriveP, kbsdDriveQ, kbsdDriveR, kbsdDriveS,
		kbsdDriveT, kbsdDriveU, kbsdDriveV, kbsdDriveW, kbsdDriveX, kbsdDriveY, kbsdDriveZ);

	TkbFormatResult = (kbsdFormatSucceeded, kbsdFormatCancelled, kbsdDriveNotFormattable, kbsdFormatError);

	TkbRestartOption = (kbsdLogoff, kbsdShutdown, kbsdReboot, kbsdRestartWindows, kbsdRebootSystem, kbsdExitAndExecApp);

	TkbShellObjectType = (kbsdPathObject, kbsdPrinterObject);

	TkbRunFileOption = (kbsdNoBrowseButton, kbsdNoDefaultPick, kbsdCalculateWorkPath, kbsdNoEditLabel, kbsdNoSeparateMemory);

	TkbRunFileAction = (kbsdRun, kbsdCancel, kbsdRetry);

	TkbNetResourceType = (kbsdDiskResource, kbsdPrintResource);

	{ **************************************************** Public set types ****************************************************** }

type
	TkbBrowseFilters = set of TkbBrowseFilter;

	TkbOKStates = set of TkbOKState;

	TkbDriveLetters = set of TkbDriveLetter;

	TkbFormatResults = set of TkbFormatResult;

	TkbRestartOptions = set of TkbRestartOption;

	TkbShellObjectTypes = set of TkbShellObjectType;

	TkbRunFileOptions = set of TkbRunFileOption;

	{ ******************************************* Public event procedural types ********************************************** }

	TkbBrowseChangeEvent = procedure(Sender: TObject; var Path: string; var StatusText: string; var OKState: TkbOKState) of object;
	TkbBrowseInitEvent   = procedure(Sender: TObject; DialogHandle: HWND) of object;
	TkbRunFileValidateEvent = procedure(Sender: TObject; TheFile: TFileName; TheWorkPath: TFileName; Visible: boolean;
		var Action: TkbRunFileAction) of object;

	{ ****************************************** TkbShellAboutDialog class interface ***************************************** }
type
	TkbShellAboutDialog = class(TComponent)
	public { Constructors/Destructors }
		constructor Create(TheOwner: TComponent); override;
		destructor Destroy; override;
	private { Private data members }
		FCaption  : string;
		FIcon     : TIcon;
		FOtherText: string;
		FProduct  : string;
	private { Private property writer methods }
		procedure SetIcon(NewValue: TIcon);
	private { Private property storage methods }
		function StoreIcon: boolean;
	public { Public methods }
		function Execute: boolean;
	published { Published properties }
		property Caption  : string read FCaption write FCaption;
		property Icon     : TIcon read FIcon write SetIcon stored StoreIcon;
		property OtherText: string read FOtherText write FOtherText;
		property Product  : string read FProduct write FProduct;
	end platform;

	{ *********************************** TkbBrowseForFolderDialog class interface ********************************************* }

	TkbBrowseForFolderDialog = class(TComponent)
	public { Constructors/Destructors }
		constructor Create(TheOwner: TComponent); override;
	private { Private data members }
		FCanExpandDomains: boolean;
		FCaption         : string;
		FDescription     : string;
		FDialogHandle    : HWND;
		FDisplayName     : string;
		FFilter          : TkbBrowseFilter;
		FInstructionText : string;
		FImageIndex      : DWORD;
		FImageLarge      : TBitmap;
		FImageSmall      : TBitmap;
		FOnChange        : TkbBrowseChangeEvent;
		FOnInitialize    : TkbBrowseInitEvent;
		FRootFolder      : TkbsdSpecialLocation;
		FRootPath        : TFileName;
		FShowStatusText  : boolean;
		FStatusText      : string;
	private
		function GetImage(Index: Integer): TBitmap;
	private
		procedure SetCaption(NewValue: string);
		procedure SetRootPath(NewValue: TFileName);
		procedure SetStatusText(NewValue: string);
	protected
		procedure Change(DialogHandle: HWND; PIDL: Pointer); dynamic;
		procedure Initialize(DialogHandle: HWND); dynamic;
	public { Public methods }
		function Execute: boolean;
	public { Public read-only properties }
		property Description: string read FDescription;
		property DisplayName: string read FDisplayName;
		property ImageIndex : DWORD read FImageIndex;
		property ImageLarge : TBitmap index 1 read GetImage;
		property ImageSmall : TBitmap index 2 read GetImage;
	published { Published properties }
		property CanExpandDomains: boolean read FCanExpandDomains write FCanExpandDomains default False;
		property Caption         : string read FCaption write SetCaption;
		property Filter          : TkbBrowseFilter read FFilter write FFilter default kbsdBrowseForAnything;
		property InstructionText : string read FInstructionText write FInstructionText;
		property RootFolder      : TkbsdSpecialLocation read FRootFolder write FRootFolder default rfDesktop;
		property RootPath        : TFileName read FRootPath write SetRootPath;
		property ShowStatusText  : boolean read FShowStatusText write FShowStatusText default False;
		property StatusText      : string read FStatusText write SetStatusText;
	published
		property OnChange    : TkbBrowseChangeEvent read FOnChange write FOnChange;
		property OnInitialize: TkbBrowseInitEvent read FOnInitialize write FOnInitialize;
	end;

	{ ************************************* TkbFormatDriveDialog class interface ******************************************* }
	TkbFormatDriveDialog = class(TComponent)
	public { Constructors/Destructors }
		constructor Create(TheOwner: TComponent); override;
	private
		FDefaultQuickFormat: boolean;
		FDefaultSysOnly    : boolean;
		FDriveToFormat     : TkbDriveLetter;
		FLastFormatID      : UINT;
		FRememberLastFormat: boolean;
		FSuppressARI       : boolean;
	public { Public methods }
		function Execute: TkbFormatResult;
	public
		property LastFormatID: UINT read FLastFormatID;
	published
		property DefaultQuickFormat: boolean read FDefaultQuickFormat write FDefaultQuickFormat default False;
		property DefaultSysOnly    : boolean read FDefaultSysOnly write FDefaultSysOnly default False;
		property DriveToFormat     : TkbDriveLetter read FDriveToFormat write FDriveToFormat default kbsdDriveA;
		property RememberLastFormat: boolean read FRememberLastFormat write FRememberLastFormat default True;
		property SuppressARI       : boolean read FSuppressARI write FSuppressARI default True;
	end;

	{ ********************************************** TkbPickIconDialog class interface ****************************************** }
	TkbPickIconDialog = class(TComponent)
	public { Constructors/Destructors }
		constructor Create(TheOwner: TComponent); override;
	private
		FFileName : TFileName;
		FIconIndex: Integer;
	public { Public methods }
		function Execute: Integer;
	published
		property FileName : TFileName read FFileName write FFileName;
		property IconIndex: Integer read FIconIndex write FIconIndex default 0;
	end;

	{ ********************************************** TkbRunFileDialog class interface ********************************************* }
	TkbRunFileDialog = class(TComponent)
	public { Constructors/Destructors }
		constructor Create(TheOwner: TComponent); override;
		destructor Destroy; override;
	private
		FCaption      : string;
		FDescription  : string;
		FIcon         : TIcon;
		FMessageWindow: HWND;
		FOptions      : TkbRunFileOptions;
		FWorkingPath  : TFileName;
	private
		FOnValidate: TkbRunFileValidateEvent;
	private
		procedure SetIcon(NewValue: TIcon);
	private
		function StoreIcon: boolean;
	private
		procedure HandleMessage(var TheMessage: TMessage);
		procedure Validate(TheFile: TFileName; TheWorkPath: TFileName; Visible: boolean; var Action: TkbRunFileAction);
	public { Public methods }
		procedure Execute;
	published
		property Caption    : string read FCaption write FCaption;
		property Description: string read FDescription write FDescription;
		property Icon       : TIcon read FIcon write SetIcon stored StoreIcon;
		property Options    : TkbRunFileOptions read FOptions write FOptions default [];
		property WorkingPath: TFileName read FWorkingPath write FWorkingPath;
	published
		property OnValidate: TkbRunFileValidateEvent read FOnValidate write FOnValidate;

	end;

	{ ************************************ TkbFindFilesDialog class interface *********************************************** }
	TkbFindFilesDialog = class(TComponent)
	public { Constructors/Destructors }
		constructor Create(TheOwner: TComponent); override;
	private
		FSearchFileName: TFileName;
		FRootFolder    : TkbsdSpecialLocation;
		FRootPath      : TFileName;
	private
		procedure SetRootPath(NewValue: TFileName);
	public { Public methods }
		function Execute: boolean;
	published
		property SearchFileName: TFileName read FSearchFileName write FSearchFileName;
		property RootFolder    : TkbsdSpecialLocation read FRootFolder write FRootFolder default rfDesktop;
		property RootPath      : TFileName read FRootPath write SetRootPath;
	end;

	{ **************************************** TkbRestartWindowsDialog class interface ***************************************** }
	TkbRestartWindowsDialog = class(TComponent)
	public { Constructors/Destructors }
		constructor Create(TheOwner: TComponent); override;
	private
		FReason       : string;
		FRestartOption: TkbRestartOption;
	public { Public methods }
		function Execute: boolean;
	published
		property Reason       : string read FReason write FReason;
		property RestartOption: TkbRestartOption read FRestartOption write FRestartOption default kbsdRestartWindows;
	end;

	{ ************************************ TkbObjectPropertiesDialog class interface *************************************** }
	TkbObjectPropertiesDialog = class(TComponent)
	public { Constructors/Destructors }
		constructor Create(TheOwner: TComponent); override;
	private
		FInitialTab: string;
		FObjectName: TFileName;
		FObjectType: TkbShellObjectType;
	public { Public methods }
		function Execute: boolean;
	published
		property InitialTab: string read FInitialTab write FInitialTab;
		property ObjectName: TFileName read FObjectName write FObjectName;
		property ObjectType: TkbShellObjectType read FObjectType write FObjectType default kbsdPathObject;
	end;

	{ ***************************************** Public unit method interfaces *************************************************** }
	{ Default dialog functions }
function ShowShellAboutDialog: boolean;
function ShowFindFilesDialog: longbool;
function ShowFindComputerDialog: longbool;
procedure ShowExitWindowsDialog;
function ShowRestartDialog(Reason: string): boolean;
function ShowObjectPropertiesDialog(ObjectName: TFileName; ObjectType: TkbShellObjectType; InitialTab: string): boolean;
function ShowNetConnectionDialog(Resource: string; ResourceType: TkbNetResourceType): DWORD;
function ShowOutOfMemoryDialog: Integer;
procedure ShowHandleDiskFullDialog(Drive: TkbDriveLetter);
function ShowShellMessageBox(Caption: PWideChar; Text: PWideChar; Style: UINT; Parameters: array of Pointer): Integer;

{ Conversion functions }
function FormatResultEnumToConst(FormatResult: TkbFormatResult): UINT;
function FormatResultConstToEnum(FormatResult: UINT): TkbFormatResult;
function RestartOptionEnumToConst(RestartOption: TkbRestartOption): UINT;
function RestartOptionConstToEnum(RestartOption: UINT): TkbRestartOption;
function ShellObjectTypeEnumToConst(ShellObjectType: TkbShellObjectType): UINT;
function ShellObjectTypeConstToEnum(ShellObjectType: UINT): TkbShellObjectType;
function RunFileOptionEnumToConst(RunFileOption: TkbRunFileOption): UINT;
function RunFileOptionConstToEnum(RunFileOption: UINT): TkbRunFileOption;
function RunFileActionEnumToConst(RunFileAction: TkbRunFileAction): UINT;
function RunFileActionConstToEnum(RunFileAction: UINT): TkbRunFileAction;
function NetResourceTypeEnumToConst(NetResourceType: TkbNetResourceType): DWORD;
function NetResourceTypeConstToEnum(NetResourceType: DWORD): TkbNetResourceType;

implementation

uses Controls, ShellAPI, ActiveX, System.Win.ComObj;

const

	RunFileDlg_Index                 = 61;
	SHFindFiles_Index                = 90;
	SHFindComputer_Index             = 91;
	ExitWindowsDialog_Index          = 60;
	RestartDialog_Index              = 59;
	GetFileNameFromBrowse_Index      = 63;
	SHObjectProperties_Index         = 178;
	SHNetConnectionDialog_Index      = 160;
	SHStartNetConnectionDialog_Index = 215;
	SHOutOfMemoryMessageBox_Index    = 126;
	SHHandleDiskFull_Index           = 185;
	ShellMessageBoxA_Index           = 183;
	ShellMessageBoxW_Index           = 182;

var
	ShellDLL: HMODULE;

	{ ***************************	  Undocumented Windows Shell Dialog API implementations   ********************************* }
	//procedure RunFileDlg; external Shell32 index RunFileDlg_Index;  //suspeito e removido para carga dinamica abaixo
	//function SHFindFiles; external Shell32 index SHFindFiles_Index;  //suspeito
	//function SHFindComputer; external Shell32 index SHFindComputer_Index; //suspeito
	//procedure ExitWindowsDialog; external Shell32 index ExitWindowsDialog_Index; //+/-
	//function RestartDialog; external Shell32 index RestartDialog_Index; //suspeito
	//function GetFileNameFromBrowse; external Shell32 index GetFileNameFromBrowse_Index; //suspeito
	//function SHObjectProperties; external Shell32 index SHObjectProperties_Index; //suspeito
	//function SHNetConnectionDialog; external Shell32 index SHNetConnectionDialog_Index; //suspeito

	//rotinas suspeitas sem reposicao provisoria
	//function SHOutOfMemoryMessageBox; external Shell32 index SHOutOfMemoryMessageBox_Index;
	//procedure SHHandleDiskFull; external Shell32 index SHHandleDiskFull_Index;

function SHStartNetConnectionDialog(Owner: HWND; ResourceName: PWideChar; ResourceType: DWORD): DWORD; stdcall;
{ This function is only supported on NT, and so must be dynamically loaded. }
type
	TheFunctionType = function(Owner: HWND; ResourceName: PWideChar; ResourceType: DWORD): DWORD; stdcall;
var
	TheFunction: TheFunctionType;
begin
	if (SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT) then begin
		TheFunction := GetProcAddress(ShellDLL, PChar(SHStartNetConnectionDialog_Index));
		if (Assigned(TheFunction)) then begin
			Result := TheFunction(Owner, ResourceName, ResourceType);
		end else begin
			Result := GetLastError;
		end;
	end else begin
		SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
		Result := ERROR_CALL_NOT_IMPLEMENTED;
	end;
end;

function CallShellMessageBox(MethodPtr: Pointer; Instance: THandle; Owner: HWND; Text: Pointer; Caption: Pointer; Style: UINT;
	Parameters: array of Pointer): Integer;
{ This is an auxiliary method for the ShellMessageBox functions to enable the cdecl style extra parameters within the syntax limits of Delphi. Assembler is needed to do this. }
type
	PPointer = ^Pointer;
var
	ParamCount : Integer;
	ParamBuffer: TPointerList;
	BufferIndex: Integer;
begin
	{$WARN UNSAFE_CODE OFF}
	{ Determine how many bytes of extra arguments there are. }
	ParamCount := (high(Parameters) + 1);
	SetLength(ParamBuffer, ParamCount);
	{ Stuff the extra arguments into a buffer in cdecl (right-to-left) order. }
	for BufferIndex              := 0 to high(Parameters) do begin
		ParamBuffer[BufferIndex] := Parameters[high(Parameters) - BufferIndex];
	end;

	{ Use assembler to push arguments onto the stack, call the DLL function, and store the function's result. }
	//p:=ParamBuffer;
	asm
		mov     ECX, ParamCount  //Initialize loop counter with ParamCount in DWORDs
		cmp     ECX, 0           //Check to see if loop counter in ECX is equal to 0
		je      @MethodCall      //If ECX counter is indeed 0, jump to the method call label
		mov EDX, ParamBuffer     //Load ParamBuffer pointer into EBX register

	@StartLoop:          //Label where the push loop starts

		push    DWORD PTR[EDX]  //Push the DWORD value indexed by EDX onto the stack
		add     EDX, 4          //Increment EDX by size of DWORD to point to the next DWORD in the buffer
		loop    @StartLoop      //Decrement ECX, and loop back to the StartLoop label while ECX <> 0

	@MethodCall:         //Label to start the call to the DLL method

		push    Style           //Push the Style argument onto the stack
		push    Caption         //Push the Caption argument onto the stack
		push    Text            //Push the Text argument onto the stack
		push    Owner           //Push the Owner argument onto the stack
		push    Instance        //Push the Instance argument onto the stack

		call    MethodPtr       //Call the DLL procedure
		mov     Result, EAX     //Save the result from the method call into the Result variable
	end;                        { asm }
	{$WARN UNSAFE_CODE ON}
end;

function ShellMessageBox(Instance: THandle; Owner: HWND; Text: PWideChar; Caption: PWideChar; Style: UINT;
	Parameters: array of Pointer): Integer; cdecl;
begin
	{ Call ShellMessageBox. }
	Result := ShellMessageBoxW(Instance, Owner, Text, Caption, Style, Parameters);
end;

function ShellMessageBoxA(Instance: THandle; Owner: HWND; Text: PChar; Caption: PChar; Style: UINT; Parameters: array of Pointer)
	: Integer; cdecl;
{ This function takes a cdecl-style variable parameter list, which is implemented using an open-array parameter and which requires assembler to fully implement. See the CallShellMessageBox function for this implementation. }
var
	MethodPtr: Pointer;
begin
	{ Try to load the function address from SHELL32.DLL }
	MethodPtr := GetProcAddress(ShellDLL, PChar(ShellMessageBoxA_Index));
	{ If function load was good, call the function.  If not, return cancel result. }
	if (MethodPtr <> nil) then begin
		Result := CallShellMessageBox(MethodPtr, Instance, Owner, Text, Caption, Style, Parameters);
	end else begin
		Result := ID_CANCEL;
	end;
end;

function ShellMessageBoxW(Instance: THandle; Owner: HWND; Text: PWideChar; Caption: PWideChar; Style: UINT;
	Parameters: array of Pointer): Integer; cdecl;
{ This function takes a cdecl-style variable parameter list, which is implemented using an open-array parameter and which requires assembler to fully implement. See the CallShellMessageBox function for this implementation. In addition, this function is only supported on NT, and so must be dynamically loaded. }
var
	MethodPtr: Pointer;
begin
	{ If this OS is NT... }
	if (SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT) then begin

		{ Try to load the function address from SHELL32.DLL }
		MethodPtr := GetProcAddress(ShellDLL, PChar(ShellMessageBoxW_Index));

		{ If function load was good, call the function.  If not, return cancel result. }
		if (MethodPtr <> nil) then begin
			Result := CallShellMessageBox(MethodPtr, Instance, Owner, Text, Caption, Style, Parameters);
			Exit;
		end else begin
			Result := ID_CANCEL;
		end;
	end else begin { If not NT, return a NOT IMPLEMENTED error. }
		SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
		Result := ID_CANCEL;
	end;
end;

{ ************************************ TkbShellAboutDialog class implementation ************************************************* }
constructor TkbShellAboutDialog.Create(TheOwner: TComponent);
begin
	{ Call ancestor constructor. }
	inherited Create(TheOwner);
	{ Initialize simple-type data members. }
	Self.FCaption   := EmptyStr;
	Self.FOtherText := EmptyStr;
	Self.FProduct   := EmptyStr;
	{ Allocate object-type data members. }
	Self.FIcon := TIcon.Create;
end;

destructor TkbShellAboutDialog.Destroy;
begin
	Self.FIcon.Free;
	inherited Destroy;
end;

procedure TkbShellAboutDialog.SetIcon(NewValue: TIcon);
begin
	{ Assign the new icon to the internal icon object. }
	Self.FIcon.Assign(NewValue);
end;

function TkbShellAboutDialog.StoreIcon: boolean;
begin
	{ Store the TIcon's data in the *.frm file only if icon data has actually been loaded into it. }
	Result := (not Self.FIcon.Empty);
end;

function TkbShellAboutDialog.Execute: boolean;
const
	AboutText        = 'About ';
	WindowsText      = 'Windows';
	WinNTText        = WindowsText + ' NT';
	CaptionSeparator = '#';
var
	CaptionText: string;
begin
	{ Assemble the CaptionText string based on the property values and whether the defaults are set. }
	{ If Caption is empty, use the default caption constants. Otherwise, use the Caption property text. }
	if (Self.Caption = EmptyStr) then begin
		CaptionText := AboutText + WindowsText;
	end else begin
		CaptionText := Self.Caption;
	end;

	{ Insert the separator between the caption and the first line strings. }
	CaptionText := CaptionText + CaptionSeparator;

	{ If Product is empty, use the default product constants based on what OS is running. Otherwise, use the Product property text. }
	if (Self.Product = EmptyStr) then begin
		if (SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT) then begin
			CaptionText := CaptionText + WinNTText;
		end else begin
			CaptionText := CaptionText + WindowsText;
		end;
	end else begin
		CaptionText := CaptionText + Self.Product;
	end;

	{ Show the dialog. Raise an exception if the function failed. Always return True for this dialog. }
	Win32Check(longbool(ShellAbout(Application.MainForm.Handle, PChar(CaptionText), PChar(Self.OtherText), Self.Icon.Handle)));
	Result := True;
end;

{ ******************************** TkbBrowseForFolderDialog class implementation ******************************************** }
function BrowseForFolderCallback(DialogHandle: HWND; MessageID: UINT; PIDL: LPARAM; ComponentPointer: LPARAM): Integer;
	stdcall; forward;

constructor TkbBrowseForFolderDialog.Create(TheOwner: TComponent);
begin
	{ Call ancestor constructor. }
	inherited Create(TheOwner);

	{ Initialize simple-type data members. }
	Self.FCaption          := EmptyStr;
	Self.FCanExpandDomains := False;
	Self.FDialogHandle     := 0;
	Self.FDisplayName      := EmptyStr;
	Self.FFilter           := kbsdBrowseForAnything;
	Self.FImageIndex       := 0;
	Self.FRootPath         := EmptyStr;
	Self.FRootFolder       := rfDesktop;
	Self.FShowStatusText   := False;
	Self.FStatusText       := EmptyStr;

	Self.FImageLarge := TBitmap.Create;
	Self.FImageSmall := TBitmap.Create;
end;

function TkbBrowseForFolderDialog.GetImage(Index: Integer): TBitmap;
var
	SystemImages: TImageList;
	Flags       : DWORD;
	Unused      : TSHFileInfo;
begin
	{ Create an object to refer to one of the system image lists. }
	SystemImages := TImageList.Create(Self);
	try

		{ Set the bitmap to return and the flags for retrieving image info based on the property index. }
		case (index) of
			1: begin
					Result := Self.FImageLarge;
					Flags  := SHGFI_SYSICONINDEX or SHGFI_LARGEICON;
				end; { case 1 }
			2: begin
					Result := Self.FImageSmall;
					Flags  := SHGFI_SYSICONINDEX or SHGFI_SMALLICON;
				end; { case 2 }
		else begin
				Result := nil;
				Exit;
			end;
		end;

		{ Point image list object at the appropriate system image list, make sure it will not free that list when it is freed, and load the indexed bitmap into the returned object. }
		SystemImages.Handle      := SHGetFileInfo(PChar(EmptyStr), 0, Unused, SizeOf(Unused), Flags);
		SystemImages.ShareImages := True;
		SystemImages.GetBitmap(Self.ImageIndex, Result);

		{ Ensure the allocated system list object is freed. Actual system image list will not be freed, because ShareImages is set True. }
	finally
		SystemImages.Free;
	end;
end;

procedure TkbBrowseForFolderDialog.SetCaption(NewValue: string);
begin
	{ If the Dialog window handle is valid, send it a message to change its caption. }
	if (Self.FDialogHandle <> 0) then begin
		SetWindowText(Self.FDialogHandle, PChar(NewValue));
	end;
	{ Update the data member. }
	Self.FCaption := NewValue;
end;

procedure TkbBrowseForFolderDialog.SetRootPath(NewValue: TFileName);
begin
	{ If we're setting a new Root Path, ensure the Root Folder is set to Path. }
	if (NewValue <> EmptyStr) then begin
		Self.RootFolder := kbsdPath;
	end;
	Self.FRootPath := NewValue;
end;

procedure TkbBrowseForFolderDialog.SetStatusText(NewValue: string);
begin
	{ If the Dialog window handle is valid, send it a message to change its status text. Has no effect if ShowStatusText is not True. }
	if (Self.FDialogHandle <> 0) then begin
		PostMessage(Self.FDialogHandle, BFFM_SETSTATUSTEXT, 0, DWORD(PChar(NewValue)));
	end;
	{ Update the data member. }
	Self.FStatusText := NewValue;
end;

procedure TkbBrowseForFolderDialog.Change(DialogHandle: HWND; PIDL: Pointer);
var
	FileInfo     : TSHFileInfo;
	NewPath      : string;
	OldPath      : string;
	NewStatusText: string;
	NewOKState   : TkbOKState;
begin
	{ If a handler is assigned for the OnChange event... }
	if (Assigned(Self.OnChange)) then begin
		{ Fetch the System Image Index, Display Name, and the Folder Description from the PIDL, and load them into the corresponding internal data members. }
		SHGetFileInfo(PIDL, 0, FileInfo, SizeOf(FileInfo), SHGFI_PIDL or SHGFI_DISPLAYNAME or SHGFI_TYPENAME or SHGFI_ICON);
		Self.FDescription := StrPas(FileInfo.szTypeName);
		Self.FDisplayName := StrPas(FileInfo.szDisplayName);
		Self.FImageIndex  := FileInfo.iIcon;

		{ Initialize the event's var parameters to their default values. }
		OldPath       := GetPathFromPIDL(PIDL);
		NewPath       := OldPath;
		NewStatusText := Self.StatusText;
		NewOKState    := kbsdDefaultState;

		{ Call the event handler. }
		Self.OnChange(Self, NewPath, NewStatusText, NewOKState);

		{ Update the dialog's path based on the value that emerged from the handler. }
		if ((NewPath <> EmptyStr) and (NewPath <> OldPath)) then begin
			PostMessage(DialogHandle, BFFM_SETSELECTION, LPARAM(True), LPARAM(PChar(NewPath)));
		end;

		{ Update the status text based on the value that emerged from the handler. }
		Self.StatusText := NewStatusText;

		{ If the event handler overrode the OK status, send the dialog a message to enact the override. }
		case (NewOKState) of
			kbsdEnableOK: begin
					PostMessage(Self.FDialogHandle, BFFM_ENABLEOK, 0, LPARAM(True));
				end;
			kbsdDisableOK: begin
					PostMessage(Self.FDialogHandle, BFFM_ENABLEOK, 0, LPARAM(False));
				end;
		end;
	end;
end;

procedure TkbBrowseForFolderDialog.Initialize(DialogHandle: HWND);
begin
	{ Set the internal dialog handle data member for later use. }
	Self.FDialogHandle := DialogHandle;

	{ If the caption is an empty string, just leave the default dialog caption alone. Otherwise, override the dialog's caption with the user-specified one. }
	if (Self.Caption <> EmptyStr) then begin
		Self.SetCaption(Self.Caption);
	end;

	{ Set the status text in the dialog. }
	Self.SetStatusText(Self.StatusText);

	{ If the OnInitialize event handler is assigned, call it. }
	if (Assigned(Self.OnInitialize)) then begin
		Self.OnInitialize(Self, DialogHandle);
	end;
end;

function TkbBrowseForFolderDialog.Execute: boolean;
var
	browseinfo : TBrowseInfo;
	itemidlist : PItemIDList;
	image      : Integer;
	DisplayName: PChar;
	itaskalloc : IMalloc;
	s          : PChar;
begin
	Result      := False;
	image       := 0;
	DisplayName := StrAlloc(MAX_PATH);
	try
		browseinfo.hwndOwner      := Application.MainForm.Handle;
		browseinfo.pidlRoot       := nil;
		browseinfo.pszDisplayName := DisplayName;
		browseinfo.lpszTitle      := PChar(Self.FInstructionText);
		browseinfo.ulFlags        := BIF_RETURNONLYFSDIRS;
		browseinfo.lpfn           := nil;
		{$WARN UNSAFE_CAST OFF}
		browseinfo.LPARAM := LPARAM(Self);
		{$WARN UNSAFE_CODE ON}
		browseinfo.iImage := image;
		if (Self.RootFolder = kbsdPath) then begin
			browseinfo.pidlRoot := GetPIDLFromPath(Self.RootPath);
		end else if (Self.RootFolder = rfDesktop) then begin
			browseinfo.pidlRoot := nil;
		end else begin
			{ If RootFolder is not specifying a path for the root, try to fetch the PIDL for some special folder. If the folder is not
			  recognized, just leave the root PIDL nil to get a default tree. }
			browseinfo.pidlRoot := GetSpecialLocationPIDL(Self.RootFolder);
		end;
		{ Set the Flags member of BrowseInfo if we are filtering for some particular type of folder. }
		case (Self.Filter) of
			kbsdBrowseForComputers: begin
					browseinfo.ulFlags := browseinfo.ulFlags or BIF_BROWSEFORCOMPUTER;
				end;
			kbsdBrowseForDirectories: begin
					browseinfo.ulFlags := browseinfo.ulFlags or BIF_RETURNONLYFSDIRS;
				end;
			kbsdBrowseForFileAncestors: begin
					browseinfo.ulFlags := browseinfo.ulFlags or BIF_RETURNFSANCESTORS;
				end;
			kbsdBrowseForPrinters: begin
					browseinfo.ulFlags := browseinfo.ulFlags or BIF_BROWSEFORPRINTER;
				end;
		end;

		{ Set the Flags member of BrowseInfo if we want to restrict access to network neighborhood. }
		if (not(Self.CanExpandDomains)) then begin
			browseinfo.ulFlags := browseinfo.ulFlags or BIF_DONTGOBELOWDOMAIN;
		end;

		{ Set the Flags member of BrowseInfo if we want to show status text in the dialog. }
		if (Self.ShowStatusText) then begin
			browseinfo.ulFlags := browseinfo.ulFlags or BIF_STATUSTEXT;
		end;

		itemidlist := SHBrowseForFolder(browseinfo);
		if Assigned(itemidlist) then
			try
				s := StrAlloc(MAX_PATH);
				try
					if SHGetPathFromIDList(itemidlist, s) then begin
						Result         := True;
						Self.FRootPath := s;
					end;
				finally
					StrDispose(s);
				end;
			finally
				OleCheck(SHGetMalloc(itaskalloc));
				try
					assert(itaskalloc.DidAlloc(itemidlist) = 1, 'wrong allocator');
					itaskalloc.Free(itemidlist);
					itaskalloc.Free(browseinfo.pidlRoot); //libera id da pasta raiz
				finally
					itaskalloc := nil;
				end;
			end;
	finally
		StrDispose(DisplayName);
	end;

	(* rotina original
	  ///    { Initialize the BrowseInfo structure with default values. }
	  ///    browseinfo.hwndOwner      := Application.MainForm.Handle;
	  ///    browseinfo.pidlRoot       := nil;
	  ///    browseinfo.pszDisplayName := NameBuffer;
	  ///    browseinfo.lpszTitle      := PChar(Self.InstructionText);
	  ///    browseinfo.ulFlags        := 0;
	  ///    browseinfo.lpfn           := BrowseForFolderCallback;
	  ///    {$WARN UNSAFE_CAST OFF}
	  ///    browseinfo.LPARAM := LPARAM(Self);
	  ///    {$WARN UNSAFE_CODE ON}
	  ///    browseinfo.iImage := 0;
	  ///
	  ///    { Ensure the NameBuffer starts with a null-terminator to signal it is empty. }
	  ///    NameBuffer[0] := #0;
	  ///
	  ///    { If the RootFolder property specifies to use the Path property as the root, fetch the PIDL for that path and load it into
	  ///      the pidlRoot member of BrowseInfo. }
	  ///    if (Self.RootFolder = kbsdPath) then begin
	  ///        browseinfo.pidlRoot := GetPIDLFromPath(Self.RootPath);
	  ///    end else if (Self.RootFolder = rfDesktop) then begin
	  ///        browseinfo.pidlRoot := nil;
	  ///    end else begin
	  ///        { If RootFolder is not specifying a path for the root, try to fetch the PIDL for some special folder. If the folder is not
	  ///          recognized, just leave the root PIDL nil to get a default tree. }
	  ///        browseinfo.pidlRoot := GetSpecialLocationPIDL(Self.RootFolder);
	  ///    end;
	  ///    { Set the Flags member of BrowseInfo if we are filtering for some particular type of folder. }
	  ///    case (Self.Filter) of
	  ///        kbsdBrowseForComputers: begin
	  ///                browseinfo.ulFlags := browseinfo.ulFlags or BIF_BROWSEFORCOMPUTER;
	  ///            end;
	  ///        kbsdBrowseForDirectories: begin
	  ///                browseinfo.ulFlags := browseinfo.ulFlags or BIF_RETURNONLYFSDIRS;
	  ///            end;
	  ///        kbsdBrowseForFileAncestors: begin
	  ///                browseinfo.ulFlags := browseinfo.ulFlags or BIF_RETURNFSANCESTORS;
	  ///            end;
	  ///        kbsdBrowseForPrinters: begin
	  ///                browseinfo.ulFlags := browseinfo.ulFlags or BIF_BROWSEFORPRINTER;
	  ///            end;
	  ///    end;
	  ///
	  ///    { Set the Flags member of BrowseInfo if we want to restrict access to network neighborhood. }
	  ///    if (not(Self.CanExpandDomains)) then begin
	  ///        browseinfo.ulFlags := browseinfo.ulFlags or BIF_DONTGOBELOWDOMAIN;
	  ///    end;
	  ///
	  ///    { Set the Flags member of BrowseInfo if we want to show status text in the dialog. }
	  ///    if (Self.ShowStatusText) then begin
	  ///        browseinfo.ulFlags := browseinfo.ulFlags or BIF_STATUSTEXT;
	  ///    end;
	  ///
	  ///    { Show the dialog and save the PIDL reflecting the user's final selection, if any. }
	  ///    FinalPIDL := SHBrowseForFolder(browseinfo);
	  ///
	  ///    { If the final PIDL is not nil, return True. If it is nil, return False. }
	  ///    Result := (FinalPIDL <> nil);
	  ///
	  ///    { Reset the dialog window handle value to 0, since the dialog is no longer available. }
	  ///    Self.FDialogHandle := 0;
	  ///
	  ///    { Extract the file path, if any, from the final PIDL. }
	  ///    Self.FRootPath := GetPathFromPIDL(FinalPIDL);
	  ///
	  ///    { Free PIDLs allocated by the system. }
	  ///    FreePIDL(FinalPIDL);
	  ///    FreePIDL(browseinfo.pidlRoot);
	*)
end;

{ ************************** Browse For Folder Callback function implementation ***************************************** }

function BrowseForFolderCallback(DialogHandle: HWND; MessageID: UINT; PIDL: LPARAM; ComponentPointer: LPARAM): Integer; stdcall;
var
	DialogComponent: TkbBrowseForFolderDialog;
begin
	{ If the value which we expect to point to the dialog component is not nil... }
	if (ComponentPointer <> 0) then begin
		DialogComponent := TkbBrowseForFolderDialog(ComponentPointer);
		{ Based on which message is invoking the callback, invoke the appropriate event dispatch method for the referenced component.
		  We are cheating a bit --- these are actually protected methods, but we can access them from outside the class
		  because this is in the same unit. }
		case (MessageID) of
			BFFM_INITIALIZED: begin
					DialogComponent.Initialize(DialogHandle);
				end;
			BFFM_SELCHANGED: begin
					TkbBrowseForFolderDialog(DialogComponent).Change(DialogHandle, PItemIDList(PIDL));
				end;
		end;
	end;
	{ Always return 0. }
	Result := 0;
end;

{ ************************************** TkbFormatDriveDialog class implementation ****************************************** }
constructor TkbFormatDriveDialog.Create(TheOwner: TComponent);
begin
	{ Call the ancestor constructor. }
	inherited Create(TheOwner);

	{ Initialize simple-type properties. }
	Self.FDefaultQuickFormat := False;
	Self.FDefaultSysOnly     := False;
	Self.FDriveToFormat      := kbsdDriveA;
	Self.FRememberLastFormat := True;
	Self.FLastFormatID       := SHFMT_ID_DEFAULT;
	Self.FSuppressARI        := True;

end;

function TkbFormatDriveDialog.Execute: TkbFormatResult;
var
	OldErrorMode     : UINT;
	LocalLastFormatID: UINT;
	LocalOptionFlags : UINT;
	FormatResult     : DWORD;
begin
	{ Set whether to remember the last format ID. }
	if (Self.RememberLastFormat) then begin
		LocalLastFormatID := LOWORD(Self.LastFormatID);
	end else begin
		LocalLastFormatID := SHFMT_ID_DEFAULT;
	end;

	{ Set checkbox option flags. Note that NT has SHFMT_OPT_FULL backwards and screws up SHFMT_OPT_SYSONLY. }
	LocalOptionFlags := 0;
	if (Self.DefaultQuickFormat) then begin
		if (SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT) then begin
			LocalOptionFlags := LocalOptionFlags or SHFMT_OPT_FULL;
		end;
	end else begin
		if (SysUtils.Win32Platform <> VER_PLATFORM_WIN32_NT) then begin
			LocalOptionFlags := LocalOptionFlags or SHFMT_OPT_FULL;
		end;
	end;
	if ((Self.DefaultSysOnly) and (SysUtils.Win32Platform <> VER_PLATFORM_WIN32_NT)) then begin
		LocalOptionFlags := LocalOptionFlags or SHFMT_OPT_SYSONLY;
	end;

	{ Save the current process error mode. }
	OldErrorMode := SetErrorMode(0);
	try

		{ If supress AbortRetryIgnore is on, set the error mode accordingly. }
		if (Self.SuppressARI) then begin
			SetErrorMode(OldErrorMode or SEM_FAILCRITICALERRORS);
		end else begin
			SetErrorMode(OldErrorMode and not SEM_FAILCRITICALERRORS);
		end;

		{ Invoke dialog and save result. }
		FormatResult := SHFormatDrive(Application.Handle, UINT(Self.DriveToFormat), LocalLastFormatID, LocalOptionFlags);

		{ Ensure old error mode is restored. }
	finally
		SetErrorMode(OldErrorMode);
	end;

	{ Translate format result into function result. }
	Result := FormatResultConstToEnum(FormatResult);

	{ If the format was successful, remember the format ID. }
	if (Result = kbsdFormatSucceeded) then begin
		Self.FLastFormatID := FormatResult;
	end;
end;

{ ********************************* TkbPickIconDialog class implementation ********************************************** }
constructor TkbPickIconDialog.Create(TheOwner: TComponent);
begin
	{ Call the ancestor constructor. }
	inherited Create(TheOwner);

	{ Initialize simple-type properties. }
	Self.FFileName  := EmptyStr;
	Self.FIconIndex := 0;
end;

function TkbPickIconDialog.Execute: Integer;
var
	FileNameBuffer: Pointer;
begin
	{ Allocate a suitably sized PWideChar buffer and transliterate the initial filename into the buffer. }
	FileNameBuffer := GetMemory(MAX_PATH * SizeOf(widechar));
	try
		StringToWideChar(Self.FileName, FileNameBuffer, MAX_PATH + 1);
		{ Call the dialog and use the return value as the function result. }
		Result := PickIconDlg(Application.Handle, PWideChar(FileNameBuffer), UINT(MAX_PATH), Self.FIconIndex);
		{ If function was successful, transliterate the returned filename back to a string. }
		if (Result <> 0) then begin
			Self.FileName := WideCharToString(FileNameBuffer);
		end;
	finally
		FreeMemory(FileNameBuffer);
	end;
end;

{ ************************************ TkbRunFileDialog class implementation ************************************************** }
constructor TkbRunFileDialog.Create(TheOwner: TComponent);
begin
	{ Call the ancestor constructor. }
	inherited Create(TheOwner);
	{ Initialize simple-type data members. }
	Self.FCaption     := EmptyStr;
	Self.FDescription := EmptyStr;
	Self.FWorkingPath := EmptyStr;
	{ Initialize event-type data members. }
	Self.FOnValidate := nil;
	{ Initialize set-type data members. }
	Self.FOptions := [];
	{ Allocate object-type data members. }
	Self.FIcon := TIcon.Create;
	{ Allocate a message-handling window. }
	Self.FMessageWindow := Classes.AllocateHWnd(Self.HandleMessage);
end;

destructor TkbRunFileDialog.Destroy;
begin
	{ Destroy the message-handling window }
	Classes.DeallocateHWnd(Self.FMessageWindow);
	{ Free object-type data members. }
	Self.FIcon.Free;
	{ Call the ancestor destructor. }
	inherited Destroy;
end;

procedure TkbRunFileDialog.SetIcon(NewValue: TIcon);
begin
	{ Copy the new TIcon's data to the object's instance. }
	Self.Icon.Assign(NewValue);
end;

function TkbRunFileDialog.StoreIcon: boolean;
begin
	{ Only store the object's TIcon in the DFM if an icon is assigned. }
	Result := (Self.Icon.Handle <> 0);
end;

procedure TkbRunFileDialog.HandleMessage(var TheMessage: TMessage);
var
	FileToRun: string;
	WorkPath : string;
	RunAction: TkbRunFileAction;
begin
	{ If we have a notify message with code run validate... }
	if TheMessage.Msg = WM_NOTIFY then begin
		if PNMHdr(TheMessage.LPARAM).code = RFN_VALIDATE then begin
			FileToRun := EmptyStr;
			if (PNM_RunFileDlg(TheMessage.LPARAM).lpFile <> nil) then begin
				WideCharToStrVar(PWideChar(PNM_RunFileDlg(TheMessage.LPARAM).lpFile), FileToRun);
			end;
			WorkPath := EmptyStr;
			if (PNM_RunFileDlg(TheMessage.LPARAM).lpDirectory <> nil) then begin
				WideCharToStrVar(PWideChar(PNM_RunFileDlg(TheMessage.LPARAM).lpDirectory), WorkPath);
			end;
			{ Set up and invoke event handler. Return the result from event handler to the message and exit this method. }
			RunAction := kbsdRun;
			Self.Validate(FileToRun, WorkPath, PNM_RunFileDlg(TheMessage.LPARAM).nShow, RunAction);
			TheMessage.Result := RunFileActionEnumToConst(RunAction);
			Exit;
		end;
	end;
	{ If message was not handled above, send it to the default window procedure. }
	TheMessage.Result := DefWindowProc(Self.FMessageWindow, TheMessage.Msg, TheMessage.wParam, TheMessage.LPARAM);
end;

procedure TkbRunFileDialog.Validate(TheFile: TFileName; TheWorkPath: TFileName; Visible: boolean; var Action: TkbRunFileAction);
begin
	{ If event handler is assigned, call it. }
	if Assigned(Self.OnValidate) then begin
		Self.OnValidate(Self, TheFile, TheWorkPath, Visible, Action);
	end;
end;

procedure TkbRunFileDialog.Execute;
var
	CaptionBuffer    : Pointer;
	DescriptionBuffer: Pointer;
	WorkPathBuffer   : Pointer;
	Option           : TkbRunFileOption;
	OptionFlags      : UINT;
begin
	{ Initialize buffers to nil }
	CaptionBuffer     := nil;
	DescriptionBuffer := nil;
	WorkPathBuffer    := nil;

	{ Allocate a buffer to hold the caption, long enough for UNICODE if need be. }
	if (Self.Caption <> EmptyStr) then begin
		CaptionBuffer := GetMemory((Length(Self.Caption) + 1) * SizeOf(widechar));
	end;
	try

		{ Allocate a buffer to hold the description, long enough for UNICODE if need be. }
		if (Self.Description <> EmptyStr) then begin
			DescriptionBuffer := GetMemory((Length(Self.Description) + 1) * SizeOf(widechar));
		end;
		try

			{ Allocate a buffer to hold the work path, long enough for UNICODE if need be. }
			if (Self.WorkingPath <> EmptyStr) then begin
				WorkPathBuffer := GetMemory((Length(Self.WorkingPath) + 1) * SizeOf(widechar));
			end;
			try
				if (CaptionBuffer <> nil) then begin
					StringToWideChar(Self.Caption, PWideChar(CaptionBuffer), (Length(Self.Caption) + 1));
				end;
				if (DescriptionBuffer <> nil) then begin
					StringToWideChar(Self.Description, PWideChar(DescriptionBuffer), (Length(Self.Description) + 1));
				end;
				if (WorkPathBuffer <> nil) then begin
					StringToWideChar(Self.WorkingPath, PWideChar(WorkPathBuffer), (Length(Self.WorkingPath) + 1));
				end;
				{ Set up option flags. }
				OptionFlags := 0;
				for Option  := low(TkbRunFileOption) to high(TkbRunFileOption) do begin
					if (Option in Self.Options) then begin
						OptionFlags := OptionFlags or RunFileOptionEnumToConst(Option);
					end;
				end;
				RunFileDlg(Self.FMessageWindow, Self.Icon.Handle, WorkPathBuffer, CaptionBuffer, DescriptionBuffer, OptionFlags);
			finally
				FreeMemory(WorkPathBuffer);
			end;
		finally
			FreeMemory(DescriptionBuffer);
		end;
	finally
		FreeMemory(CaptionBuffer);
	end;
end;

{ ******************************** TkbFindFilesDialog class implementation *************************************************** }
constructor TkbFindFilesDialog.Create(TheOwner: TComponent);
begin
	{ Call the ancestor constructor. }
	inherited Create(TheOwner);
	{ Initialize simple-type properties. }
	Self.FSearchFileName := EmptyStr;
	Self.FRootPath       := EmptyStr;
	Self.FRootFolder     := rfDesktop;
end;

procedure TkbFindFilesDialog.SetRootPath(NewValue: TFileName);
begin
	{ If we're setting a new Root Path, ensure the Root Folder is set to Path. }
	if (NewValue <> EmptyStr) then begin
		Self.RootFolder := kbsdPath;
	end;
	Self.FRootPath := NewValue;
end;

function TkbFindFilesDialog.Execute: boolean;
var
	RootPIDL  : PItemIDList;
	SearchFile: PItemIDList;
begin
	{ Initialize Root PIDL to nil by default. }
	RootPIDL := nil;
	try
		SearchFile := GetPIDLFromPath(Self.SearchFileName);
		if (Self.RootFolder = kbsdPath) then begin
			RootPIDL := GetPIDLFromPath(Self.RootPath);
		end else begin
			RootPIDL := GetSpecialLocationPIDL(Self.RootFolder);
		end;
		{ Show the dialog and return the result. }
		Result := SHFindFiles(RootPIDL, SearchFile);
		{ Free the Root PIDL. }
	finally
		ILFree(RootPIDL);
	end;
end;

{ ***************************** TkbRestartWindowsDialog class implementation ************************************************* }
constructor TkbRestartWindowsDialog.Create(TheOwner: TComponent);
begin
	{ Call the ancestor constructor. }
	inherited Create(TheOwner);
	{ Initialize simple-type properties. }
	Self.FReason        := EmptyStr;
	Self.FRestartOption := kbsdRestartWindows;
end;

function TkbRestartWindowsDialog.Execute: boolean;
const
	Space: string = ' ';
var
	ReasonString: string;
	ReasonBuffer: Pointer;
begin
	{ Allocate a buffer to hold the reason, long enough for UNICODE if need be. }
	ReasonString := Self.Reason + Space;
	ReasonBuffer := GetMemory((Length(ReasonString) + 1) * SizeOf(widechar));
	try
		StringToWideChar(ReasonString, PWideChar(ReasonBuffer), (Length(ReasonString) + 1));
		{ Execute the dialog and convert the result to the return value. }
		Result := (RestartDialog(Application.Handle, PWideChar(ReasonBuffer), RestartOptionEnumToConst(Self.RestartOption))
			= idYes);
	finally
		FreeMemory(ReasonBuffer);
	end;
end;

{ ******************************** TkbObjectPropertiesDialog class implementation ********************************************* }
constructor TkbObjectPropertiesDialog.Create(TheOwner: TComponent);
begin
	{ Call the ancestor constructor. }
	inherited Create(TheOwner);
	{ Initialize simple-type properties. }
	Self.FInitialTab := EmptyStr;
	Self.FObjectName := EmptyStr;
	Self.FObjectType := kbsdPathObject;
end;

function TkbObjectPropertiesDialog.Execute: boolean;
var
	ObjectNameBuffer: Pointer;
	TabNameBuffer   : Pointer;
begin
	ObjectNameBuffer := GetMemory((Length(Self.ObjectName) + 1) * SizeOf(widechar));
	try
		StringToWideChar(Self.ObjectName, PWideChar(ObjectNameBuffer), (Length(Self.ObjectName) + 1));
		{ Allocate a buffer to hold the initial tab name, long enough for UNICODE if need be. }
		TabNameBuffer := GetMemory((Length(Self.InitialTab) + 1) * SizeOf(widechar));
		try
			StringToWideChar(Self.InitialTab, PWideChar(TabNameBuffer), (Length(Self.InitialTab) + 1));
			{ Execute the dialog and translate the result to the return value. }
			Result := SHObjectProperties(Application.Handle, ShellObjectTypeEnumToConst(Self.ObjectType), ObjectNameBuffer,
				TabNameBuffer);
		finally
			FreeMemory(TabNameBuffer);
		end;
	finally
		FreeMemory(ObjectNameBuffer);
	end;
end;

{ ******************************** Public unit method implementations ************************************************** }
function ShowShellAboutDialog: boolean;
var
	Dialog: TkbShellAboutDialog;
begin
	Dialog := TkbShellAboutDialog.Create(Application);
	try
		Result := Dialog.Execute;
	finally
		Dialog.Free;
	end;
end;

function ShowFindFilesDialog: longbool;
begin
	Result := SHFindFiles(nil, nil);
end;

function ShowFindComputerDialog: longbool;
begin
	Result := SHFindComputer(nil, nil);
end;

procedure ShowExitWindowsDialog;
begin
	ExitWindowsDialog(Application.Handle);
end;

function ShowRestartDialog(Reason: string): boolean;
var
	Dialog: TkbRestartWindowsDialog;
begin
	Dialog := TkbRestartWindowsDialog.Create(Application);
	try
		Dialog.Reason := Reason;

		Result := Dialog.Execute;
	finally
		Dialog.Free;
	end;
end;

function ShowObjectPropertiesDialog(ObjectName: TFileName; ObjectType: TkbShellObjectType; InitialTab: string): boolean;
var
	Dialog: TkbObjectPropertiesDialog;
begin
	Dialog := TkbObjectPropertiesDialog.Create(Application);
	try
		Dialog.ObjectName := ObjectName;
		Dialog.ObjectType := ObjectType;
		Dialog.InitialTab := InitialTab;
		Result            := Dialog.Execute;
	finally
		Dialog.Free;
	end;
end;

function ShowNetConnectionDialog(Resource: string; ResourceType: TkbNetResourceType): DWORD;
var
	ResourceBuffer: array[0 ..(MAX_PATH * SizeOf(widechar))] of char;
	BufferAddress : Pointer;
begin
	{ We must pass ANSI for Win95 and UNICODE for NT, or nil if the Resource string is empty. }
	{$WARN UNSAFE_CODE OFF}
	if (Resource <> EmptyStr) then begin
		StringToWideChar(Resource, PWideChar(@ResourceBuffer), MAX_PATH);
		BufferAddress := @ResourceBuffer;
	end else begin
		BufferAddress := nil;
	end;
	{ Call API function and return result. }
	Result := SHNetConnectionDialog(Application.Handle, BufferAddress, NetResourceTypeEnumToConst(ResourceType));
	{$WARN UNSAFE_CODE OFF}
end;

function ShowOutOfMemoryDialog: Integer;
begin
	Result := SHOutOfMemoryMessageBox(Application.Handle, nil, MB_OK or MB_ICONHAND);
end;

procedure ShowHandleDiskFullDialog(Drive: TkbDriveLetter);
begin
	SHHandleDiskFull(Application.Handle, UINT(Drive));
end;

function ShowShellMessageBox(Caption: PWideChar; Text: PWideChar; Style: UINT; Parameters: array of Pointer): Integer;
begin
	Result := ShellMessageBox(HInstance, Application.Handle, Text, Caption, Style, Parameters);
end;

function FormatResultEnumToConst(FormatResult: TkbFormatResult): UINT;
begin
	case (FormatResult) of
		kbsdFormatSucceeded: begin
				Result := 0;
			end;
		kbsdFormatCancelled: begin
				Result := SHFMT_CANCEL;
			end;
		kbsdDriveNotFormattable: begin
				Result := SHFMT_NOFORMAT;
			end;
		kbsdFormatError: begin
				Result := SHFMT_ERROR;
			end;
	else begin
			Result := SHFMT_ERROR;
		end;
	end;
end;

function FormatResultConstToEnum(FormatResult: UINT): TkbFormatResult;
begin
	case (FormatResult) of
		SHFMT_CANCEL: begin
				Result := kbsdFormatCancelled;
			end;
		SHFMT_NOFORMAT: begin
				Result := kbsdDriveNotFormattable;
			end;
		SHFMT_ERROR: begin
				Result := kbsdFormatError;
			end;
	else begin
			Result := kbsdFormatSucceeded;
		end;
	end;
end;

function RestartOptionEnumToConst(RestartOption: TkbRestartOption): UINT;
begin
	case (RestartOption) of
		kbsdLogoff: begin
				Result := EWX_LOGOFF;
			end;
		kbsdShutdown: begin
				Result := EWX_SHUTDOWN;
			end;
		kbsdReboot: begin
				Result := EWX_REBOOT;
			end;
		kbsdRestartWindows: begin
				Result := EW_RESTARTWINDOWS;
			end;
		kbsdRebootSystem: begin
				Result := EW_REBOOTSYSTEM;
			end;
		kbsdExitAndExecApp: begin
				Result := EW_EXITANDEXECAPP;
			end;
	else begin
			Result := 0;
		end;
	end;
end;

function RestartOptionConstToEnum(RestartOption: UINT): TkbRestartOption;
begin
	case (RestartOption) of
		EWX_LOGOFF: begin
				Result := kbsdLogoff;
			end;
		EWX_SHUTDOWN: begin
				Result := kbsdShutdown;
			end;
		EWX_REBOOT: begin
				Result := kbsdReboot;
			end;
		EW_RESTARTWINDOWS: begin
				Result := kbsdRestartWindows;
			end;
		EW_REBOOTSYSTEM: begin
				Result := kbsdRebootSystem;
			end;
		EW_EXITANDEXECAPP: begin
				Result := kbsdExitAndExecApp;
			end;
	else begin
			Result := kbsdRestartWindows;
		end;
	end;
end;

function ShellObjectTypeEnumToConst(ShellObjectType: TkbShellObjectType): UINT;
begin
	case (ShellObjectType) of
		kbsdPathObject: begin
				Result := OPF_PATHNAME;
			end;
		kbsdPrinterObject: begin
				Result := OPF_PRINTERNAME;
			end;
	else begin
			Result := 0;
		end;
	end;
end;

function ShellObjectTypeConstToEnum(ShellObjectType: UINT): TkbShellObjectType;
begin
	case (ShellObjectType) of
		OPF_PATHNAME: begin
				Result := kbsdPathObject;
			end;
		OPF_PRINTERNAME: begin
				Result := kbsdPrinterObject;
			end;
	else begin
			Result := kbsdPathObject;
		end;
	end;
end;

function RunFileOptionEnumToConst(RunFileOption: TkbRunFileOption): UINT;
begin
	case (RunFileOption) of
		kbsdNoBrowseButton: begin
				Result := RFF_NOBROWSE;
			end;
		kbsdNoDefaultPick: begin
				Result := RFF_NODEFAULT;
			end;
		kbsdCalculateWorkPath: begin
				Result := RFF_CALCDIRECTORY;
			end;
		kbsdNoEditLabel: begin
				Result := RFF_NOLABEL;
			end;
		kbsdNoSeparateMemory: begin
				Result := RFF_NOSEPARATEMEM;
			end;
	else begin
			Result := 0;
		end;
	end;
end;

function RunFileOptionConstToEnum(RunFileOption: UINT): TkbRunFileOption;
begin
	case (RunFileOption) of
		RFF_NOBROWSE: begin
				Result := kbsdNoBrowseButton;
			end;
		RFF_NODEFAULT: begin
				Result := kbsdNoDefaultPick;
			end;
		RFF_CALCDIRECTORY: begin
				Result := kbsdCalculateWorkPath;
			end;
		RFF_NOLABEL: begin
				Result := kbsdNoEditLabel;
			end;
		RFF_NOSEPARATEMEM: begin
				Result := kbsdNoSeparateMemory;
			end;
	else begin
			Result := kbsdNoSeparateMemory;
		end;
	end;
end;

function RunFileActionEnumToConst(RunFileAction: TkbRunFileAction): UINT;
begin
	case (RunFileAction) of
		kbsdRun: begin
				Result := RF_OK;
			end;
		kbsdCancel: begin
				Result := RF_CANCEL;
			end;
		kbsdRetry: begin
				Result := RF_RETRY;
			end;
	else begin
			Result := RF_OK;
		end;
	end;
end;

function RunFileActionConstToEnum(RunFileAction: UINT): TkbRunFileAction;
begin
	case (RunFileAction) of
		RF_OK: begin
				Result := kbsdRun;
			end;
		RF_CANCEL: begin
				Result := kbsdCancel;
			end;
		RF_RETRY: begin
				Result := kbsdRetry;
			end;
	else begin
			Result := kbsdRun;
		end;
	end;
end;

function NetResourceTypeEnumToConst(NetResourceType: TkbNetResourceType): DWORD;
begin
	case (NetResourceType) of
		kbsdDiskResource: begin
				Result := RESOURCETYPE_DISK;
			end;
		kbsdPrintResource: begin
				Result := RESOURCETYPE_PRINT;
			end;
	else begin
			Result := RESOURCETYPE_DISK;
		end;
	end;
end;

function NetResourceTypeConstToEnum(NetResourceType: DWORD): TkbNetResourceType;
begin
	case (NetResourceType) of
		RESOURCETYPE_DISK: begin
				Result := kbsdDiskResource;
			end;
		RESOURCETYPE_PRINT: begin
				Result := kbsdPrintResource;
			end;
	else begin
			Result := kbsdDiskResource;
		end;
	end;
end;

procedure RunFileDlg(Owner: HWND; IconHandle: HICON; WorkPath: Pointer; Caption: Pointer; Description: Pointer;
	Flags: UINT); stdcall;
type
	TheFunctionType = procedure(Owner: HWND; IconHandle: HICON; WorkPath: Pointer; Caption: Pointer; Description: Pointer;
		Flags: UINT); stdcall;
var
	TheFunction: TheFunctionType;
begin
	TheFunction := GetProcAddress(ShellDLL, PChar('RunFileDlg'));
	if (Assigned(TheFunction)) then begin
		TheFunction(Owner, IconHandle, WorkPath, Caption, Description, Flags);
	end else begin
		TheFunction := GetProcAddress(ShellDLL, PChar(RunFileDlg_Index)); //apelado para carga por indice devido a falha por nome
		if (Assigned(TheFunction)) then begin
			TheFunction(Owner, IconHandle, WorkPath, Caption, Description, Flags);
		end else begin
			SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
		end;
	end;
end;

function SHFindComputer(Reserved1: PItemIDList; Reserved2: PItemIDList): longbool; stdcall;
type
	TheFunctionType = function(Reserved1: PItemIDList; Reserved2: PItemIDList): longbool; stdcall;
var
	TheFunction: TheFunctionType;
begin
	TheFunction := GetProcAddress(ShellDLL, PAnsiChar('SHFindComputer'));
	if (Assigned(TheFunction)) then begin
		Result := TheFunction(Reserved1, Reserved2);
	end else begin
		TheFunction := GetProcAddress(ShellDLL, PChar(SHFindComputer_Index));
		//apelado para carga por indice devido a falha por nome
		if (Assigned(TheFunction)) then begin
			Result := TheFunction(Reserved1, Reserved2);
		end else begin
			SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
			Result := False;
		end;
	end;
end;

function SHNetConnectionDialog(Owner: HWND; ResourceName: Pointer; ResourceType: DWORD): DWORD; stdcall;
type
	TheFunctionType = function(Owner: HWND; ResourceName: Pointer; ResourceType: DWORD): DWORD; stdcall;
var
	TheFunction: TheFunctionType;
begin
	{$WARN NO_RETVAL OFF} //Modified by roger 07/10/2014 14:19:30 - Sem tempo para definir retorno correto
	TheFunction := GetProcAddress(ShellDLL, PChar('SHNetConnectionDialog'));
	if (Assigned(TheFunction)) then begin
		Result := TheFunction(Owner, ResourceName, ResourceType);
	end else begin
		TheFunction := GetProcAddress(ShellDLL, PChar(SHNetConnectionDialog_Index));
		if (Assigned(TheFunction)) then begin
			Result := TheFunction(Owner, ResourceName, ResourceType);
		end else begin
			SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
		end;
	end;
end; {$WARN NO_RETVAL ON}

function SHObjectProperties(Owner: HWND; Flags: UINT; ObjectName: Pointer; InitialTabName: Pointer): longbool; stdcall;
type
	TheFunctionType = function(Owner: HWND; Flags: UINT; ObjectName: Pointer; InitialTabName: Pointer): longbool; stdcall;
var
	TheFunction: TheFunctionType;
begin {$WARN NO_RETVAL OFF} //Modified by roger 07/10/2014 14:19:30 - Sem tempo para definir retorno correto
	TheFunction := GetProcAddress(ShellDLL, PChar('SHObjectProperties'));
	if (Assigned(TheFunction)) then begin
		Result := TheFunction(Owner, Flags, ObjectName, InitialTabName);
	end else begin
		SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
	end;
end; {$WARN NO_RETVAL ON}

function GetFileNameFromBrowse(Owner: HWND; FileName: Pointer; MaxFileNameChars: DWORD; InitialDirectory: Pointer;
	DefaultExtension: Pointer; Filter: Pointer; Caption: Pointer): longbool; stdcall;
type
	TheFunctionType = function(Owner: HWND; FileName: Pointer; MaxFileNameChars: DWORD; InitialDirectory: Pointer;
		DefaultExtension: Pointer; Filter: Pointer; Caption: Pointer): longbool; stdcall;
var
	TheFunction: TheFunctionType;
begin {$WARN NO_RETVAL OFF} //Modified by roger 07/10/2014 14:19:30 - Sem tempo para definir retorno correto
	TheFunction := GetProcAddress(ShellDLL, PChar('GetFileNameFromBrowse'));
	if (Assigned(TheFunction)) then begin
		Result := TheFunction(Owner, FileName, MaxFileNameChars, InitialDirectory, DefaultExtension, Filter, Caption);
	end else begin
		SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
	end;
end; {$WARN NO_RETVAL ON}

function RestartDialog(Owner: HWND; Reason: Pointer; Flags: UINT): DWORD; stdcall;
type
	TheFunctionType = function(Owner: HWND; Reason: Pointer; Flags: UINT): DWORD; stdcall;
var
	TheFunction: TheFunctionType;
begin {$WARN NO_RETVAL OFF} //Modified by roger 07/10/2014 14:19:30 - Sem tempo para definir retorno correto
	TheFunction := GetProcAddress(ShellDLL, PChar('RestartDialog'));
	if (Assigned(TheFunction)) then begin
		Result := TheFunction(Owner, Reason, Flags);
	end else begin
		SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
	end;
end; {$WARN NO_RETVAL ON}

procedure ExitWindowsDialog(Owner: HWND); stdcall;
type
	TheFunctionType = procedure(Owner: HWND); stdcall;
var
	TheFunction: TheFunctionType;
begin
	TheFunction := GetProcAddress(ShellDLL, PChar('ExitWindowsDialog'));
	if (Assigned(TheFunction)) then begin
		TheFunction(Owner);
	end else begin
		TheFunction := GetProcAddress(ShellDLL, PChar(ExitWindowsDialog_Index));
		if (Assigned(TheFunction)) then begin
			TheFunction(Owner);
		end else begin
			SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
		end;
	end;
end;

function SHFindFiles(Root: PItemIDList; SavedSearchFile: PItemIDList): longbool; stdcall;
type
	TheFunctionType = function(Root: PItemIDList; SavedSearchFile: PItemIDList): longbool; stdcall;
var
	TheFunction: TheFunctionType;
begin {$WARN NO_RETVAL OFF} //Modified by roger 07/10/2014 14:19:30 - Sem tempo para definir retorno correto
	TheFunction := GetProcAddress(ShellDLL, PChar('SHFindFiles'));
	if (Assigned(TheFunction)) then begin
		Result := TheFunction(Root, SavedSearchFile);
	end else begin
		SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
	end;
end; {$WARN NO_RETVAL ON}

function SHOutOfMemoryMessageBox(Owner: HWND; Caption: Pointer; Style: UINT): Integer; stdcall;
type
	TheFunctionType = function(Owner: HWND; Caption: Pointer; Style: UINT): Integer; stdcall;
var
	TheFunction: TheFunctionType;
begin {$WARN NO_RETVAL OFF} //Modified by roger 07/10/2014 14:19:30 - Sem tempo para definir retorno correto
	TheFunction := GetProcAddress(ShellDLL, PChar('SHOutOfMemoryMessageBox'));
	if (Assigned(TheFunction)) then begin
		Result := TheFunction(Owner, Caption, Style);
	end else begin
		TheFunction := GetProcAddress(ShellDLL, PChar(SHOutOfMemoryMessageBox_Index));
		if (Assigned(TheFunction)) then begin
			Result := TheFunction(Owner, Caption, Style);
		end else begin
			SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
		end;
	end;
end; {$WARN NO_RETVAL ON}

procedure SHHandleDiskFull(Owner: HWND; uDrive: UINT); stdcall;
type
	TheFunctionType = procedure(Owner: HWND; uDrive: UINT); stdcall;
var
	TheFunction: TheFunctionType;
begin {$WARN NO_RETVAL OFF} //Modified by roger 07/10/2014 14:19:30 - Sem tempo para definir retorno correto
	TheFunction := GetProcAddress(ShellDLL, PChar('SHHandleDiskFull'));
	if (Assigned(TheFunction)) then begin
		TheFunction(Owner, uDrive);
	end else begin
		TheFunction := GetProcAddress(ShellDLL, PChar(SHHandleDiskFull_Index));
		if (Assigned(TheFunction)) then begin
			TheFunction(Owner, uDrive);
		end else begin
			SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
		end;
	end;
end; {$WARN NO_RETVAL ON}

initialization

{ Get a reference to the SHELL32.DLL library }
ShellDLL := LoadLibraryA(PAnsiChar(Shell32));

finalization

{ Free reference to the SHELL32.DLL library }
FreeLibrary(ShellDLL);

end.
