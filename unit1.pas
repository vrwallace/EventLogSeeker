unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  lclintf, ExtCtrls, Clipbrd, strutils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    CheckBoxClipBoard: TCheckBox;
    EditEventID: TEdit;
    EditSource: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    RadioButtonEventID: TRadioButton;
    RadioButtongoogle: TRadioButton;
    RadioGroup1: TRadioGroup;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure CheckBoxClipBoardChange(Sender: TObject);
    procedure RadioButtonEventIDChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure DumpExceptionCallStack(E: Exception);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.CheckBoxClipBoardChange(Sender: TObject);
begin
  if checkboxclipboard.Checked = True then
  begin
    timer1.Enabled := True;
  end
  else
    timer1.Enabled := False;

end;

procedure TForm1.RadioButtonEventIDChange(Sender: TObject);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  clipboardresult: string;
  clipboardleftcut: string;
  clipboardvalue: string;
  crlf: string;
  eventid: string;
  Source: string;

begin
  crlf := #13#10;
  clipboardresult := Clipboard.AsText;

  if pos('Event ID:', clipboardresult) > 0 then
  begin

    clipboardleftcut := midstr(clipboardresult, pos('Event ID:', clipboardresult) +
      length('Event ID:'), 200);
    eventid := trim(midstr(clipboardleftcut, 1, pos(crlf, clipboardleftcut) - 1));
    editeventid.Text := eventid;
    //showmessage(eventid);

    clipboardleftcut := midstr(clipboardresult, pos('Source:', clipboardresult) +
      length('Source:'), 200);
    Source := trim(midstr(clipboardleftcut, 1, pos(crlf, clipboardleftcut) - 1));
    editsource.Text := Source;
    //showmessage(source);


    try
      if radiobuttoneventid.Checked then
      begin
        OpenURL('http://eventid.net/display.asp?eventid=' + editeventid.Text +
          '&source=' + editsource.Text);
      end
      else
        OpenURL('https://www.google.com/#q=' + editeventid.Text + '+' +
          stringreplace(editsource.Text, ' ', '+', [rfReplaceAll, rfIgnoreCase]));
    except
      on E: Exception do
        DumpExceptionCallStack(E);
    end;

    Clipboard.AsText := '';

  end;

end;



procedure TForm1.Button1Click(Sender: TObject);
begin
  try
    if radiobuttoneventid.Checked then
    begin
      OpenURL('http://eventid.net/display.asp?eventid=' + editeventid.Text +
        '&source=' + editsource.Text);
    end
    else
    begin
      OpenURL('https://www.google.com/#q=' + editeventid.Text + '+' +
        stringreplace(editsource.Text, ' ', '+', [rfReplaceAll, rfIgnoreCase]));
      //showmessage('https://www.google.com/#q=' + editeventid.Text + '+' +  stringreplace(editsource.text,' ','+',[rfReplaceAll, rfIgnoreCase]));
    end;


  except
    on E: Exception do
      DumpExceptionCallStack(E);
  end;

end;

procedure TForm1.DumpExceptionCallStack(E: Exception);
var
  I: integer;
  Frames: PPointer;
  Report: string;
begin
  Report := 'Program exception! ' + LineEnding + 'Stacktrace:' +
    LineEnding + LineEnding;
  if E <> nil then
  begin
    Report := Report + 'Exception class: ' + E.ClassName + LineEnding +
      'Message: ' + E.Message + LineEnding;
  end;
  Report := Report + BackTraceStrFunc(ExceptAddr);
  Frames := ExceptFrames;
  for I := 0 to ExceptFrameCount - 1 do
    Report := Report + LineEnding + BackTraceStrFunc(Frames[I]);
  ShowMessage(Report);
  //Halt; // End of program execution
end;


end.
