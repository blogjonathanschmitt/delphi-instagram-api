program Delphi_Instagram_API;

uses
  System.StartUpCopy,
  FMX.Forms,
  uAccessToken in 'src\uAccessToken.pas',
  uEndpointMedia in 'src\uEndpointMedia.pas',
  uEndpointOAuth in 'src\uEndpointOAuth.pas',
  uEndpoints in 'src\uEndpoints.pas',
  uEndpointTags in 'src\uEndpointTags.pas',
  uEndpointUsers in 'src\uEndpointUsers.pas',
  uInstagramEndpoints in 'src\uInstagramEndpoints.pas',
  uRESTComponents in 'src\uRESTComponents.pas',
  uScopeRequeriment in 'src\uScopeRequeriment.pas',
  uWebBrowserOAuth in 'src\uWebBrowserOAuth.pas' {frmWebBrowserOAuth},
  uMain in 'example\uMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
