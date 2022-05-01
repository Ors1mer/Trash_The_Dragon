unit dragon;
{$mode OBJFPC} { Used to create optional function arguments }
interface

procedure paint_dragon(x, y: integer; hide: boolean = false);
procedure paint_image();

implementation
uses crt;

procedure paint(x, y: integer; data: string);
begin
    GotoXY(x, y);
    write(data);
end;

procedure paint_image();
const
    title = '<><><> Trash The Dragon <><><>';
var
    image: array[1..30] of string;
    linenum: integer;
begin
    image[1] := '°*o**.oo*oO°*oo.oO*.O* *O°.°°o°°o. .**o  oO°*  o° oO°oo*oOOO*° *@# oO**OOOOOO*°**oooO*°@@@@@@@@@@@@@@@@';
    image[2] := 'oo.°oo*o°oo°Oo**o°*O° °o°°*. oo.°o°.°*°oo °O.*  *° .o*°o*oOOOo o@@°.oOo*o***.°*OO**o*O**@@@@@@@@@@@@@@@';
    image[3] := '*.*Oo°**°*o°O°.o°*o° *O°.o°  *o°..°* o.oo° O°** .*°°  .***OOOOo o@# .o#o.°*ooooOOo°O*oO.o@@@@@@@@@@@@@@';
    image[4] := ' *O**o*°o*oo*°*o**°.oO..°*O .o*.* .  ***Oo °o.*°°°o°o  *oO*oOOOO o@#*°*o.O*oOoOO° °oO*oO°@@@@@@@@@@@@@@';
    image[5] := ' Oo**o°o*°***o°oo° oo  °. *.*o°o.°.o.°°*oo. o.*°# *oO .  o@.OO**o***o#o.  oOO*** ***oo**O*@@@@@@@@@@@@@';
    image[6] := '.oo°o*°*°o*°o°*o° °Oo  o   .O°*°  °. Oo°oo. o°O . .ooo*. #@.°ooo*oOo *@@@.°OO  o°o°**oO*o*o@@@@@@@@@@@@';
    image[7] := 'o.*°°.o*°o*°**o*.oO*  .o.**°° ..*.o °O°*Oo. .**  *°°°O°o °#@Ooo*Oo**O#@@O oo*.*°.*OoO**O*#*o@@@@@@@@@@@';
    image[8] := '@#OO*°°o.*°°* *.°**o °°.* .o**. . .°o*°*OO  *°*° oO°*o*°O .o o@* O°°@@#..oOOO.°#o.°OoOo***#°O@@@@@@@@@@';
    image[9] := '.°oooO°..°o*Oo**°* *° °*.°°..*Oo°.. .. °   .°** °ooooOOO*° °°O@.    o@@°.ooOOO*.O#*.o*Oo*oOO°#@@@@@@@@@';
    image[10] := 'oooOo°O#####OO#O °  **°o. .oooo*Oo..#°*O o°°°.**o.°..  °#* .O@o  °. .@@o.#**Oo°°O@@ °**oo*OOO.#@@@@@@@@';
    image[11] := '*oo° O#Ooo*.°**OOO* *O. .*° °*o**°°.o.*O.ooo* . °.*o*°o  #@oo@° .°O .O@#.oOOo.#@#°°°ooo*oo*OOO°@@@@@@@@';
    image[12] := ' °°*.°°*oo° ..° °° °°.°ooo**o°****° °.°° *°°*o°  .*°@°°*. o##@@   o#o  #O  °*o.O@.*Ooo*ooOO*oOO°#@@@@@@';
    image[13] := '****OOo*OO#O*o. O. °*ooO*°*o°*°°°*oo*°*o°.°*o**.  .°O#°**.°. .o@o   °O*#@@OoO°  #@..oOoo*OOOo*O#**@@@@@';
    image[14] := '.OO°°*. **° °o°..   o*°*°*..° °*°°oo°Oo°*°o**.*o. ..*oOo° oo.° .#@O°  .*o@@@@o  o@#Oo.ooOoooOO*oO°°@@@@';
    image[15] := '.oo.°*oooo*oo°°*o**o*o.*#° °°o*°°°***°*°**oo*o°***o... *@° o.**   °O@o    °o@@#@@##o°.oooOOoooo**Oo*@@@';
    image[16] := '°°*.*o° .°*o°  °*#Oo°***O. OO°oo* *oo***o**OoOOoo°°o°°  @o.o°o*.°°   @@#o. *@#@O.. *    *ooOOooo***ooo#';
    image[17] := ' .°o° ° .*..°.*°. ..   ***o.. °oo°. oOOo.***°O*ooOo**o°.@..*o * .***.##o@@@@@@@.  *@  *.   .°*ooooo*oo*';
    image[18] := 'Oo °° *....°. °°°*.°o°  . °O°*°***°*o**°.**°*°°***o*ooO.*O .*° .O.°*o#.o@#@@@* °.O@*.*°o***    °*ooOOO#';
    image[19] := '°.°°**° o**oo*oOoOo°**O. .  °**o°°*o°..o**.°°*oo***°oOoOo**#Ooo#° *o  .@@#@@@* ° o@°°o.OO°oO#°°. °.°**o';
    image[20] := 'o°**°°*O*.°oO°°OO***o. #.°*   .°** .  °*°**OooOOOo*ooooooO O@o°Ooo***o@@oo°@o.°  O#O °  °°.*°.**°o.    ';
    image[21] := '°.°**o°  .O* °o*°°°° .°*  o * O#o..*°.**°°°*oOOOoo°**°*OoooOoooOO*.@@@#@OoO@*.# O@.oO##OOOoooo*o**ooOOo';
    image[22] := 'oOo .* .*O°.OO  o*  °°°°***oO#@@@#°°°°o°°°  .   *.*°.oO**OO°oOO**°o@o ..*#o°°.°O#O .@@@@@@@@@@@@@@@@@@@';
    image[23] := 'o° *@°*o. #@@°*O° O@@@@@@@@@@@@@@@@#o.°.°°.*..*   °  ooo*oOo*o °#@@. O@@o*  o#O***o@@@@@@@@@@@@@@@@@@@@';
    image[24] := '°O@@O.O° @@@O o° O@@@@@@@@@@@@@@@@@@@@#####o°.. *o °. *. *.°°oO@O   o@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
    image[25] := '@@@@ oO #@@@°.#..@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#oo*°*°oOO#@O°°.°#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
    image[26] := '@@@o°O*.@@@o°oo O@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
    image[27] := '@@@.*o O@@@o.o* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
    image[28] := '@@@ *°°@@@@@#.o @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
    image[29] := '@@@O°*°@@@@@@@@OO@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
    image[30] := '@@@@@oo@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
    TextBackground(Cyan); TextColor(Black);
    paint(75 div 2, 1, title);
    TextBackground(Black); TextColor(LightGray);
    for linenum := 2 to 31 do
    begin
        paint(1, linenum, image[linenum-1]);
        Delay(20)
    end;
    TextBackground(Black); TextColor(LightGray);
