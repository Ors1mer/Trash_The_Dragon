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
    wing: char = '*';
    eye: char = '@';
    leg: char = '_';
    paw: char = '"';
    mouth: char = '=';
begin
    if hide then begin
        filler := ' ';
        wing := ' ';
        eye := ' ';
        leg := ' ';
        paw := ' ';
        mouth := ' ';
    end;
    { Body }
    TextColor(LightCyan);
    GotoXY(x, y-5); write(filler + filler);
    GotoXY(x-1, y-4); write(filler);
    GotoXY(x, y-3); write(filler);
    GotoXY(x-1, y-2); write(filler + filler + filler);
    GotoXY(x-1, y-1); write(filler + filler + filler);
    GotoXY(x-2, y); write(filler + filler + filler + filler + filler);
    GotoXY(x, y+1); write(filler);
    GotoXY(x-1, y+2); write(filler + filler + filler);
    { Wings }
    TextColor(White);
    GotoXY(x-4, y-1); write(wing + wing);
    GotoXY(x+3, y-1); write(wing + wing);
    GotoXY(x-3, y); write(wing);
    GotoXY(x+3, y); write(wing);
    { Legs }
    TextColor(LightGray);
    GotoXY(x-2, y-2); write(leg);
    GotoXY(x+2, y-2); write(leg);
    GotoXY(x-2, y-1); write(paw);
    GotoXY(x+2, y-1); write(paw);
    GotoXY(x-1, y+1); write(leg);
    GotoXY(x+1, y+1); write(leg);
    GotoXY(x-2, y+2); write(paw);
    GotoXY(x+2, y+2); write(paw);
    { Head }
    TextColor(LightRed);
    GotoXY(x-1, y+3); write(eye + ' ' + eye);
    TextColor(LightCyan);
    GotoXY(x, y+3); write(wing);
    GotoXY(x, y+4); write(mouth);
    TextColor(LightGray);
end;

procedure Menu();
begin

end;

procedure Game();
begin
    
end;


type
    point = record
        x: integer;
        y: integer;
    end;
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
    Center.x := ScreenWidth div 2;
    Center.y := ScreenHeight div 2;
    clrscr;

    { Paint the dragon at center }
    Trash := Center;
    paint_dragon(Trash.x, Trash.y);

    GotoXY(1, ScreenHeight);
    write('Press Esc to exit...');
    repeat
        GetKey(key);
    until (key = Esc);
    writeln;
end.
