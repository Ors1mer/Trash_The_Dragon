program Trash_Game; {trash.pas}
{$mode OBJFPC} { Used to create optional arguments }
uses crt;

procedure GetKey(var code: integer);
var
    c: char;
begin
    c := ReadKey;
    if c = #0 then begin { extended key }
        c := ReadKey;
        code := -ord(c)
    end
    else begin           { regular key }
        code := ord(c)
    end
end;

procedure paint_dragon(x, y: integer; hide: boolean = false);
var
    filler: char = '0';
    wing: char = '-';
begin
    if hide then begin
        filler := ' ';
        wing := ' '
    end;
    { Tail }
    TextColor(LightCyan);
    GotoXY(x-1, y-2);
    write(filler);
    GotoXY(x, y-1);
    write(filler);
    { Body }
    GotoXY(x-2, y);
    write(wing + filler);
    TextColor(White);
    write(filler);
    TextColor(LightCyan);
    write(filler + wing);
    { Neck & Head }
    GotoXY(x-1, y+1);
    TextColor(LightCyan);
    write(filler);
    TextColor(White);
    write(filler);
    TextColor(LightCyan);
    write(filler);
    GotoXY(x, y+2);
    write(filler);
end;

type
    point = array [1..2] of integer; {(x, y)}
const
    { Key codes }
    Esc = 27;
    Space = 32;
    Up = 119;
    Down = 115;
    Left = 97;
    Right = 100;
var
    Center: point;
    Trash: point; { Dragon's location }
    hide: boolean = true;
    key: integer;
begin
    Center[1] := ScreenWidth div 2;
    Center[2] := ScreenHeight div 2;
    clrscr;

    { Paint the dragon at center }
    Trash := Center;
    paint_dragon(Trash[1], Trash[2]);

    GotoXY(1, ScreenHeight);
    write('Press Esc to exit...');
    repeat
        GetKey(key);
    until (key = Esc);
    writeln;
end.
