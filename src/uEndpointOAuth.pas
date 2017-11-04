unit uEndpointOAuth;

interface

uses
  uEndpoints,
  REST.Client,
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Winapi.Messages,
  System.Variants,
  REST.Json,
  REST.Utils;

type
  TEndpointOAuth = class(TEndpoints)
    procedure RequestAfterExecute(Sender: TCustomRESTRequest);
    procedure OAuth_AccessTokenRedirect(const AURL: string; var DoCloseWebView : boolean);

  public
    function GetAccessToken: String;

    constructor Create; override;
    destructor Destroy; override;
  end;

var
  OAuth: TEndpointOAuth;

implementation

uses
  uWebBrowserOAuth;

{ TEndpointOAuth }

procedure TEndpointOAuth.RequestAfterExecute(Sender: TCustomRESTRequest);
begin
  try
    if Assigned(Response.JSONValue) then
    begin
      Executed := True;
      ResponseString := TJson.Format(Response.JSONValue)
    end
    else
    begin
      ResponseString := Response.Content;
    end;
  except on E: Exception do
    begin
      ResponseString := 'Erro ao tentar obter as mídeas mais recentes!' + #13 + #13
        + e.Message + #13 + #13 + Request.GetFullRequestURL+ #13 + #13 +
        Response.Content;

      Executed := True;
    end;
  end;
end;

procedure TEndpointOAuth.OAuth_AccessTokenRedirect(const AURL: string; var DoCloseWebView : boolean);
var
  LATPos: integer;
  LToken: string;
begin
  LATPos := Pos('access_token=', AURL);
  if (LATPos > 0) then
  begin
    LToken := Copy(AURL, LATPos + 13, Length(AURL));
    if (Pos('&', LToken) > 0) then
    begin
      LToken := Copy(LToken, 1, Pos('&', LToken) - 1);
    end;

    AccessToken.Value := LToken;
    if (LToken <> '') then
      DoCloseWebView := True;
  end;
end;

constructor TEndpointOAuth.Create;
begin
  inherited;

end;

destructor TEndpointOAuth.Destroy;
begin

  inherited;
end;

function TEndpointOAuth.GetAccessToken: String;
var
  lURL: string;
  lWebForm: TfrmWebBrowserOAuth;
begin
  try
    Result := '';
    ResetRESTComponentsToDefaults;

    lURL := BaseURL + '/oauth/authorize/';
    lURL := lURL + '?client_id=' + client_id;
    lURL := lURL + '&response_type=' + response_type;
    lURL := lURL + '&scope=' + URIEncode(scope);
    lURL := lURL + '&redirect_uri=' + URIEncode(redirect_uri);

    lWebForm := TfrmWebBrowserOAuth.Create(nil);
    lWebForm.OnAfterRedirect := OAuth_AccessTokenRedirect;
    lWebForm.ShowModalWithURL(lURL);
    lWebForm.Release;

    Result := AccessToken.Value;
  except on E: Exception do
    MessageBox(0, PChar('Erro ao tentar obter o token de acesso!' + #13 + #13 + e.Message),
      'GetAccessToken Error', MB_OK + MB_ICONWARNING);
  end;
end;

end.
