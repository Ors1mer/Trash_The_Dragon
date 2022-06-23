program Trash_Game; { game.pas }
uses crt, constants, colorscheme, painter;

type
    point = record
        x: integer;
        y: integer
    end;
    button = record
        name: string;
        loc: integer
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
    play_b.name := '    ~PLAY~   '; play_b.loc := 33;
    info_b.name := '    ?INFO?   '; info_b.loc := 34;
    exit_b.name := '    *EXIT*   '; exit_b.loc := 35;
    selected_b := play_b;
    paint_image();
    { Let user choose button }
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
var
    x_loc: integer = (102 - 8) div 2;
begin
    paint(x_loc, pl_b.loc, pl_b.name);
    paint(x_loc, in_b.loc, in_b.name);
    paint(x_loc, ex_b.loc, ex_b.name);
    GotoXY(x_loc, sel_b.loc);
    TextBackground(ButtonBg); TextColor(ButtonCol);
    write(sel_b.name);
    GotoXY(x_loc, WhereY);
    TextBackground(DefaultBg); TextColor(DefaultCol)
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
                GotoXY(WhereX, sel_b.loc)
            end;
        Down:
            if sel_b.loc < y_max then begin
                if sel_b.loc = pl_b.loc then
                    sel_b := in_b
                else
                    sel_b := ex_b;
                GotoXY(WhereX, sel_b.loc)
            end
    end
end;

{ --- PLAY --- }

const
    BiAmount = 9;
    BiNames: array[1..9] of string = (
        'Keons', 'Sacarver', 'Listo',
        'Lisden', 'Reisdro', 'Vetomo',
        'Andre', 'Nico', 'Nills'
    );
    aliveBi = 1;
type
    Bishop = record
        name: string;
        state: integer; { <1 - dead, 1 - aliveBi }
        dir: integer;
        x, y: integer;
        relx, rely: integer; { relative to (x,y) }
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
            step(key, direction, Trash.x, Trash.y)
    until (key = Esc);
    clrscr;
    Menu(Center)
end;

function is_move(key: integer): boolean;
begin
    is_move := (key=Up) or (key=Down) or (key=Left) or (key=Right)
end;

procedure get_default_bishops(var Niners: Bishops); forward;
procedure resurrection(var Bi: Bishop); forward;
procedure bishop_step(var Bi: Bishop); forward;
procedure spawn_bishops(var Niners: Bishops);
var
    n: integer;
    hide: boolean = true;
