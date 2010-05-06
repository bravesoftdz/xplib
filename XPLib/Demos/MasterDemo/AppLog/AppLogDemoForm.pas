unit AppLogDemoForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppLog, StdCtrls, ExtCtrls;

type
  TAppLogDemoFrm = class(TForm)
    LogMemo: TMemo;
    LogBtn: TButton;
    CommitBtn: TButton;
    LogMessageTypeRadio: TRadioGroup;
    BufferizeCB: TCheckBox;
    procedure BufferizeCBClick(Sender: TObject);
	procedure LogBtnClick(Sender: TObject);
    procedure CommitBtnClick(Sender: TObject);
  private
	{ Private declarations }
	function GetLogType(): TLogMessageType;
  public
	{ Public declarations }
	Class procedure execute();
  end;

var
  AppLogDemoFrm: TAppLogDemoFrm;

implementation

{$R *.dfm}

{ TForm1 }

class procedure TAppLogDemoFrm.execute;
var
	Dlg : TAppLogDemoFrm;
begin
	Application.CreateForm( TAppLogDemoFrm, Dlg );
	try
		Dlg.ShowModal;
	finally
		Dlg.Free;
	end;
end;

procedure TAppLogDemoFrm.BufferizeCBClick(Sender: TObject);
begin
	Self.CommitBtn.Enabled:=Self.BufferizeCB.Checked;
	TLogFile.GetDefaultLogFile.Buffered:=Self.BufferizeCB.Checked;
end;

procedure TAppLogDemoFrm.LogBtnClick(Sender: TObject);
begin
	AppLog.TLogFile.Log( Self.LogMemo.Lines.Text, Self.GetLogType() );
end;

function TAppLogDemoFrm.GetLogType: TLogMessageType;
begin
	case Self.LogMessageTypeRadio.ItemIndex of
		0 : begin
			Result:=lmtError;
		end;
		1 : begin
			Result:=lmtInformation;
		end;
		2 : begin
			Result:=lmtWarning;
		end;
		3 : begin
			Result:=lmtDebug;
		end;
		else begin
          Result:=lmtError;
		end;
	end;
end;

procedure TAppLogDemoFrm.CommitBtnClick(Sender: TObject);
begin
	TLogFile.GetDefaultLogFile.Commit;
end;

end.
