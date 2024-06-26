{
  Boost RACE's Starting values by race SIZE.
  Modifies SIZE of races matching to a list of keyword/value.
  By Rasta

  Sizes:
    Small: 0
    Medium: 1
    Large: 2
    Extra large: 3
}

unit DLS_Boost_RACE;

uses mteFunctions, classes, sysutils;

var
  SizeMap: TStringList;

function Initialize: Integer;
begin
  SizeMap := TStringList.Create;
  SizeMap.Values['Giant'] := '3';
  SizeMap.Values['Large'] := '2';
  SizeMap.Values['Bear'] := '2';
  SizeMap.Values['Lion'] := '2';
  SizeMap.Values['Troll'] := '2';
  SizeMap.Values['Reaper'] := '2';
  SizeMap.Values['Matron'] := '2';
  SizeMap.Values['SabreCat'] := '2';
  SizeMap.Values['Werewolf'] := '2';
  SizeMap.Values['Minotaur'] := '2';
  SizeMap.Values['Gargoyle'] := '2';
  SizeMap.Values['Spriggan'] := '2';
  SizeMap.Values['EarthMother'] := '2';
  SizeMap.Values['ChaurusHunter'] := '2';
  SizeMap.Values['Fox'] := '0';
  SizeMap.Values['Rat'] := '0';
  SizeMap.Values['Hare'] := '0';
  SizeMap.Values['Wisp'] := '0';
  SizeMap.Values['Child'] := '0';
  SizeMap.Values['Wraith'] := '0';
  SizeMap.Values['Chicken'] := '0';
  SizeMap.Values['Slaughterfish'] := '0';

  Result := 0;
end;

function FindNewSize(const EDID: string): Integer;
var
  i: Integer;
  keyword: string;
begin
  Result := -1; // Default to -1 indicating no change if not found
  for i := 0 to SizeMap.Count - 1 do
  begin
    keyword := SizeMap.Names[i];
    if Pos(keyword, EDID) > 0 then
    begin
      Result := StrToInt(SizeMap.ValueFromIndex[i]);
      Break;
    end;
  end;
end;

function Process(e: IInterface): integer;
var
  size, health, stam, mgk, boost, newSize: integer;
  EDID: string;
begin
  Result := 0;

  if Signature(e) <> 'RACE' then Exit;

  EDID := EditorID(e);
  newSize := FindNewSize(EDID);

  if newSize >= 0 then begin
    SetElementNativeValues(e, 'DATA - DATA\Size', newSize);
    AddMessage('Size changed to ' + IntToStr(newSize) + ' for: ' + EDID);
  end;

  size := IfThen(newSize >= 0, newSize, GetElementNativeValues(e, 'DATA - DATA\Size'));
  health := GetElementNativeValues(e, 'DATA\Starting Health');
  stam := GetElementNativeValues(e, 'DATA\Starting Stamina');
  mgk := GetElementNativeValues(e, 'DATA\Starting Magicka');

  case size of
    1: boost := ((health + stam + mgk) div 4);
    2: boost := ((health + stam + mgk) div 3);
    3: boost := ((health + stam + mgk) div 2);
  end;

  // AddMessage('Applying Boost to: ' + EDID);
  SetElementNativeValues(e, 'DATA\Starting Health', health + boost);
  SetElementNativeValues(e, 'DATA\Starting Stamina', stam + boost);
  SetElementNativeValues(e, 'DATA\Starting Magicka', mgk + boost);
end;

function Finalize: Integer;
begin
  SizeMap.Free;
  Result := 0;
end;

end.