unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.Maps, System.Rtti,
  FMX.Grid.Style, FMX.Grid;

type
  TfrmMain = class(TForm)
    mmoResult: TMemo;
    btnGetAccessToken: TButton;
    btn2: TButton;
    edtAccessToken: TEdit;
    lbl1: TLabel;
    Button1: TButton;
    edtMideaID: TEdit;
    Label1: TLabel;
    lbl2: TLabel;
    edtLatitude: TEdit;
    lbl3: TLabel;
    edtLongitude: TEdit;
    lbl4: TLabel;
    edtDistance: TEdit;
    Button2: TButton;
    edtShortcode: TEdit;
    Label2: TLabel;
    Button3: TButton;
    Button4: TButton;
    Label3: TLabel;
    edtUserID: TEdit;
    Button5: TButton;
    lbl5: TLabel;
    edtMinID: TEdit;
    lbl6: TLabel;
    edtMaxID: TEdit;
    lbl7: TLabel;
    edtCount: TEdit;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    edtQuery: TEdit;
    Label4: TLabel;
    Button9: TButton;
    Label5: TLabel;
    edtTagName: TEdit;
    Button10: TButton;
    Button11: TButton;
    edtClientID: TEdit;
    Label6: TLabel;
    edtClientSecret: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edtRedirectURI: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    procedure btnGetAccessTokenClick(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uInstagramEndpoints;

{$R *.fmx}

procedure TfrmMain.btnGetAccessTokenClick(Sender: TObject);
var
  lEndpoint: TInstagramEndpoints;
begin
  lEndpoint := TInstagramEndpoints.Create;
  try
    lEndpoint.client_id := edtClientID.text;
    lEndpoint.client_secret := edtClientSecret.Text;
    lEndpoint.redirect_uri := edtRedirectURI.text;
    edtAccessToken.Text := lEndpoint.GetAccessToken;
  finally
    FreeAndNil(lEndpoint);
  end;
end;

procedure TfrmMain.btn2Click(Sender: TObject);
var
  lEndpoint: TInstagramEndpoints;
begin
  lEndpoint := TInstagramEndpoints.Create;
  try
    if Trim(edtAccessToken.Text) = '' then
      btnGetAccessTokenClick(btnGetAccessToken);

    lEndpoint.client_id := edtClientID.text;
    lEndpoint.client_secret := edtClientSecret.Text;
    lEndpoint.redirect_uri := edtRedirectURI.text;
    mmoResult.Text := lEndpoint.GetRecentMedia(edtAccessToken.Text, edtLatitude.Text, edtLongitude.Text, edtDistance.Text);
  finally
    FreeAndNil(lEndpoint);
  end;
end;

procedure TfrmMain.Button10Click(Sender: TObject);
var
  lEndpoint: TInstagramEndpoints;
begin
  lEndpoint := TInstagramEndpoints.Create;
  try
    if Trim(edtAccessToken.Text) = '' then
      btnGetAccessTokenClick(btnGetAccessToken);

    lEndpoint.client_id := edtClientID.text;
    lEndpoint.client_secret := edtClientSecret.Text;
    lEndpoint.redirect_uri := edtRedirectURI.text;
    mmoResult.Text := lEndpoint.GetTagRecentMediaByName(edtAccessToken.Text, edtTagName.Text, edtCount.Text);
  finally
    FreeAndNil(lEndpoint);
  end;
end;

procedure TfrmMain.Button11Click(Sender: TObject);
var
  lEndpoint: TInstagramEndpoints;
begin
  lEndpoint := TInstagramEndpoints.Create;
  try
    if Trim(edtAccessToken.Text) = '' then
      btnGetAccessTokenClick(btnGetAccessToken);

    lEndpoint.client_id := edtClientID.text;
    lEndpoint.client_secret := edtClientSecret.Text;
    lEndpoint.redirect_uri := edtRedirectURI.text;
    mmoResult.Text := lEndpoint.GetTagSearch(edtAccessToken.Text, edtTagName.Text, edtCount.Text);
  finally
    FreeAndNil(lEndpoint);
  end;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
  lEndpoint: TInstagramEndpoints;
begin
  lEndpoint := TInstagramEndpoints.Create;
  try
    if Trim(edtAccessToken.Text) = '' then
      btnGetAccessTokenClick(btnGetAccessToken);

    lEndpoint.client_id := edtClientID.text;
    lEndpoint.client_secret := edtClientSecret.Text;
    lEndpoint.redirect_uri := edtRedirectURI.text;
    mmoResult.Text := lEndpoint.GetMediaByID(edtAccessToken.Text, edtMideaID.Text);
  finally
    FreeAndNil(lEndpoint);
  end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  lEndpoint: TInstagramEndpoints;
begin
  lEndpoint := TInstagramEndpoints.Create;
  try
    if Trim(edtAccessToken.Text) = '' then
      btnGetAccessTokenClick(btnGetAccessToken);

    lEndpoint.client_id := edtClientID.text;
    lEndpoint.client_secret := edtClientSecret.Text;
    lEndpoint.redirect_uri := edtRedirectURI.text;
    mmoResult.Text := lEndpoint.GetMediaByShortcode(edtAccessToken.Text, edtShortcode.Text);
  finally
    FreeAndNil(lEndpoint);
  end;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
var
  lEndpoint: TInstagramEndpoints;
begin
  lEndpoint := TInstagramEndpoints.Create;
  try
    if Trim(edtAccessToken.Text) = '' then
      btnGetAccessTokenClick(btnGetAccessToken);

    lEndpoint.client_id := edtClientID.text;
    lEndpoint.client_secret := edtClientSecret.Text;
    lEndpoint.redirect_uri := edtRedirectURI.text;
    mmoResult.Text := lEndpoint.GetUserContentSelf(edtAccessToken.Text);
  finally
    FreeAndNil(lEndpoint);
  end;
end;

procedure TfrmMain.Button4Click(Sender: TObject);
var
  lEndpoint: TInstagramEndpoints;
begin
  lEndpoint := TInstagramEndpoints.Create;
  try
    if Trim(edtAccessToken.Text) = '' then
      btnGetAccessTokenClick(btnGetAccessToken);

    lEndpoint.client_id := edtClientID.text;
    lEndpoint.client_secret := edtClientSecret.Text;
    lEndpoint.redirect_uri := edtRedirectURI.text;
    mmoResult.Text := lEndpoint.GetUserContentByID(edtAccessToken.Text, edtUserID.Text);
  finally
    FreeAndNil(lEndpoint);
  end;
end;

procedure TfrmMain.Button5Click(Sender: TObject);
var
  lEndpoint: TInstagramEndpoints;
begin
  lEndpoint := TInstagramEndpoints.Create;
  try
    if Trim(edtAccessToken.Text) = '' then
      btnGetAccessTokenClick(btnGetAccessToken);

    lEndpoint.client_id := edtClientID.text;
    lEndpoint.client_secret := edtClientSecret.Text;
    lEndpoint.redirect_uri := edtRedirectURI.text;
    mmoResult.Text := lEndpoint.GetUserRecentMediaSelf(edtAccessToken.Text, edtMinID.Text, edtMaxID.Text, edtCount.Text);
  finally
    FreeAndNil(lEndpoint);
  end;
end;

procedure TfrmMain.Button6Click(Sender: TObject);
var
  lEndpoint: TInstagramEndpoints;
begin
  lEndpoint := TInstagramEndpoints.Create;
  try
    if Trim(edtAccessToken.Text) = '' then
      btnGetAccessTokenClick(btnGetAccessToken);

    lEndpoint.client_id := edtClientID.text;
    lEndpoint.client_secret := edtClientSecret.Text;
    lEndpoint.redirect_uri := edtRedirectURI.text;
    mmoResult.Text := lEndpoint.GetUserRecentMediaByID(edtAccessToken.Text, edtUserID.Text, edtMinID.Text, edtMaxID.Text, edtCount.Text);
  finally
    FreeAndNil(lEndpoint);
  end;
end;

procedure TfrmMain.Button7Click(Sender: TObject);
var
  lEndpoint: TInstagramEndpoints;
begin
  lEndpoint := TInstagramEndpoints.Create;
  try
    if Trim(edtAccessToken.Text) = '' then
      btnGetAccessTokenClick(btnGetAccessToken);

    lEndpoint.client_id := edtClientID.text;
    lEndpoint.client_secret := edtClientSecret.Text;
    lEndpoint.redirect_uri := edtRedirectURI.text;
    mmoResult.Text := lEndpoint.GetUserLikedSelf(edtAccessToken.Text, edtMaxID.Text, edtCount.Text);
  finally
    FreeAndNil(lEndpoint);
  end;
end;

procedure TfrmMain.Button8Click(Sender: TObject);
var
  lEndpoint: TInstagramEndpoints;
begin
  lEndpoint := TInstagramEndpoints.Create;
  try
    if Trim(edtAccessToken.Text) = '' then
      btnGetAccessTokenClick(btnGetAccessToken);

    lEndpoint.client_id := edtClientID.text;
    lEndpoint.client_secret := edtClientSecret.Text;
    lEndpoint.redirect_uri := edtRedirectURI.text;
    mmoResult.Text := lEndpoint.GetUserSearch(edtAccessToken.Text, edtQuery.Text, edtCount.Text);
  finally
    FreeAndNil(lEndpoint);
  end;
end;

procedure TfrmMain.Button9Click(Sender: TObject);
var
  lEndpoint: TInstagramEndpoints;
begin
  lEndpoint := TInstagramEndpoints.Create;
  try
    if Trim(edtAccessToken.Text) = '' then
      btnGetAccessTokenClick(btnGetAccessToken);

    lEndpoint.client_id := edtClientID.text;
    lEndpoint.client_secret := edtClientSecret.Text;
    lEndpoint.redirect_uri := edtRedirectURI.text;
    mmoResult.Text := lEndpoint.GetTagByName(edtAccessToken.Text, edtTagName.Text);
  finally
    FreeAndNil(lEndpoint);
  end;
end;

end.

