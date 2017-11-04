unit uAccessToken;

interface

type
  TAccessToken = class
  private
    FDateExpiration: TDateTime;
    FValue: String;
    procedure SetDateExpiration(const Value: TDateTime);
    procedure SetValue(const Value: String);

  public
    property Value: String read FValue write SetValue;
    property DateExpiration: TDateTime read FDateExpiration write SetDateExpiration;


  end;

implementation

{ TAccessToken }

procedure TAccessToken.SetDateExpiration(const Value: TDateTime);
begin
  FDateExpiration := Value;
end;

procedure TAccessToken.SetValue(const Value: String);
begin
  FValue := Value;
end;

end.
