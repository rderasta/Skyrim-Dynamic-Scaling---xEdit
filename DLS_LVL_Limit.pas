{
  Checks for Level Multiplier (Level Mult) in NPC records and caps it if it exceeds a specified limit.
  Skyrim Scaled Uncapped - By Rasta
}
unit DLS_LVL_Limit;

uses mteFunctions;

function ProcessLimits(e: IInterface): integer;
var
  iCheckMult, iLimit: integer;
begin
  Result := 0;

  // Process only NPC records
  if Signature(e) = 'NPC_' then begin
    // Optionally, set minimum and maximum levels. Uncomment to enable.
    // SetElementNativeValues(e, 'ACBS\Calc min level', 1);
    // SetElementNativeValues(e, 'ACBS\Calc max level', 500);

    // Define the maximum allowed multiplier as 2.5 (2500 in terms of game's internal storage, which multiplies actual value by 1000)
    iLimit := 2500;
    iCheckMult := GetElementNativeValues(e, 'ACBS\Level Mult');

    // Cap the Level Mult value if it exceeds the defined limit
    if iCheckMult > iLimit then
      SetElementNativeValues(e, 'ACBS\Level Mult', iLimit);
  end;
end;

function Finalize: integer;
begin
  Result := 1; // Standard practice for a cleanup function to return 1
end;

end. // end script