unit uRESTComponents;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Winapi.Messages, System.Variants, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, IPPeerClient, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Authenticator.OAuth, REST.Types, REST.Authenticator.OAuth.WebForm.Win, REST.Utils,
  REST.Response.Adapter, Data.DB, Datasnap.DBClient, REST.JSON;

type
  TRESTComponents = class
  private
    FRequest: TRESTRequest;
    FResponse: TRESTResponse;
    FOAuth: TOAuth2Authenticator;
    FDataSetAdapter: TRESTResponseDataSetAdapter;
    FClient: TRESTClient;
    procedure SetClient(const Value: TRESTClient);
    procedure SetDataSetAdapter(const Value: TRESTResponseDataSetAdapter);
    procedure SetOAuth(const Value: TOAuth2Authenticator);
    procedure SetRequest(const Value: TRESTRequest);
    procedure SetResponse(const Value: TRESTResponse);

  public
    property OAuth: TOAuth2Authenticator read FOAuth write SetOAuth;
    property Request: TRESTRequest read FRequest write SetRequest;
    property Client: TRESTClient read FClient write SetClient;
    property Response: TRESTResponse read FResponse write SetResponse;
    property DataSetAdapter: TRESTResponseDataSetAdapter read FDataSetAdapter write SetDataSetAdapter;

    constructor Create;
    destructor Destroy;
  end;

var
  OAuthInstagram: TRESTComponents;

implementation

uses
  uWebBrowserOAuth;

{ TRESTComponents }

constructor TRESTComponents.Create;
begin
  FOAuth := TOAuth2Authenticator.Create(nil);
  FRequest := TRESTRequest.Create(nil);
  FClient := TRESTClient.Create(nil);
  FResponse := TRESTResponse.Create(nil);
  FDataSetAdapter := TRESTResponseDataSetAdapter.Create(nil);
end;

destructor TRESTComponents.Destroy;
begin
  FreeAndNil(FOAuth);
  FreeAndNil(FRequest);
  FreeAndNil(FClient);
  FreeAndNil(FResponse);
  FreeAndNil(FDataSetAdapter);
end;

procedure TRESTComponents.SetClient(const Value: TRESTClient);
begin
  FClient := Value;
end;

procedure TRESTComponents.SetDataSetAdapter(
  const Value: TRESTResponseDataSetAdapter);
begin
  FDataSetAdapter := Value;
end;

procedure TRESTComponents.SetOAuth(const Value: TOAuth2Authenticator);
begin
  FOAuth := Value;
end;

procedure TRESTComponents.SetRequest(const Value: TRESTRequest);
begin
  FRequest := Value;
end;

procedure TRESTComponents.SetResponse(const Value: TRESTResponse);
begin
  FResponse := Value;
end;

end.
