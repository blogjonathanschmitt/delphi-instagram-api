unit uEndpointTags;

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
  TEndpointTags = class(TEndpoints)
  public
    function GetTagByName(pAccessToken, pTagName: String): String;
    function GetTagRecentMediaByName(pAccessToken, pTagName, pCount: String): String;
    function GetTagSearch(pAccessToken, pQuery, pCount: String): String;

    constructor Create; override;
    destructor Destroy; override;

  end;

implementation

{ TEndpointTags }

constructor TEndpointTags.Create;
begin
  inherited;


end;

destructor TEndpointTags.Destroy;
begin

  inherited;
end;

function TEndpointTags.GetTagByName(pAccessToken, pTagName: String): String;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/v1/tags/' + pTagName;
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

function TEndpointTags.GetTagRecentMediaByName(pAccessToken, pTagName, pCount: String): String;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/v1/tags/' + pTagName + '/media/recent';
  Request.OnAfterExecute := RequestAfterExecute;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token',pAccessToken);
  AddParamRequest('count',pCount);
  try
    Request.Execute;

    while not Executed do begin end;
  except on E: Exception do
    while not Executed do begin end;
  end;

  Result := ResponseString;
end;

function TEndpointTags.GetTagSearch(pAccessToken, pQuery, pCount: String): String;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/v1/tags/search';
  Request.OnAfterExecute := RequestAfterExecute;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('q',pQuery);
  AddParamRequest('count',pCount);
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
