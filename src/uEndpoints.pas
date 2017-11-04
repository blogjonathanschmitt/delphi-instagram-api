{*******************************************************}
{                                                       }
{       Delphi + Instagram Integration                  }
{                                                       }
{       Copyright (C) 2017 Jonathan Andrei Schmitt      }
{                                                       }
{       https://jonathanschmitt.blogspot.com.br         }
{                                                       }
{*******************************************************}

unit uEndpoints;

interface

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Winapi.Messages,
  System.Variants,
  uScopeRequeriment,
  uAccessToken,
  REST.Authenticator.OAuth,
  REST.Types,
  REST.Response.Adapter,
  REST.Client,
  REST.JSON,
  uRESTComponents;

type
  TEndpoints = class
    procedure RequestAfterExecute(Sender: TCustomRESTRequest);
  private
    FRESTComponents: TRESTComponents;

    FAccessToken: TAccessToken;
    FRelationships: TScopeRequeriment;
    FPublicContent: TScopeRequeriment;
    FLikes: TScopeRequeriment;
    FBasic: TScopeRequeriment;
    FFollowerList: TScopeRequeriment;
    FComments: TScopeRequeriment;
    FBaseURL: string;
    FRequest: TRESTRequest;
    FResponse: TRESTResponse;
    FOAuth: TOAuth2Authenticator;
    FDataSetAdapter: TRESTResponseDataSetAdapter;
    FClient: TRESTClient;
    FResponseString: string;
    FExecuted: boolean;
    Fclient_id: string;
    Fclient_secret: string;
    Fredirect_uri: string;
    Fversion_api: string;

    procedure SetAccessToken(const Value: TAccessToken);
    procedure SetRequeriedBasic(const Value: TScopeRequeriment);
    procedure SetRequeriedComments(const Value: TScopeRequeriment);
    procedure SetRequeriedFollowerList(const Value: TScopeRequeriment);
    procedure SetRequeriedLikes(const Value: TScopeRequeriment);
    procedure SetRequeriedPublicContent(const Value: TScopeRequeriment);
    procedure SetRequeriedRelationships(const Value: TScopeRequeriment);
    procedure SetBaseURL(const Value: string);
    procedure SetClient(const Value: TRESTClient);
    procedure SetDataSetAdapter(const Value: TRESTResponseDataSetAdapter);
    procedure SetOAuth(const Value: TOAuth2Authenticator);
    procedure SetRequest(const Value: TRESTRequest);
    procedure SetResponse(const Value: TRESTResponse);
    procedure SetExecuted(const Value: boolean);
    procedure SetResponseString(const Value: string);
    procedure Setclient_id(const Value: string);
    procedure Setclient_secret(const Value: string);
    procedure Setredirect_uri(const Value: string);
    procedure Setversion_api(const Value: string);

  protected
    const
      grant_type: String = 'authorization_code';
      response_type: String = 'token';

    {* Default Requeriments *}
    property Basic: TScopeRequeriment read FBasic write SetRequeriedBasic;
    property PublicContent: TScopeRequeriment read FPublicContent write SetRequeriedPublicContent;
    property FollowerList: TScopeRequeriment read FFollowerList write SetRequeriedFollowerList;
    property Comments: TScopeRequeriment read FComments write SetRequeriedComments;
    property Relationships: TScopeRequeriment read FRelationships write SetRequeriedRelationships;
    property Likes: TScopeRequeriment read FLikes write SetRequeriedLikes;

    //Default Parameters
    property AccessToken: TAccessToken read FAccessToken write SetAccessToken;

    //REST Components
    property OAuth: TOAuth2Authenticator read FOAuth write SetOAuth;
    property Request: TRESTRequest read FRequest write SetRequest;
    property Client: TRESTClient read FClient write SetClient;
    property Response: TRESTResponse read FResponse write SetResponse;
    property DataSetAdapter: TRESTResponseDataSetAdapter read FDataSetAdapter write SetDataSetAdapter;

    //API domain
    property BaseURL: string read FBaseURL write SetBaseURL;

    property Executed: boolean read FExecuted write SetExecuted;
    property ResponseString: string read FResponseString write SetResponseString;

    procedure ResetRESTComponentsToDefaults;
    procedure AddParamRequest(pName, pValue: String);
    function scope: String;

  public
    property client_id: string read Fclient_id write Setclient_id;
    property client_secret: string read Fclient_secret write Setclient_secret;
    property redirect_uri: string read Fredirect_uri write Setredirect_uri;
    property version_api: string read Fversion_api write Setversion_api;

    constructor Create; virtual;
    destructor Destroy; virtual;
  end;

implementation

{ TEndpoints }

constructor TEndpoints.Create;
begin
  inherited;
  FBasic := TScopeRequeriment.Create;
  FPublicContent := TScopeRequeriment.Create;
  FFollowerList := TScopeRequeriment.Create;
  FComments := TScopeRequeriment.Create;
  FRelationships := TScopeRequeriment.Create;
  FLikes := TScopeRequeriment.Create;
  FAccessToken := TAccessToken.Create;

  //Default for all
  FBasic.requeried := True;

  FBasic.AsString := 'basic';
  FPublicContent.AsString := 'public_content';
  FRelationships.AsString := 'relationships';
  FLikes.AsString := 'likes';
  FFollowerList.AsString := 'follower_list';
  FComments.AsString := 'comments';

  //Seting components pointers
  FRESTComponents := TRESTComponents.Create;
  FOAuth := FRESTComponents.OAuth;
  FRequest := FRESTComponents.Request;
  FResponse := FRESTComponents.Response;
  FClient := FRESTComponents.Client;
  FDataSetAdapter := FRESTComponents.DataSetAdapter;

  ResetRESTComponentsToDefaults;

  BaseURL := 'https://api.instagram.com';
  version_api := 'v1';
end;

destructor TEndpoints.Destroy;
begin
  FreeAndNil(FBasic);
  FreeAndNil(FPublicContent);
  FreeAndNil(FFollowerList);
  FreeAndNil(FComments);
  FreeAndNil(FRelationships);
  FreeAndNil(FLikes);
  FreeAndNil(FAccessToken);
  FreeAndNil(FRESTComponents);
  inherited;
end;

procedure TEndpoints.ResetRESTComponentsToDefaults;
begin
  FRequest.ResetToDefaults;
  FClient.ResetToDefaults;
  FResponse.ResetToDefaults;
  FDataSetAdapter.ResetToDefaults;
  FOAuth.ResetToDefaults;

  FRequest.Client := FClient;
  FRequest.Response := FResponse;
  FClient.Authenticator := FOAuth;
  FDataSetAdapter.Response := FResponse;

  FOAuth.ClientId := client_id;
  FOAuth.ClientSecret := client_secret;
end;

procedure TEndpoints.AddParamRequest(pName, pValue: String);
begin
  with FRequest.Params.AddItem do
  begin
    Name := pName;
    Value := pValue;
    Kind := pkGETorPOST;
  end;
end;

function TEndpoints.scope: String;
begin
  Result := '';
  if Basic.requeried then
    Result := Result + Basic.AsString;

  if PublicContent.requeried then
    Result := Result + '+' + PublicContent.AsString;

  if Relationships.requeried then
    Result := Result + '+' + Relationships.AsString;

  if Likes.requeried then
    Result := Result + '+' + Likes.AsString;

  if FollowerList.requeried then
    Result := Result + '+' + FollowerList.AsString;

  if Comments.requeried then
    Result := Result + '+' + Comments.AsString;
end;

procedure TEndpoints.RequestAfterExecute(Sender: TCustomRESTRequest);
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

procedure TEndpoints.SetBaseURL(const Value: string);
begin
  FBaseURL := Value;
end;

procedure TEndpoints.SetClient(const Value: TRESTClient);
begin
  FClient := Value;
end;

procedure TEndpoints.Setclient_id(const Value: string);
begin
  Fclient_id := Value;
end;

procedure TEndpoints.Setclient_secret(const Value: string);
begin
  Fclient_secret := Value;
end;

procedure TEndpoints.SetDataSetAdapter(
  const Value: TRESTResponseDataSetAdapter);
begin
  FDataSetAdapter := Value;
end;

procedure TEndpoints.SetExecuted(const Value: boolean);
begin
  FExecuted := Value;
end;

procedure TEndpoints.SetOAuth(const Value: TOAuth2Authenticator);
begin
  FOAuth := Value;
end;

procedure TEndpoints.Setredirect_uri(const Value: string);
begin
  Fredirect_uri := Value;
end;

procedure TEndpoints.SetAccessToken(const Value: TAccessToken);
begin
  FAccessToken := Value;
end;

procedure TEndpoints.SetRequeriedBasic(const Value: TScopeRequeriment);
begin
  FBasic := Value;
end;

procedure TEndpoints.SetRequeriedComments(const Value: TScopeRequeriment);
begin
  FComments := Value;
end;

procedure TEndpoints.SetRequeriedFollowerList(const Value: TScopeRequeriment);
begin
  FFollowerList := Value;
end;

procedure TEndpoints.SetRequeriedLikes(const Value: TScopeRequeriment);
begin
  FLikes := Value;
end;

procedure TEndpoints.SetRequeriedPublicContent(const Value: TScopeRequeriment);
begin
  FPublicContent := Value;
end;

procedure TEndpoints.SetRequeriedRelationships(const Value: TScopeRequeriment);
begin
  FRelationships := Value;
end;

procedure TEndpoints.SetRequest(const Value: TRESTRequest);
begin
  FRequest := Value;
end;

procedure TEndpoints.SetResponse(const Value: TRESTResponse);
begin
  FResponse := Value;
end;

procedure TEndpoints.SetResponseString(const Value: string);
begin
  FResponseString := Value;
end;

procedure TEndpoints.Setversion_api(const Value: string);
begin
  Fversion_api := Value;
end;

end.
