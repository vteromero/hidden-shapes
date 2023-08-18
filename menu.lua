function init_menu()
  last_unlocked=get_last_unlocked(current_dfty)
  preview_pts={}
  lvl_locked=false
  shake_dur=0
  fr=0
  set_menumi()
  switch_level(current_level or 1)
end

function update_menu()
  fr=(fr+1)%30
  shake_dur=max(0,shake_dur-1)
  if(btnp(0) and current_level>1)switch_level(current_level-1)
  if(btnp(1) and current_level<#levels)switch_level(current_level+1)
  if(btnp(4))set_mode("title")
  if btnp(5) then
    if lvl_locked then
      shake_dur=6
      sfx(2)
    else
      start_level()
    end
  end
  update_background()
end

function draw_menu()
  draw_background()
  -- menu box
  rectfill(20,10,107,117,colors.mnu[1])
  rect(20,10,107,117,colors.mnu[3])
  -- shape preview box
  fillp(0b1010010110100101.1)
  rectfill(34,19,93,78,colors.mnu[2])
  fillp()
  rectfill(36,21,91,76,colors.mnu[2])
  -- shape preview
  draw_preview()
  if lvl_locked then
    local ox=shake_dur>0 and rnd(3)-1 or 0
    local oy=shake_dur>0 and rnd(3)-1 or 0
    sspr(76,0,12,14,59+ox,41+oy)
  end
  -- level name
  rectfill(34,83,94,91,lvl_locked and 5 or colors.mnu[5])
  cprint(lvl_name,85,colors.mnu[1])
  -- scores
  draw_scores(lvl_locked and 5 or colors.mnu[4])
  -- arrows
  local t=fr<15 and fr/14 or (29-fr)/14
  if current_level>1 then
    sspr(65,0,6,9,10-4*t,60)
  end
  if current_level<#levels then
    sspr(70,0,6,9,112+4*t,60)
  end
  -- footer
  print(current_level.."/"..#levels,2,121,colors.mnu[6])
  rprint(dfty_params[current_dfty].name,126,121,colors.mnu[6])
end

function draw_scores(col)
  local s1=best_checks==0 and "-" or tostr(best_checks)
  print("checks:",34,96,col)
  rprint(s1,94,96,col)
  local s2=best_time==0 and "--:--" or format_time(best_time)
  print("time:",34,104,col)
  rprint(s2,94,104,col)
end

function set_menumi()
  menuitem(1,"⬅️ ".."DFTY:"..dfty_params[current_dfty].name.." ➡️",menumi_dfty)
  menuitem(2,"⬅️ ".."PAL:"..colorpals[colorpalidx].name.." ➡️",menumi_cpal)
end

function menumi_dfty(b)
  if(b&1>0 or b&2>0)switch_dfty(current_dfty==1 and 2 or 1)
  if(b&32>0)return false
  set_menumi()
  return true
end

function menumi_cpal(b)
  if(b&1>0 or b&2>0)set_colorpal(colorpalidx==1 and 2 or 1)
  if(b&32>0)return false
  set_menumi()
  return true
end

function switch_dfty(dfty)
  set_dfty(dfty)
  last_unlocked=get_last_unlocked(dfty)
  switch_level(current_level)
end

function switch_level(lvl)
  load_level(lvl)
  preview_pts=calc_preview(points,39,24,50,50)
  lvl_locked=lvl>last_unlocked
end

function calc_preview(points, dx, dy, dw, dh)
  local x0,y0,x1,y1=points[1].x,points[1].y,points[1].x,points[1].y
  for p in all(points) do
    x0,y0,x1,y1=min(x0,p.x),min(y0,p.y),max(x1,p.x),max(y1,p.y)
  end
  local w,h=x1-x0+1,y1-y0+1
  local sc=min(dw/w,dh/h)
  local dx0=dx+(dw-w*sc)/2
  local dy0=dy+(dh-h*sc)/2
  local pts={}
  for p in all(points) do
    local x,y=scale(p.x,p.y,x0,y0,sc)
    add(pts,{x=round(x-x0+dx0),y=round(y-y0+dy0)})
  end
  return pts
end

function draw_preview()
  for tr in all(triangles) do
    local p1,p2,p3=get_tripoints(tr,preview_pts)
    if lvl_locked then
      trifill(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,5)
    else
      fillpi(tr.pattern)
      trifill(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,colors.tri)
      fillp()
    end
  end
end

function get_last_unlocked(dfty)
  for lvl=1,#levels do
    local checks,time=dget_scores(lvl,dfty)
    if checks==0 and time==0 then
      return lvl
    end
  end
  return #levels
end
