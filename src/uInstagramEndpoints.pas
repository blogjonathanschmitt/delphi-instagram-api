{*******************************************************}
{                                                       }
{       Delphi + Instagram Integration                  }
{                                                       }
{       Copyright (C) 2017 Jonathan Andrei Schmitt      }
{                                                       }
{       https://jonathanschmitt.blogspot.com.br         }
{                                                       }
{*******************************************************}

unit uInstagramEndpoints;

interface

uses
  uEndpoints, REST.Client, System.SysUtils, System.Classes, Winapi.Windows,
  Winapi.Messages, System.Variants, REST.Json, REST.Utils, REST.Types;

type
  TActionRelationship = (arFollow, arUnfollow, arApprove, arIgnore);

  TInstagramEndpoints = class(TEndpoints)
    procedure RequestAfterExecute(Sender: TCustomRESTRequest);
    procedure OAuth_AccessTokenRedirect(const AURL: string; var DoCloseWebView: boolean);
  public
    function GetAccessToken: string;
    function GetMediaByID(pAccessToken, pMediaID: string): string;
    function GetMediaByShortcode(pAccessToken, pShortcode: string): string;
    function GetRecentMedia(pAccessToken, pLatitude, pLongitude, pDistance: string): string;
    function GetTagByName(pAccessToken, pTagName: string): string;
    function GetTagRecentMediaByName(pAccessToken, pTagName, pCount: string): string;
    function GetTagSearch(pAccessToken, pQuery, pCount: string): string;
    function GetUserContentByID(pAccessToken, pUserID: string): string;
    function GetUserContentSelf(pAccessToken: string): string;
    function GetUserLikedSelf(pAccessToken, pMaxLikeID, pCount: string): string;
    function GetUserRecentMediaByID(pAccessToken, pUserID, pMinID, pMaxID, pCount: string): string;
    function GetUserRecentMediaSelf(pAccessToken, pMinID, pMaxID, pCount: string): string;
    function GetUserSearch(pAccessToken, pQuery, pCount: string): string;
    function GetUserFollowsSelf(pAccessToken: string): string;
    function GetUserFollowedBySelf(pAccessToken: string): string;
    function GetUserRequestedBySelf(pAccessToken: string): string;
    function GetUserContentByAnotherID(pAccessToken, pUserID: string): string;
    function ActionRelationsshipToString(pActionR: TActionRelationship): string;
    function PostUserActionByID(pAccessToken, pUserID: string; pActionRelationship: TActionRelationship): string;
    function GetCommentsByMediaID(pAccessToken, pMediaID: string): string;
    function PostCommentByMediaID(pAccessToken, pMediaID, pComment: string): string;
    function DeleteComment(pAccessToken, pMediaID, pCommentID: string): string;
    function GetLikesByMediaID(pAccessToken, pMediaID: string): string;
    function PostLikeByMediaID(pAccessToken, pMediaID: string): string;
    function DeleteLike(pAccessToken, pMediaID: string): string;
    function GetLocationInfoByID(pAccessToken, pLocationID: string): string;
    function GetLocationRecentMediaByID(pAccessToken, pLocationID, pMaxMediaID, pMinMediaID: string): string;
    function GetLocationsSearch(pAccessToken, pLatitude, pLongitude, pDistance: string): string; overload;
    function GetLocationsSearch(pAccessToken, pDistance, pFacebookPlacesID: string): string; overload;

    constructor Create; override;
    destructor Destroy; override;
  end;

var
  OAuth: TInstagramEndpoints;

implementation

uses
  uWebBrowserOAuth;

{ TInstagramEndpoints }

function TInstagramEndpoints.ActionRelationsshipToString(pActionR: TActionRelationship): string;
begin
  case pActionR of
    arFollow:
      Result := 'follow';
    arUnfollow:
      Result := 'unfollow';
    arApprove:
      Result := 'approve';
    arIgnore:
      Result := 'ignore';
  end;
end;

procedure TInstagramEndpoints.RequestAfterExecute(Sender: TCustomRESTRequest);
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
  except
    on E: Exception do
    begin
      ResponseString := 'Erro ao tentar obter as mídeas mais recentes!' + #13 + #13 + e.Message + #13 + #13 + Request.GetFullRequestURL + #13 + #13 + Response.Content;

      Executed := True;
    end;
  end;
end;

procedure TInstagramEndpoints.OAuth_AccessTokenRedirect(const AURL: string; var DoCloseWebView: boolean);
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

constructor TInstagramEndpoints.Create;
begin
  inherited;

end;

destructor TInstagramEndpoints.Destroy;
begin

  inherited;
end;

function TInstagramEndpoints.GetAccessToken: string;
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
    try
      lWebForm.OnAfterRedirect := OAuth_AccessTokenRedirect;
      lWebForm.ShowModalWithURL(lURL);
      lWebForm.Release;
    finally
      lWebForm.Free;
    end;

    Result := AccessToken.Value;
  except
    on E: Exception do
      MessageBox(0, PChar('Erro ao tentar obter o token de acesso!' + #13 + #13 + e.Message), 'GetAccessToken Error', MB_OK + MB_ICONWARNING);
  end;
end;

function TInstagramEndpoints.GetRecentMedia(pAccessToken, pLatitude, pLongitude, pDistance: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/' + version_api + '/media/search';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  AddParamRequest('lat', pLatitude);
  AddParamRequest('lng', pLongitude);
  AddParamRequest('distance', pDistance);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetMediaByID(pAccessToken, pMediaID: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/' + version_api + '/media/' + pMediaID;
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetMediaByShortcode(pAccessToken, pShortcode: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/' + version_api + '/media/shortcode/' + pShortcode;
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetTagByName(pAccessToken, pTagName: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/' + version_api + '/tags/' + pTagName;
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetTagRecentMediaByName(pAccessToken, pTagName, pCount: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/' + version_api + '/tags/' + pTagName + '/media/recent';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  //AddParamRequest('max_tag_id',pMaxTagID);
  //AddParamRequest('min_tag_id',pMinTagID);
  AddParamRequest('count', pCount);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetTagSearch(pAccessToken, pQuery, pCount: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/tags/search';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('q', pQuery);
  AddParamRequest('count', pCount);
  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetUserContentSelf(pAccessToken: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/' + version_api + '/users/self/';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetUserContentByID(pAccessToken, pUserID: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/' + version_api + '/users/' + pUserID + '/';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetUserRecentMediaSelf(pAccessToken, pMinID, pMaxID, pCount: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/' + version_api + '/users/self/media/recent/';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  AddParamRequest('max_id', pMaxID);
  AddParamRequest('min_id', pMinID);
  AddParamRequest('count', pCount);

  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetUserRecentMediaByID(pAccessToken, pUserID, pMinID, pMaxID, pCount: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/' + version_api + '/users/' + pUserID + '/media/recent/';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  AddParamRequest('max_id', pMaxID);
  AddParamRequest('min_id', pMinID);
  AddParamRequest('count', pCount);

  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetUserLikedSelf(pAccessToken, pMaxLikeID, pCount: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;
  Request.Resource := '/' + version_api + '/users/self/media/liked';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  AddParamRequest('max_like_id', pMaxLikeID);
  AddParamRequest('count', pCount);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetUserSearch(pAccessToken, pQuery, pCount: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/users/search';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('q', pQuery);
  AddParamRequest('count', pCount);
  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetUserFollowsSelf(pAccessToken: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/users/self/follows';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetUserFollowedBySelf(pAccessToken: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/users/self/followed-by';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetUserRequestedBySelf(pAccessToken: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/users/self/requested-by';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetUserContentByAnotherID(pAccessToken, pUserID: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/users/' + pUserID + '/relationship';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.PostUserActionByID(pAccessToken, pUserID: string; pActionRelationship: TActionRelationship): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/users/' + pUserID + '/relationship';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmPost;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  AddParamRequest('action', ActionRelationsshipToString(pActionRelationship));
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetCommentsByMediaID(pAccessToken, pMediaID: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/media/' + pMediaID + '/comments';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.PostCommentByMediaID(pAccessToken, pMediaID, pComment: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/media/' + pMediaID + '/comments';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmPost;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  AddParamRequest('text', pComment);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.DeleteComment(pAccessToken, pMediaID, pCommentID: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/media/' + pMediaID + '/comments/' + pCommentID;
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmDELETE;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetLikesByMediaID(pAccessToken, pMediaID: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/media/' + pMediaID + '/likes';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.PostLikeByMediaID(pAccessToken, pMediaID: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/media/' + pMediaID + '/likes';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmPost;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.DeleteLike(pAccessToken, pMediaID: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/media/' + pMediaID + '/likes';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmDELETE;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetLocationInfoByID(pAccessToken, pLocationID: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/locations/' + pLocationID;
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetLocationRecentMediaByID(pAccessToken, pLocationID, pMaxMediaID, pMinMediaID: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/locations/' + pLocationID + '/media/recent';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  AddParamRequest('max_id', pMaxMediaID);
  AddParamRequest('min_id', pMinMediaID);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetLocationsSearch(pAccessToken, pLatitude, pLongitude, pDistance: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/locations/search';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  AddParamRequest('anos', pLatitude);
  AddParamRequest('lng', pLongitude);
  AddParamRequest('distance', pDistance);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

function TInstagramEndpoints.GetLocationsSearch(pAccessToken, pDistance, pFacebookPlacesID: string): string;
begin
  Result := '';
  Executed := False;

  Client.BaseURL := BaseURL;

  Request.Resource := '/' + version_api + '/locations/search';
  Request.OnAfterExecute := RequestAfterExecute;
  Request.Method := rmGET;
  OAuth.AccessToken := pAccessToken;

  AddParamRequest('access_token', pAccessToken);
  AddParamRequest('distance', pDistance);
  AddParamRequest('facebook_places_id', pFacebookPlacesID);
  try
    Request.Execute;

    while not Executed do
    begin
    end;
  except
    on E: Exception do
      while not Executed do
      begin
      end;
  end;

  Result := ResponseString;
end;

end.

