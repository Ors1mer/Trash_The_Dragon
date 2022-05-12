program Trash_Game; {program.pas}
uses crt, constants, colorscheme, painter;

type
    point = record
        x: integer;
        y: integer;
    end;
    button = record
        name: string;
        loc: integer;
    end;

procedure GetKey(var code: integer); { Keypress handler }
var
    c: char;
begin
    c := ReadKey;
    if c = #0 then begin { extended key }
        c := ReadKey;
        code := -ord(c)
    end else begin       { regular key }
        code := ord(c)
    end
end;

procedure Play(Center: point); forward;
procedure Info(Center: point); forward;
procedure paint_buttons(sel_b, pl_b, in_b, ex_b: button); forward;
procedure move_menu_cursor(key: integer; var sel_b, pl_b, in_b, ex_b: button);
forward;

procedure Menu(Center: point);
var
    key: integer;
    play_b, info_b, exit_b, selected_b: button;
begin
    play_b.name := '   ~PLAY~   '; play_b.loc := 33;
    info_b.name := '   ?INFO?   '; info_b.loc := 34;
    exit_b.name := '   *EXIT*   '; exit_b.loc := 35;
    selected_b := play_b;
    paint_image();
    { Let user choose a button }
    repeat
        paint_buttons(selected_b, play_b, info_b, exit_b);
        GetKey(key);
        move_menu_cursor(key, selected_b, play_b, info_b, exit_b);
    until ((key = Enter) or (key = Esc));
    if key = Enter then begin
        if selected_b.loc = play_b.loc then
            Play(Center)
        else if selected_b.loc = info_b.loc then
            Info(Center)
    end;
    write(#10#10'Goodbye!'#10);
    halt(0)
end;

procedure paint_buttons(sel_b, pl_b, in_b, ex_b: button);
begin
    paint((103 - 8) div 2, pl_b.loc, pl_b.name);
    paint((103 - 8) div 2, in_b.loc, in_b.name);
    paint((103 - 8) div 2, ex_b.loc, ex_b.name);
    GotoXY((103 - 8) div 2, sel_b.loc);
    TextBackground(ButtonBg); TextColor(ButtonCol);
    write(sel_b.name);
    GotoXY((103 - 8) div 2, WhereY);
    TextBackground(DefaultBg); TextColor(DefaultCol);
end;

procedure move_menu_cursor(key: integer; var sel_b, pl_b, in_b, ex_b: button);
var
    y_min, y_max: integer;
begin
    y_min := pl_b.loc;
    y_max := ex_b.loc;
    case key of
        Up:
            if sel_b.loc > y_min then begin
                if sel_b.loc = ex_b.loc then
                    sel_b := in_b
                else
                    sel_b := pl_b;
                GotoXY(WhereX, sel_b.loc);
            end;
        Down:
            if sel_b.loc < y_max then begin
                if sel_b.loc = pl_b.loc then
                    sel_b := in_b
                else
                    sel_b := ex_b;
                GotoXY(WhereX, sel_b.loc);
            end;
    end;
end;

procedure flamethrower(x, y, direction: integer); forward;
procedure step(var key, direction, x, y: integer); forward;

procedure Play(Center: point);
var
    Trash: point; { Dragon's location }
    key: integer;
    direction: integer = Up;
begin
    clrscr;
    paint(1, 1, 'Press Esc to die');
    { Paint the dragon at center }
    Trash := Center;
    paint_dragon(Trash.x, Trash.y, direction);
    repeat
        GetKey(key);
        if key = Space then
            flamethrower(Trash.x, Trash.y, direction)
        else if (key = Up) or (key = Down) or (key = Right) or (key = Left) then
            step(key, direction, Trash.x, Trash.y);
        GotoXY(1, ScreenHeight);
    until (key = Esc);
    clrscr;
    Menu(Center)
end;

procedure flamethrower(x, y, direction: integer);
const
    delayDuration = 100;
begin
    paint(1, 2, 'Flamethrowing');
    delay(delayDuration);
    paint(14, 2, '.');
    delay(delayDuration);
    paint(15, 2, '.');
    delay(delayDuration);
    paint(16, 2, '.');
    delay(delayDuration);
    paint(1, 2, '                ');
end;

procedure step(var key, direction, x, y: integer);
var
    hide: boolean = true;
begin
    paint_dragon(x, y, direction, hide);
    direction := key;
    case direction of
        Up:
            if y > 5 then
                y := y - 1;
        Down:
            if y < ScreenHeight - 4 then
                y := y + 1;
        Right:
            if x < ScreenWidth - 7 then
                x := x + 2;
        Left:
            if x > 7 then
                x := x - 2;
    end;
    paint_dragon(x, y, direction);
    GotoXY(3, ScreenHeight); write(x); write(', '); write(y); write(' ');
end;

procedure Info(Center: point);
var
    key: integer;
begin
    clrscr;
    write('Iriska');
    repeat
        GetKey(key);
    until ((key = Esc) or (key = Enter));
    clrscr;
    Menu(Center);
end;

var
    ScreenCenter: point;
begin
    ScreenCenter.x := ScreenWidth div 2;
    ScreenCenter.y := ScreenHeight div 2;
    clrscr;

    Menu(ScreenCenter);
end.
