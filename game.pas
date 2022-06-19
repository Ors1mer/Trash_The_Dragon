program Trash_Game; { game.pas }
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

{ --- MENU --- }

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

{ --- PLAY --- }

const
    BiAmount = 9;
type
    Bishop = record
        state: integer; { <1 - dead, 1 - alive }
        dir: integer;
        x: integer;
        y: integer;
    end;
    Bishops = array[1..BiAmount] of Bishop;

function is_move(key: integer): boolean; forward;
procedure spawn_bishops(var Niners: Bishops); forward;
procedure step(var key, direction, x, y: integer); forward;
procedure flamethrower(x, y, d: integer; var Niners: Bishops); forward;
procedure Play(Center: point);
var
    Trash: point; { Dragon's location }
    direction: integer = Down;
    Niners: Bishops;
    key: integer;
begin
    clrscr;
    paint(1, 1, 'Press Esc to die');
    Niners[1].x := -1;
    Trash.x := 3*(ScreenWidth div 8);
    Trash.y := 3*(ScreenHeight div 8);
    paint_dragon(Trash.x, Trash.y, direction);
    spawn_bishops(Niners);
    repeat
        GetKey(key);
        spawn_bishops(Niners);
        if key = Space then
            flamethrower(Trash.x, Trash.y, direction, Niners)
        else if is_move(key) then
            step(key, direction, Trash.x, Trash.y);
    until (key = Esc);
    clrscr;
    Menu(Center)
end;

function is_move(key: integer): boolean;
begin
    is_move := (key=Up) or (key=Down) or (key=Left) or (key=Right);
end;

procedure get_default_bishops(var Niners: Bishops); forward;
procedure spawn_bishops(var Niners: Bishops);
var
    n: integer;
    dir: array[1..2] of integer = (Left, Right);
    hide: boolean = true;
    alive: integer = 1;
begin
    if Niners[1].x = -1 then {bishops weren't printed yet}
        get_default_bishops(Niners);

    for n := 1 to BiAmount do begin
        if Niners[n].state = alive then begin
            paint_bishop(Niners[n].x, Niners[n].y, Niners[n].dir, hide);
            Niners[n].dir := dir[random(3)];
            paint_bishop(Niners[n].x, Niners[n].y, Niners[n].dir);
        end;
    end;
    GotoXY(1, ScreenHeight)
end;

procedure get_default_bishops(var Niners: Bishops);
var
    n, x, y, kx, ky: integer;
    alive: integer = 1;
begin
    x := ScreenWidth div 4;
    y := ScreenHeight div 4;
    n := 1; {bishop's number}
    for ky := 1 to 3 do begin
        for kx := 1 to 3 do begin
            Niners[n].x := kx*x;
            Niners[n].y := ky*y;
            Niners[n].state := alive;
            n := n + 1;
        end;
    end;
end;

procedure aim_bi_origin(a, a1, b, b1, w: integer; var Bi: Bishop); forward;
procedure hit_bishop(x, y, d, wave: integer; var Nrs: Bishops);
var
    DrFrontSizeY: integer = 4;
    DrFrontSizeX: integer = 6;
    n: integer;
begin
    case d of
        Up:    y := y - wave - DrFrontSizeY;
        Down:  y := y + wave + DrFrontSizeY;
        Left:  x := x - wave - DrFrontSizeX;
        Right: x := x + wave + DrFrontSizeX;
    end;
    for n := 1 to BiAmount do begin
        case d of
            Up, Down:
                aim_bi_origin(x, Nrs[n].x, y, Nrs[n].y, wave, Nrs[n]);
            Left, Right:
                aim_bi_origin(y, Nrs[n].y, x, Nrs[n].x, wave, Nrs[n]);
        end;
    end;
end;

procedure aim_bi_origin(a, a1, b, b1, w: integer; var Bi: Bishop);
var
    i: integer;
    hide: boolean = true;
begin
    if b = b1 then begin
        for i := a-w to a+w do begin
            if i = a1 then begin
                Bi.state := Bi.state - 1;
                paint_bishop(Bi.x, Bi.y, Bi.dir, hide);
                break;
            end;
        end;
    end;
end;

procedure flamethrower(x, y, d: integer; var Niners: Bishops);
var
    SentenceLen: integer = 13;
    w: integer;
begin
    paint(1, 2, 'Flamethrowing');
    for w := 1 to 3 do begin
        paint(SentenceLen+w, 2, '.');
        paint_wave(x, y, d, w);
        hit_bishop(x, y, d, w, Niners);
    end;
    paint(1, 2, '                ');
    GotoXY(1, ScreenHeight);
    TextColor(DefaultCol);
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
end;

{ --- INFO --- }

procedure Info(Center: point);
var
    key: integer;
    dragon_txt, bishop_txt, msg: string;
begin
    dragon_txt := 'This is Trash, a dragon.'#10 +
    'He knows how to fire-breathe.'#10;
    bishop_txt := 'This is one of the nine bishops.'#10 +
    'These are their names:'#10'Andre, Nico, Keons,'#10'Savarver, ' +
    'Lisden, Reisdro,'#10'Nills, Vetomo, Listo.'#10 +
    'They wear a red cloak with a hood.'#10'And carry knifes.'#10;
    msg := 'You are flamethrower, they''re - switchblades.'#10;

    clrscr;
    paint(0, 1, dragon_txt);
    paint_dragon(15, WhereY+6, Down);
    paint(0, 15, bishop_txt);
    paint_bishop(16, WhereY+3, Left);
    paint(1, 29, msg);
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
    randomize;
    clrscr;

    Menu(ScreenCenter);
end.