begin
    if Niners[1].x = -1 then { bishops weren't printed yet }
        get_default_bishops(Niners);

    for n := 1 to BiAmount do begin
        resurrection(Niners[n]);

        if Niners[n].state = aliveBi then begin
            paint_bishop(Niners[n].x + Niners[n].relx,
                         Niners[n].y + Niners[n].rely,
                         Niners[n].dir, hide);
            bishop_step(Niners[n]);
            paint_bishop(Niners[n].x + Niners[n].relx,
                         Niners[n].y + Niners[n].rely,
                         Niners[n].dir)
        end else begin
            Niners[n].state := Niners[n].state - 1
        end
    end;
    GotoXY(1, ScreenHeight)
end;


procedure get_default_bishops(var Niners: Bishops);
var
    n, x, y, kx, ky: integer;
    aliveBi: integer = 1;
begin
    x := ScreenWidth div 4;
    y := ScreenHeight div 4;
    n := 1; { bishop's number }
    for ky := 1 to 3 do begin
        for kx := 1 to 3 do begin
            Niners[n].name := BiNames[n];
            Niners[n].state := aliveBi;
            Niners[n].x := kx*x;
            Niners[n].y := ky*y;
            Niners[n].relx := 0;
            Niners[n].rely := 0;
            n := n + 1
        end
    end
end;

procedure aim_bi_origin(a, a1, b, b1, w: integer; var Bi: Bishop); forward;
procedure hit_bishop(x, y, d, wave: integer; var Nrs: Bishops);
const
    DrFrontSizeY = 4;
    DrFrontSizeX = 6;
var
    n: integer;
begin
    case d of
        Up:    y := y - wave - DrFrontSizeY;
        Down:  y := y + wave + DrFrontSizeY;
        Left:  x := x - wave - DrFrontSizeX;
        Right: x := x + wave + DrFrontSizeX
    end;
    for n := 1 to BiAmount do begin
        case d of
            Up, Down:
                aim_bi_origin(x, Nrs[n].x+Nrs[n].relx,
                              y, Nrs[n].y+Nrs[n].rely, wave, Nrs[n]);
            Left, Right:
                aim_bi_origin(y, Nrs[n].y+Nrs[n].rely,
                              x, Nrs[n].x+Nrs[n].relx, wave, Nrs[n])
        end
    end
end;

procedure aim_bi_origin(a, a1, b, b1, w: integer; var Bi: Bishop);
const
    hide: boolean = true;
    msg = ' scorched!';
var
    i: integer;
begin
    if b = b1 then begin
        for i := a-w to a+w do begin
            if i = a1 then begin
                Bi.state := Bi.state - 1;
                TextColor(KnifeCol1);
                paint(3, ScreenHeight, Bi.name+msg);
                paint_bishop(Bi.x+Bi.relx, Bi.y+Bi.rely, Bi.dir, hide);
                break
            end
        end
    end
end;

procedure flamethrower(x, y, d: integer; var Niners: Bishops);
var
    SentenceLen: integer = 13;
    w: integer;
begin
    GotoXY(3, ScreenHeight); clreol;
    paint(1, 2, 'Flamethrowing');
    for w := 1 to 3 do begin
        paint(SentenceLen+w, 2, '.');
        paint_wave(x, y, d, w);
        hit_bishop(x, y, d, w, Niners);
    end;
    paint(1, 2, '                ');
    GotoXY(1, ScreenHeight);
    TextColor(DefaultCol)
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
    paint_dragon(x, y, direction)
end;

procedure resurrection(var Bi: Bishop);
const
    msg = ' resurrected!';
begin
    if Bi.state = resurrectBi then begin
        Bi.State := aliveBi;
        GotoXY(3, ScreenHeight);
        clreol;
        TextColor(BishopEyeCol);
        write(Bi.name+msg);
        TextColor(DefaultCol)
    end
end;

type
    BiMovesArr = array[1..4] of integer;

procedure allowed_moves(var n, rx, ry: integer; var moves: BiMovesArr);
forward;
procedure random_move(n: integer; moves: BiMovesArr; var Bi: Bishop); forward;
procedure change_dir_Bi(var Bi: Bishop); forward;
procedure bishop_step(var Bi: Bishop);
var
    moves: BiMovesArr;
    n: integer = 1;
begin
    if random(11) < 3 then { 20% chance of changing direction }
        change_dir_Bi(Bi);
    if random(11) < 3 then begin { 20% chance of no move }
        allowed_moves(n, Bi.relx, Bi.rely, moves);
        random_move(n, moves, Bi);
    end
end;

procedure allowed_moves(var n, rx, ry: integer; var moves: BiMovesArr);
begin
    if ry > -r then begin
        moves[n] := Up;
        n := n + 1
    end;
    if ry < r then begin
        moves[n] := Down;
        n := n + 1
    end;
    if rx > -r then begin
        moves[n] := Left;
        n := n + 1
    end;
    if rx < r then begin
        moves[n] := Right;
        n := n + 1
    end
end;

procedure random_move(n: integer; moves: BiMovesArr; var Bi: Bishop);
begin
    case moves[random(n+1)] of
        Up:
            Bi.rely := Bi.rely - 1;
        Down:
            Bi.rely := Bi.rely + 1;
        Left:
            Bi.relx := Bi.relx - 1;
        Right:
            Bi.relx := Bi.relx + 1
    end
end;

procedure change_dir_Bi(var Bi: Bishop);
begin
    if Bi.dir = Left then
        Bi.dir := Right
    else
        Bi.dir := Left
end;


{ --- INFO --- }

procedure Info(Center: point);
var
    key: integer;
    dragon_txt, bishop_txt, msg: string;
begin
    dragon_txt := 'This is Trash, a dragon.'#10 +
    'He''s good at fire-breathing.'#10;
    bishop_txt := 'This is one of the nine bishops.'#10 +
    'Each of them has a name.'#10 +
    'They wear a red cloak with a hood.'#10'And carry knifes.'#10;
    msg := 'You are flamethrower, they''re - switchblades.'#10;

    clrscr;
    paint(0, 1, dragon_txt);
    paint_dragon(15, WhereY+6, Down);
    paint(0, 15, bishop_txt);
    paint_bishop(16, WhereY+3, Left);
    paint(1, 26, msg);
    GotoXY(1, ScreenHeight);
    repeat
        GetKey(key);
    until ((key = Esc) or (key = Enter));
    clrscr;
    Menu(Center)
end;

var
    ScreenCenter: point;
begin
    ScreenCenter.x := ScreenWidth div 2;
    ScreenCenter.y := ScreenHeight div 2;
    randomize;
    clrscr;

    Menu(ScreenCenter)
end.
