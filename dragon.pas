unit dragon;
{$mode OBJFPC} { Used to create optional function arguments }
interface

procedure paint_dragon(x, y: integer; hide: boolean = false);

implementation
uses crt;

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

end.
