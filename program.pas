program Trash_Game; {program.pas}
uses
    crt, dragon;

procedure GetKey(var code: integer); { Keypress handler }
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

type
    point = record
        x: integer;
        y: integer;
    end;
    button = record
        name: string;
        loc: integer;
    end;
const
    { Key codes }
    Enter = 13;
    Esc = 27;
    Space = 32;
    Up = -72;
    Down = -80;
    Left = -75;
    Right = -77;

procedure Play(Center: point);
var
    Trash: point; { Dragon's location }
    hide: boolean = true;
begin
    clrscr;
    { Paint the dragon at center }
    Trash := Center;
    paint_dragon(Trash.x, Trash.y);
    Delay(2000);
    paint_dragon(Trash.x, Trash.y, hide);
end;

procedure Info(Center: point);
var
    key: integer;
begin
    clrscr;
    write('Iriska');
    repeat
        GetKey(key);
    until (key = Esc);
end;

procedure paint_buttons(sel_b, pl_b, in_b, ex_b: button);
begin
    GotoXY((103 - 8) div 2, pl_b.loc); write(pl_b.name + #10);
    GotoXY((103 - 8) div 2, in_b.loc); write(in_b.name);
    GotoXY((103 - 8) div 2, ex_b.loc); write(ex_b.name);
    GotoXY((103 - 8) div 2, sel_b.loc);
    TextBackground(Cyan); TextColor(Black);
    write(sel_b.name);
    GotoXY((103 - 8) div 2, WhereY);
    TextBackground(Black); TextColor(LightGray);
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
    until (key = Enter);
    { instruction 'case of' doesn't work in this situation }
    { because of 'constant expression required' }
    if selected_b.loc = play_b.loc then
        Play(Center);
    if selected_b.loc = info_b.loc then
        Info(Center);
    if selected_b.loc = exit_b.loc then begin
        write(#10#10'Goodbye!'#10);
        halt(0)
    end;
end;

var
    ScreenCenter: point;
begin
    ScreenCenter.x := ScreenWidth div 2;
    ScreenCenter.y := ScreenHeight div 2;
    clrscr;

    Menu(ScreenCenter);
end.