end;

{
°*o**.oo*oO°*oo.oO*.O* *O°.°°o°°o. .**o  oO°*  o° oO°oo*oOOO*° *@# oO**OOOOOO*°**oooO*°@@@@@@@@@@@@@@@@
oo.°oo*o°oo°Oo**o°*O° °o°°*. oo.°o°.°*°oo °O.*  *° .o*°o*oOOOo o@@°.oOo*o***.°*OO**o*O**@@@@@@@@@@@@@@@
*.*Oo°**°*o°O°.o°*o° *O°.o°  *o°..°* o.oo° O°** .*°°  .***OOOOo o@# .o#o.°*ooooOOo°O*oO.o@@@@@@@@@@@@@@
 *O**o*°o*oo*°*o**°.oO..°*O .o*.* .  ***Oo °o.*°°°o°o  *oO*oOOOO o@#*°*o.O*oOoOO° °oO*oO°@@@@@@@@@@@@@@
 Oo**o°o*°***o°oo° oo  °. *.*o°o.°.o.°°*oo. o.*°# *oO .  o@.OO**o***o#o.  oOO*** ***oo**O*@@@@@@@@@@@@@
.oo°o*°*°o*°o°*o° °Oo  o   .O°*°  °. Oo°oo. o°O . .ooo*. #@.°ooo*oOo *@@@.°OO  o°o°**oO*o*o@@@@@@@@@@@@
o.*°°.o*°o*°**o*.oO*  .o.**°° ..*.o °O°*Oo. .**  *°°°O°o °#@Ooo*Oo**O#@@O oo*.*°.*OoO**O*#*o@@@@@@@@@@@
@#OO*°°o.*°°* *.°**o °°.* .o**. . .°o*°*OO  *°*° oO°*o*°O .o o@* O°°@@#..oOOO.°#o.°OoOo***#°O@@@@@@@@@@
.°oooO°..°o*Oo**°* *° °*.°°..*Oo°.. .. °   .°** °ooooOOO*° °°O@.    o@@°.ooOOO*.O#*.o*Oo*oOO°#@@@@@@@@@
oooOo°O#####OO#O °  **°o. .oooo*Oo..#°*O o°°°.**o.°..  °#* .O@o  °. .@@o.#**Oo°°O@@ °**oo*OOO.#@@@@@@@@
*oo° O#Ooo*.°**OOO* *O. .*° °*o**°°.o.*O.ooo* . °.*o*°o  #@oo@° .°O .O@#.oOOo.#@#°°°ooo*oo*OOO°@@@@@@@@
 °°*.°°*oo° ..° °° °°.°ooo**o°****° °.°° *°°*o°  .*°@°°*. o##@@   o#o  #O  °*o.O@.*Ooo*ooOO*oOO°#@@@@@@
****OOo*OO#O*o. O. °*ooO*°*o°*°°°*oo*°*o°.°*o**.  .°O#°**.°. .o@o   °O*#@@OoO°  #@..oOoo*OOOo*O#**@@@@@
.OO°°*. **° °o°..   o*°*°*..° °*°°oo°Oo°*°o**.*o. ..*oOo° oo.° .#@O°  .*o@@@@o  o@#Oo.ooOoooOO*oO°°@@@@
.oo.°*oooo*oo°°*o**o*o.*#° °°o*°°°***°*°**oo*o°***o... *@° o.**   °O@o    °o@@#@@##o°.oooOOoooo**Oo*@@@
°°*.*o° .°*o°  °*#Oo°***O. OO°oo* *oo***o**OoOOoo°°o°°  @o.o°o*.°°   @@#o. *@#@O.. *    *ooOOooo***ooo#
 .°o° ° .*..°.*°. ..   ***o.. °oo°. oOOo.***°O*ooOo**o°.@..*o * .***.##o@@@@@@@.  *@  *.   .°*ooooo*oo*
Oo °° *....°. °°°*.°o°  . °O°*°***°*o**°.**°*°°***o*ooO.*O .*° .O.°*o#.o@#@@@* °.O@*.*°o***    °*ooOOO#
°.°°**° o**oo*oOoOo°**O. .  °**o°°*o°..o**.°°*oo***°oOoOo**#Ooo#° *o  .@@#@@@* ° o@°°o.OO°oO#°°. °.°**o
o°**°°*O*.°oO°°OO***o. #.°*   .°** .  °*°**OooOOOo*ooooooO O@o°Ooo***o@@oo°@o.°  O#O °  °°.*°.**°o.    
°.°**o°  .O* °o*°°°° .°*  o * O#o..*°.**°°°*oOOOoo°**°*OoooOoooOO*.@@@#@OoO@*.# O@.oO##OOOoooo*o**ooOOo
oOo .* .*O°.OO  o*  °°°°***oO#@@@#°°°°o°°°  .   *.*°.oO**OO°oOO**°o@o ..*#o°°.°O#O .@@@@@@@@@@@@@@@@@@@
o° *@°*o. #@@°*O° O@@@@@@@@@@@@@@@@#o.°.°°.*..*   °  ooo*oOo*o °#@@. O@@o*  o#O***o@@@@@@@@@@@@@@@@@@@@
°O@@O.O° @@@O o° O@@@@@@@@@@@@@@@@@@@@#####o°.. *o °. *. *.°°oO@O   o@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@ oO #@@@°.#..@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#oo*°*°oOO#@O°°.°#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@o°O*.@@@o°oo O@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@.*o O@@@o.o* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@ *°°@@@@@#.o @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@O°*°@@@@@@@@OO@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@oo@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
}
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
    paint(x, y-5, filler+filler);
    paint(x-1, y-4, filler);
    paint(x, y-3, filler);
    paint(x-1, y-2, filler+filler+filler);
    paint(x-1, y-1, filler+filler+filler);
    paint(x-2, y, filler+filler+filler+filler+filler);
    paint(x, y+1, filler);
    paint(x-1, y+2, filler+filler+filler);
    { Wings }
    TextColor(White);
    paint(x-4, y-1, wing+wing);
    paint(x+3, y-1, wing+wing);
    paint(x-3, y, wing);
    paint(x+3, y, wing);
    { Legs }
    TextColor(LightGray);
    paint(x-2, y-2, leg);
    paint(x+2, y-2, leg);
    paint(x-2, y-1, paw);
    paint(x+2, y-1, paw);
    paint(x-1, y+1, leg);
    paint(x+1, y+1, leg);
    paint(x-2, y+2, paw);
    paint(x+2, y+2, paw);
    { Head }
    TextColor(LightRed);
    paint(x-1, y+3, eye+' '+eye);
    TextColor(LightCyan);
    paint(x, y+3, wing);
    paint(x, y+4, mouth);
    TextColor(LightGray);
end;

end.
