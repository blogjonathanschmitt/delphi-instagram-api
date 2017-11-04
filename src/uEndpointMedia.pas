unit uEndpointMedia;

interface

uses
  uEndpoints,
  REST.Client,
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Winapi.Messages,
  System.Variants,
  REST.Json;

type
  TEndpointMedia = class(TEndpoints)
  public
    function GetRecentMedia(pAccessToken, pLatitude, pLongitude, pDistance: String): String;
    function GetMediaByID(pAccessToken, pMediaID: String): String;
    function GetMediaByShortcode(pAccessToken, pShortcode: String): String;

    constructor Create; override;
    destructor Destroy; override;

  end;

implementation

{ TEndpointMedia }

constructor TEndpointMedia.Create;
begin
  inherited;


end;

destructor TEndpointMedia.Destroy;
begin

  inherited;
end;

function TEndpointMedia.GetRecentMedia(pAccessToken, pLatitude, pLongitude, pDistance: String): String;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/v1/media/search';
  Request.OnAfterExecute := RequestAfterExecute;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token',pAccessToken);
  AddParamRequest('lat', pLatitude);
  AddParamRequest('lng', pLongitude);
  AddParamRequest('distance', pDistance);
  try
    Request.Execute;

    while not Executed do begin end;
  except on E: Exception do
    while not Executed do begin end;
  end;

  Result := ResponseString;
end;

function TEndpointMedia.GetMediaByID(pAccessToken, pMediaID: String): String;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/v1/media/' + pMediaID;
  Request.OnAfterExecute := RequestAfterExecute;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token',pAccessToken);
  try
    Request.Execute;

    while not Executed do begin end;
  except on E: Exception do
    while not Executed do begin end;
  end;

  Result := ResponseString;
end;

function TEndpointMedia.GetMediaByShortcode(pAccessToken, pShortcode: String): String;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/v1/media/shortcode/' + pShortcode;
  Request.OnAfterExecute := RequestAfterExecute;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token',pAccessToken);
  try
    Request.Execute;

    while not Executed do begin end;
  except on E: Exception do
    while not Executed do begin end;
  end;

  Result := ResponseString;
end;

end.
