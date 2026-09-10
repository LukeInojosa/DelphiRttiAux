unit Interfaces.Generic;

interface

uses
  System.Generics.Collections, System.Rtti;

type
  IGeneric = interface
    ['{14F449D4-36CC-439A-8971-E9595A6432A9}']
    function SetValues(PropNames: String; Values: TArray<String>): Boolean; overload;
    function SetValues(PropNames: TArray<String>; Values: TArray<String>): Boolean; overload;
    function SetValues(jsonString: String): Boolean; overload;
    function ToString: String;

    function getPropIsFilled: TDictionary<String,Boolean>;
    procedure UnFill(propName: String);
    procedure UnFillAll;

    function Tryget(propName: String; out Value: TValue): Boolean;
    function TrySet(propName: String; Value: TValue): Boolean;
    property isFilled: TDictionary<String,Boolean> read getPropIsFilled;
  end;

implementation
end.
