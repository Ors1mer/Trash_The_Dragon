unit painter;
{$mode OBJFPC} { Allows creating optional arguments }
interface

procedure paint(x, y: integer; data: string);
procedure paint_image();
procedure paint_dragon(x, y, direction: integer; hide: boolean = false);
procedure paint_wave(x, y, d, wave: integer);
procedure paint_bishop(x, y, direction: integer; hide: boolean = false);

implementation
uses crt, constants, colorscheme, SysUtils;

procedure paint(x, y: integer; data: string);
begin
    GotoXY(x, y);
    write(data);
end;

{ --- Menu --- }
procedure paint_image();
const
    title = '<><><> Trash The Dragon <><><>';
var
    linenum: integer;
    linechars, filepath: string;
    source: text;
begin
    {$IFDEF INSTALL}
    filepath := GetEnvironmentVariable('HOME')+'/.config/ttd/dragon_pic.asc';
    {$ELSE}
    filepath := 'data/dragon_pic.asc';
    {$ENDIF}
    assign(source, filepath);
    reset(source);
    TextBackground(TitleBg); TextColor(ButtonCol);
    paint((75 div 2), 1, title);
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
        Up, Down, ViUp, ViDown, ArrUp, ArrDown:
            paint_Y(x, y, direction, parts);
        Right, Left, ViRight, ViLeft, ArrRight, ArrLeft:
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
    if (d = Down) or (d = ViDown) or (d = ArrDown) then
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
    if (d = Left) or (d = ViLeft) or (d = ArrLeft) then
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

procedure paint_wave_Y(x, y, w: integer; hide: boolean = false); forward;
procedure paint_wave_X(x, y, w: integer; hide: boolean = false); forward;
procedure paint_wave(x, y, d, wave: integer);
const
    DelayDuration = 100;
    FrontSizeY = 4;
    FrontSizeX = 6;
var
    hide: boolean = true;
begin
    case d of
        Up, ViUp, ArrUp: begin
            paint_wave_Y(x, y-FrontSizeY-wave, wave);
            delay(DelayDuration);
            paint_wave_Y(x, y-FrontSizeY-wave, wave, hide);
        end;
        Down, ViDown, ArrDown: begin
            paint_wave_Y(x, y+FrontSizeY+wave, wave);
            delay(DelayDuration);
            paint_wave_Y(x, y+FrontSizeY+wave, wave, hide);
        end;
        Right, ViRight, ArrRight: begin
            paint_wave_X(x+FrontSizeX+wave, y, wave);
            delay(DelayDuration);
            paint_wave_X(x+FrontSizeX+wave, y, wave, hide);
        end;
        Left, ViLeft, ArrLeft: begin
            paint_wave_X(x-FrontSizeX-wave, y, wave);
            delay(DelayDuration);
            paint_wave_X(x-FrontSizeX-wave, y, wave, hide);
        end;
    end
end;

procedure random_flame_col();
begin
    if random(2) = 1 then
        TextColor(FlameCol1)
    else
        TextColor(FlameCol2)
end;

procedure paint_wave_Y(x, y, w: integer; hide: boolean = false);
var
    fl: char = '*';
    i: integer;
begin
    if (y > 0) and (y < ScreenHeight) then begin
        for i := -w to w do begin
            if hide then begin
                paint(x+i, y, ' ');
                continue
            end;
            if random(2) = 1 then begin
                random_flame_col();
                paint(x+i, y, fl)
            end;
    end;
    end
end;

procedure paint_wave_X(x, y, w: integer; hide: boolean = false);
var
    fl: char = '*';
    i: integer;
begin
    if (x > 0) and (x < ScreenWidth) then begin
        for i := -w to w do begin
            if hide then begin
                paint(x, y+i, ' ');
                continue
            end;
            if random(2) = 1 then begin
                random_flame_col();
                paint(x, y+i, fl);
            end;
        end;
    end
end;

{ --- Bishop --- }
type
    BishopParts = array[1..9] of char;

procedure paint_bishop_body(x, y: integer; part: char); forward;
procedure paint_bishop_cloak(x, y, s: integer; parts: BishopParts); forward;
procedure paint_bishop(x, y, direction: integer; hide: boolean = false);
var
    parts: BishopParts = ('*', '0', '_', ')', '\', '/', '-', '&', '^');
    s: integer = 1; { sign }
    i: integer;
begin
    if direction = Right then
        s := -s;
    if hide then begin { Change all to spaces }
        for i := 1 to 9 do
            parts[i] := ' ';
    end;
    paint_bishop_body(x, y, parts[1]);
    paint_bishop_cloak(x, y, s, parts);
    { Eyes & Knife }
    TextColor(BishopEyeCol or Blink);
    paint(x-2*s, y-1, parts[2]);
    paint(x-s, y-1, parts[2]);
    TextColor(KnifeCol1);
    paint(x-2*s, y+1, parts[8]);
    TextColor(KnifeCol2);
    paint(x-3*s, y+1, parts[7]);
    TextColor(DefaultCol);
end;

procedure paint_bishop_body(x, y: integer; part: char);
begin
    TextColor(BishopBodyCol);
    paint(x, y-1, part);
    paint(x-1, y, part+part+part);
    paint(x-1, y+1, part+part+part);
    paint(x-1, y+2, part);
    paint(x+1, y+2, part);
end;

procedure paint_bishop_cloak(x, y, s: integer; parts: BishopParts);
begin
    TextColor(CloakCol);
    paint(x-2*s, y-2, parts[3]);
    paint(x-s, y-2, parts[3]);
    paint(x+s, y-1, parts[4]);
    paint(x+2*s, y, parts[5]);
    paint(x+2*s, y+1, parts[5]);
    paint(x-2*s, y+2, parts[6]);
    paint(x, y+2, parts[9]);
    paint(x+2*s, y+2, parts[6]);
end;

end.
