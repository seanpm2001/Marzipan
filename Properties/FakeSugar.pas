﻿namespace RemObjects.CodeGen4;

interface

{$IF ECHOES}
type
  Sugar.Dummy = class;
  Sugar.IO.Dummy = class;
  Sugar.Collections.Dummy = class;
  Sugar.Linq.Dummy = class;

  // These classes exist so that on .NET, CodeGen4 can be build w/o dependency on Sugar, by adding
  // "System.Collections.Generic,System.IO,System.Linq,System.Text" to the project's default uses.

  Sugar.Convert = public static class
  public
    method ToHexString(aValue: Int64; aWidth: Integer := 0): String;
    method ToString(aValue: Byte; aBase: Integer := 10): String;
    method ToString(aValue: Int32; aBase: Integer := 10): String;
    method ToString(aValue: Int64; aBase: Integer := 10): String;
  end;

extension method System.String.EqualsIgnoreCase(Value: String): Boolean;assembly;
extension method System.Xml.XmlNode.ChildCount: Integer;assembly;
{$ENDIF}

implementation

{$IF ECHOES}
extension method System.Xml.XmlNode.ChildCount: Integer;
begin
  exit self.ChildNodes:Count;
end;

extension method System.String.EqualsIgnoreCase(Value: String): Boolean;
begin
  exit String.Equals(Self, Value, StringComparison.OrdinalIgnoreCase);
end;

method Sugar.Convert.ToHexString(aValue: Int64; aWidth: Integer): String;
begin
  if aWidth mod 2 ≠ 0 then aWidth := aWidth+1;
  result := aValue.ToString('x'+aWidth.ToString);
end;

method Sugar.Convert.ToString(aValue: Byte; aBase: Integer := 10): String;
begin
  result := System.Convert.ToString(aValue, aBase);
end;

method Sugar.Convert.ToString(aValue: Int32; aBase: Integer := 10): String;
begin
  result := System.Convert.ToString(aValue, aBase);
end;

method Sugar.Convert.ToString(aValue: Int64; aBase: Integer := 10): String;
begin
  result := System.Convert.ToString(aValue, aBase);
end;
{$ENDIF}

end.
