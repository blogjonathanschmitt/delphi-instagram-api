unit uEndpointUsers;

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
  TEndpointUsers = class(TEndpoints)
  public
    function GetUserContentSelf(pAccessToken: String): String;
    function GetUserContentByID(pAccessToken, pUserID: String): String;
    function GetUserRecentMediaSelf(pAccessToken, pMinID, pMaxID, pCount: String): String;
    function GetUserRecentMediaByID(pAccessToken, pUserID, pMinID, pMaxID, pCount: String): String;
    function GetUserLikedSelf(pAccessToken, pMaxLikeID, pCount: String): String;
    function GetUserSearch(pAccessToken, pQuery, pCount: String): String;

    constructor Create; override;
    destructor Destroy; override;

  end;

implementation

{ TEndpointUsers }

constructor TEndpointUsers.Create;
begin
  inherited;


end;

destructor TEndpointUsers.Destroy;
begin

  inherited;
end;

function TEndpointUsers.GetUserContentSelf(pAccessToken: String): String;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/v1/users/self/';
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

function TEndpointUsers.GetUserContentByID(pAccessToken, pUserID: String): String;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/v1/users/' + pUserID + '/';
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

function TEndpointUsers.GetUserRecentMediaSelf(pAccessToken, pMinID, pMaxID, pCount: String): String;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/v1/users/self/media/recent/';
  Request.OnAfterExecute := RequestAfterExecute;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token',pAccessToken);
  AddParamRequest('max_id',pMaxID);
  AddParamRequest('min_id',pMinID);
  AddParamRequest('count',pCount);

  try
    Request.Execute;

    while not Executed do begin end;
  except on E: Exception do
    while not Executed do begin end;
  end;

  Result := ResponseString;
end;

function TEndpointUsers.GetUserRecentMediaByID(pAccessToken, pUserID, pMinID, pMaxID, pCount: String): String;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/v1/users/' + pUserID + '/media/recent/';
  Request.OnAfterExecute := RequestAfterExecute;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token',pAccessToken);
  AddParamRequest('max_id',pMaxID);
  AddParamRequest('min_id',pMinID);
  AddParamRequest('count',pCount);

  try
    Request.Execute;

    while not Executed do begin end;
  except on E: Exception do
    while not Executed do begin end;
  end;

  Result := ResponseString;
end;

function TEndpointUsers.GetUserLikedSelf(pAccessToken, pMaxLikeID, pCount: String): String;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/v1/users/self/media/liked';
  Request.OnAfterExecute := RequestAfterExecute;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token',pAccessToken);
  AddParamRequest('max_like_id',pMaxLikeID);
  AddParamRequest('count',pCount);
  try
    Request.Execute;

    while not Executed do begin end;
  except on E: Exception do
    while not Executed do begin end;
  end;

  Result := ResponseString;
end;

function TEndpointUsers.GetUserSearch(pAccessToken, pQuery, pCount: String): String;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/v1/users/search';
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
