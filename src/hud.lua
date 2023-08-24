function init_hud(icon,title,bottoml,bottomr)
  hud_icon=icon
  hud_title=title
  hud_title_dur=30
  hud_bottoml=bottoml
  hud_bottomr=bottomr
end

function update_hud()
  hud_title_dur=max(0,hud_title_dur-1)
end

function draw_hud(xbtn)
  -- icon
  draw_hud_box2(2,2,12,12)
  pal(14,colors.ptr)
  pal(15,colors.ui[3])
  spr(hud_icon,4,4)
  pal()
  -- title
  if hud_title and hud_title_dur>0 then
    draw_hud_box(48,2,32)
    cprint(hud_title,3,colors.ui[3])
  end
  -- checks
  draw_hud_box(104,2,22)
  pal(15,colors.ui[5])
  spr(6,107, 2)
  pal()
  print(checks>99 and "99+" or format_num(checks),115,3,colors.ui[3])
  -- bottom hints
  if not (btn_holding(xbtn) or btn_held(xbtn)) then
    outlined(hud_bottoml,2,120,colors.ui[1],colors.ui[3])
    routlined(hud_bottomr,125,120,colors.ui[1],colors.ui[3])
  end
  -- checking pb
  if btn_holding(xbtn) then
    draw_hud_pb(50,117,30,xbtn.t/25)
    cprint("check",118,colors.ui[3])
  end
end

function draw_hud_box(x,y,w,c0,c1)
  if(w<4)return
  pal(15,c0 or colors.ui[1])
  pal(14,c1 or colors.ui[2])
  sspr(40,0,2,8,x,y)
  sspr(42,0,1,8,x+2,y,w-4,8)
  sspr(46,0,2,8,x+w-2,y)
  pal()
end

function draw_hud_box2(x,y,w,h,c0,c1)
  if(w<4 or h<4)return
  pal(15,c0 or colors.ui[1])
  pal(14,c1 or colors.ui[2])
  sspr(40,0,2,2,x,y)
  sspr(42,0,1,2,x+2,y,w-4,2)
  sspr(46,0,2,2,x+w-2,y)
  sspr(40,2,1,4,x,y+2,w,h-4)
  sspr(40,6,2,2,x,y+h-2)
  sspr(42,6,1,2,x+2,y+h-2,w-4,2)
  sspr(46,6,2,2,x+w-2,y+h-2)
  pal()
end

function draw_hud_pb(x,y,w,p,c0,c1,c2)
  local c0=c0 or colors.ui[1]
  local c1=c1 or colors.ui[2]
  local c2=c2 or colors.ui[2]
  local pw=flr(w*mid(0.0,p,1.0))
  draw_hud_box(x,y,w,c0,c1)
  draw_hud_box(x,y,pw,c2,c1)
end
