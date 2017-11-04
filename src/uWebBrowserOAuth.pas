unit uWebBrowserOAuth;

interface

uses
  REST.Authenticator.OAuth.WebForm.Win, System.SysUtils, System.Types, System.Variants, System.Classes, SHDocVw,
  FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls,
  FMX.Types, FMX.WebBrowser;

type
  TOAuth2WebFormRedirectEvent = procedure(const AURL: string; var DoCloseWebView : boolean) of object;
  TOAuth2WebFormTitleChangedEvent = procedure(const ATitle: string; var DoCloseWebView : boolean) of object;

  TfrmWebBrowserOAuth = class(TForm)
    wbOAuth: TWebBrowser;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure BrowserNavigateComplete2(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
    procedure BrowserBeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure BrowserDocumentComplete(ASender: TObject; const pDisp: IDispatch;
      const URL: OleVariant);
    procedure wbOAuthDidFinishLoad(ASender: TObject);
  private
    { Private declarations }
    FOnBeforeRedirect: TOAuth2WebFormRedirectEvent;
    FOnAfterRedirect: TOAuth2WebFormRedirectEvent;

    FLastTitle: string;
    FLastURL: string;
  public
    { Public declarations }
    procedure ShowWithURL(const AURL: string);
    procedure ShowModalWithURL(const AURL: string); //deprecated 'Please use ShowWithURL() instead. Sorry for inconvenience.';

    property LastTitle: string read FLastTitle;
    property LastURL: string read FLastURL;

    property OnAfterRedirect: TOAuth2WebFormRedirectEvent read FOnAfterRedirect write FOnAfterRedirect;
    property OnBeforeRedirect: TOAuth2WebFormRedirectEvent read FOnBeforeRedirect write FOnBeforeRedirect;
  end;

var
  frmWebBrowserOAuth: TfrmWebBrowserOAuth;

implementation

{$R *.fmx}

procedure TfrmWebBrowserOAuth.BrowserBeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
  LDoCloseForm : boolean;
begin
  if Assigned(FOnBeforeRedirect) then
  begin
    LDoCloseForm:= FALSE;

    FOnBeforeRedirect(URL, LDoCloseForm);

    if LDoCloseForm then
    begin
      Cancel:= TRUE;
      self.Close;
    end;
  end;
end;

procedure TfrmWebBrowserOAuth.BrowserDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  LDoCloseForm : boolean;
begin
  FLastURL := VarToStrDef(URL, '');

  if Assigned(FOnAfterRedirect) then
  begin
    LDoCloseForm:= FALSE;

    FOnAfterRedirect(FLastURL, LDoCloseForm);

    if LDoCloseForm then
      self.Close;
  end;
end;

procedure TfrmWebBrowserOAuth.BrowserNavigateComplete2(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
var
  LDoCloseForm : boolean;
begin
  FLastURL := VarToStrDef(URL, '');

  if Assigned(FOnAfterRedirect) then
  begin
    LDoCloseForm:= FALSE;

    FOnAfterRedirect(FLastURL, LDoCloseForm);

    if LDoCloseForm then
      self.Close;
  end;
end;

procedure TfrmWebBrowserOAuth.FormCreate(Sender: TObject);
begin
  FOnAfterRedirect := NIL;
  FOnBeforeRedirect:= NIL;

  FLastTitle := '';
  FLastURL := '';
end;

procedure TfrmWebBrowserOAuth.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Close;
  end;
end;

procedure TfrmWebBrowserOAuth.ShowModalWithURL(const AURL: string);
begin
  /// for backwards-compatibility only
  ShowWithURL( AURL );
end;

procedure TfrmWebBrowserOAuth.ShowWithURL(const AURL: string);
begin
  wbOAuth.Navigate(AURL);
  self.ShowModal;
end;

procedure TfrmWebBrowserOAuth.wbOAuthDidFinishLoad(ASender: TObject);
var
  LDoCloseForm : boolean;
begin
  FLastURL := VarToStrDef(wbOAuth.URL, '');
  if Pos('#access_token=', wbOAuth.URL) > 0 then
    begin
      if Assigned(FOnAfterRedirect) then
      begin
        LDoCloseForm:= FALSE;

        FOnAfterRedirect(FLastURL, LDoCloseForm);

        if LDoCloseForm then
          self.Close;
      end;
    end;
end;

end.
