pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- hidden shapes
-- by vicente romero
#include main.lua
#include title.lua
#include title_bg.lua
#include menu.lua
#include level.lua
#include background.lua
#include goal.lua
#include data.lua
#include core.lua
#include graphics.lua
#include hud.lua
#include transition.lua
#include set.lua
#include btn.lua
__gfx__
00000000000000000000000000000000000f00000ffffff000000000000000000000055500000000111100000066000000000000000000000000000000000000
00000000000000000000fff000ff000000fff000ffffffff00f0f0000000000000005a5a50000001666610000666600000000000000000000000000000000000
00700700000550000000fff00f0000000f000f00ffffffff00f0f00000f000000005aa5aa5000016111161006666660000000000000000000000000000000000
000770000057e5000ff0fff00f000f00ff0f0ff0ffffffff00f0f00000ff0000005aaa5aaa500161000016100dddd00000000000000000000000000000000000
00077000005ee5000ff0fff00f00fff00f000f00ffffffff0000000000fff00005aaaa5aaaa501610000161000dd000000000000000000000000000000000000
00700700000550000ff000000f000f0000fff000ffffffff00f0f00000ffff000059995999500161111116100000000000000000000000000000000000000000
00000000000000000000000000fff000000f0000effffffe00000000000000000005995995001666666666610000000000000000000000000000000000000000
00000000000000000000000000000000000000000eeeeee000000000000000000000595950001699999999610000000000000000000000000000000000000000
eeee00eeee00eeee00eeeeeee00000eeeeeee00000eeeeeeee0eeee000eeee000000055500001699a99999610000000000000000000000000000000000000000
eeee00eeee00eeee00eeeeeeee0000eeeeeeee0000eeeeeeee0eeee000eeee00000000000000169a999999610000000000000000000000000000000000000000
eeee00eeee00eeee00eeeeeeeee000eeeeeeeee000eeeeeeee0eeeee00eeee000000000000001699999999610000000000000000000000000000000000000000
eeee00eeee00eeee00eeeeeeeee000eeeeeeeee000eeee00000eeeee00eeee000000000000001699999999610000000000000000000000000000000000000000
eeee00eeee00eeee00eeee0eeeee00eeee0eeeee00eeee00000eeeeee0eeee000000000000001666666666610000000000000000000000000000000000000000
eeeeeeeeee00eeee00eeee00eeee00eeee00eeee00eeee00000eeeeee0eeee000000000000000111111111100000000000000000000000000000000000000000
eeeeeeeeee00eeee00eeee00eeee00eeee00eeee00eeeeeee00eeeeeeeeeee000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeee00eeee00eeee00eeee00eeee00eeee00eeeeeee00eeeeeeeeeee000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeee00eeee00eeee00eeee00eeee00eeee00eeeeeee00eeeeeeeeeee000000000000000000000000000000000000000000000000000000000000000000
eeee00eeee00eeee00eeee00eeee00eeee00eeee00eeee00000eeee0eeeeee000000000000000000000000000000000000000000000000000000000000000000
eeee00eeee0ffffe0ffffe0ffffe00eeffffeeee0ffffff0000effffffffee00ffff000000000000000000000000000000000000000000000000000000000000
eeee00eeefffffff0ffffeeffffe00effffffeee0ffffffffe0effffffffeefffffff00000000000000000000000000000000000000000000000000000000000
eeee00eeffffffff0ffffeeffff000effffffee00fffffffff0effffffffeffffffff00000000000000000000000000000000000000000000000000000000000
eeee00eeffffeeff0ffffeeffff000effffffe000ffffeffff0effff00eeeffff00ff00000000000000000000000000000000000000000000000000000000000
eeee00eeffffeeef0ffffeeffff000ffffffff000ffffeeffffeffff00eeeffff000f00000000000000000000000000000000000000000000000000000000000
00000000fffff0000ffffffffff000ffffffff000ffff00ffff0ffff00000fffff00000000000000000000000000000000000000000000000000000000000000
000000000fffff000ffffffffff000ffff0fff000ffff0fffff0fffffff000fffff0000000000000000000000000000000000000000000000000000000000000
0000000000fffff00ffffffffff000fff00fff000fffffffff00fffffff0000fffff000000000000000000000000000000000000000000000000000000000000
00000000000fffff0ffffffffff00ffff00ffff00ffffffff000fffffff00000fffff00000000000000000000000000000000000000000000000000000000000
00000000f000ffff0ffff00ffff00ffff00ffff00fffffff0000ffff00000f000ffff00000000000000000000000000000000000000000000000000000000000
00000000ff00ffff0ffff00ffff00ffffffffff00ffff0000000ffff00000ff00ffff00000000000000000000000000000000000000000000000000000000000
00000000ffffffff0ffff00ffff00ffffffffff00ffff0000000ffff00000ffffffff00000000000000000000000000000000000000000000000000000000000
00000000fffffff00ffff00ffff0ffffffffffff0ffff0000000ffffffff0fffffff000000000000000000000000000000000000000000000000000000000000
00000000ffffff000ffff00ffff0ffff0000ffff0ffff0000000ffffffff0ffffff0000000000000000000000000000000000000000000000000000000000000
000000000ffff0000ffff00ffff0ffff0000ffff0ffff0000000ffffffff00ffff00000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000c54007300090000a0000d000120001070000000010002100023000240002500026000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100000054000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800000a1200a1300a1400a13018100181001810018100181001a10036100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
000800001954023530235302c5202c5202c5202c5102c5102c5102c5102c5002c5012c5012c5012c5012c5012c5012c5012c5012c5012c5012c5012c501005000050000500005000050000500005000050000500
000700000b7300b7300b7300b7300d7200f7101471014700097000a70000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
