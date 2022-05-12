unit painter;
{$mode OBJFPC} { Allows creating optional arguments }
interface

procedure paint(x, y: integer; data: string);
procedure paint_image();
procedure paint_dragon(x, y, direction: integer; hide: boolean = false);

implementation
uses crt, constants, colorscheme;

procedure paint(x, y: integer; data: string);
begin
    GotoXY(x, y);
    write(data);
end;

{ --- Menu --- }
procedure paint_image();
const
    title = '<><><> Trash The Dragon <><><>';
    filepath = 'data/dragon_pic.asc';
var
    linenum: integer;
    linechars: string;
    source: text;
begin
    assign(source, filepath);
    reset(source);
    TextBackground(TitleBg); TextColor(ButtonCol);
    paint(75 div 2, 1, title);
    TextBackground(DefaultBg); TextColor(ImageCol);
    for linenum := 2 to 31 do begin
        readln(source, linechars);
        paint(1, linenum, linechars);
        delay(20)
    end;
    TextBackground(DefaultBg); TextColor(DefaultCol);
    close(source)
end;

{ --- Dragon --- }
type
    DragonParts = array[1..6] of char;

procedure paint_X(var x, y, d: integer; parts: DragonParts); forward;
procedure paint_Y(var x, y, d: integer; parts: DragonParts); forward;
procedure paint_dragon(x, y, direction: integer; hide: boolean = false);
var
    { These elements are the following: skin, wing, eye, leg, paw, mouth }
    parts: DragonParts = ('0', '*', '@', '_', '"', '=');
    i: integer;
begin
    if hide then begin { Change all to spaces }
        for i := 1 to 6 do
            parts[i] := ' ';
    end;
    case direction of
        Up, Down:
            paint_Y(x, y, direction, parts);
        Right, Left:
            paint_X(x, y, direction, parts);
    end;
    TextColor(DefaultCol);
    GotoXY(1, ScreenHeight)
end;

procedure paint_body_Y(var x, y, s: integer; skin, wing, mouth: char); forward;
procedure paint_wings_Y(var x, y, s: integer; wing: char); forward;
procedure paint_legs_Y(var x, y, s: integer; leg, paw: char); forward;
procedure paint_Y(var x, y, d: integer; parts: DragonParts);
var
    { Up & Down are symetric images, s defines the direction to paint }
    s: integer = 1; 
begin
    if d = Down then
        s := -1;
    TextColor(EyeCol);
    paint(x-1, y-(s*3), parts[3]+' '+parts[3]);
    paint_body_Y(x, y, s, parts[1], parts[2], parts[6]);
    paint_wings_Y(x, y, s, parts[2]);
    paint_legs_Y(x, y, s, parts[4], parts[5]);
end;

procedure paint_body_Y(var x, y, s: integer; skin, wing, mouth: char);
begin
    TextColor(BodyCol);
    paint(x, y-(s*3), wing);
    paint(x, y-(s*4), mouth);
    paint(x, y+(s*5), skin+skin);
    paint(x-1, y+(s*4), skin);
    paint(x, y+(s*3), skin);
    paint(x-1, y+(s*2), skin+skin+skin);
    paint(x-1, y+s, skin+skin+skin);
    paint(x-2, y, skin+skin+skin+skin+skin);
    paint(x, y-s, skin);
    paint(x-1, y-(s*2), skin+skin+skin)
end;

procedure paint_wings_Y(var x, y, s: integer; wing: char);
begin
    TextColor(WingCol);
    paint(x-4, y+s, wing+wing);
    paint(x+3, y+s, wing+wing);
    paint(x-3, y, wing);
    paint(x+3, y, wing);
end;

procedure paint_legs_Y(var x, y, s: integer; leg, paw: char);
begin
    TextColor(LegCol);
    paint(x-2, y+(s*2), leg);
    paint(x+2, y+(s*2), leg);
    paint(x-2, y+s, paw);
    paint(x+2, y+s, paw);
    paint(x-1, y-s, leg);
    paint(x+1, y-s, leg);
    paint(x-2, y-(s*2), paw);
    paint(x+2, y-(s*2), paw);
end;

procedure paint_body_X(var x, y, s: integer; skin, wing, mouth: char); forward;
procedure paint_wings_X(var x, y, s: integer; wing: char); forward;
procedure paint_legs_X(var x, y, s: integer; leg, paw: char); forward;
procedure paint_X(var x, y, d: integer; parts: DragonParts);
var
    { Right & Left are symetric images, s defines the direction to paint }
    s: integer = 1; 
begin
    if d = Left then
        s := -1;
    TextColor(EyeCol);
    paint(x+(s*5), y+1, parts[3]);
    paint(x+(s*5), y-1, parts[3]);
    paint_body_X(x, y, s, parts[1], parts[2], parts[6]);
    paint_wings_X(x, y, s, parts[2]);
    paint_legs_X(x, y, s, parts[4], parts[5]);
end;

procedure paint_body_X(var x, y, s: integer; skin, wing, mouth: char);
begin
    TextColor(BodyCol);
    paint(x+(s*5), y, wing);
    paint(x+(s*6), y, mouth);
    paint(x-(s*6), y, skin);
    paint(x-(s*5), y, skin);
    paint(x-(s*4), y, ' ');
    paint(x-(s*3), y, skin);
    paint(x-(s*2), y, skin);
    paint(x-s, y, skin);
    paint(x, y, skin);
    paint(x+s, y, skin);
    paint(x+(s*2), y, skin);
    paint(x+(s*3), y, skin);
    paint(x+(s*4), y, skin);
    paint(x, y-1, skin);
    paint(x, y+1, skin);
    paint(x-(s*4), y+1, skin)
end;

procedure paint_wings_X(var x, y, s: integer; wing: char);
begin
    TextColor(WingCol);
    paint(x-s, y+3, wing);
    paint(x-s, y-3, wing);
    paint(x, y+2, wing);
    paint(x, y-2, wing);
    paint(x+s, y+1, wing);
    paint(x+s, y-1, wing);
end;

procedure paint_legs_X(var x, y, s: integer; leg, paw: char);
begin
    TextColor(LegCol);
    paint(x-(s*2), y+1, leg);
    paint(x-s, y+1, paw);
    paint(x-(s*2), y-1, leg);
    paint(x-s, y-1, paw);
    paint(x+(s*2), y+1, leg);
    paint(x+(s*2), y-1, leg);
end;

{ --- Bishop ---}

end.
