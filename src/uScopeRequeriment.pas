unit uScopeRequeriment;

interface

type
  TScopeRequeriment = class
  private
    Frequeried: boolean;
    FAsString: string;
    procedure Setrequeried(const Value: boolean);
    procedure SetAsString(const Value: string);

  public
    property requeried: boolean read Frequeried write Setrequeried;
    property AsString: string read FAsString write SetAsString;
  end;

implementation

{ TScopeRequeriment }

procedure TScopeRequeriment.SetAsString(const Value: string);
begin
  FAsString := Value;
end;

procedure TScopeRequeriment.Setrequeried(const Value: boolean);
begin
  Frequeried := Value;
end;

end.
