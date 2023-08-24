function load_level_data(data)
  local p_list,tri_list={},{}
  for p in all(split2d(data.points)) do
    add(p_list,{x=p[1],y=p[2]})
  end
  for tr in all(split2d(data.triangles)) do
    add(tri_list, {
      points={tr[1],tr[2],tr[3]},
      pattern=tr[4],
      selected=false
    })
  end
  return data.name,p_list,tri_list
end

function load_level(lvl)
  local dfty_params=dfty_params[current_dfty]
  scale_values=dfty_params.scale_values
  scale_index=1
  rotate_values=dfty_params.rotate_values
  rotate_index=1
  wpad=dfty_params.wpad
  pointer = {
    x=64,
    y=64,
    speed=1.2,
    dx=split0"0,-1,1,0,0,-0.71,-0.71,0.71,0.71",
    dy=split0 "0,0,0,-1,1,-0.71,0.71,-0.71,0.71",
    dir=0, -- 0:stop, 1:l, 2:r, 3:u, 4:d, 5:lu, 6:ld, 7:ru, 8:rd
    btn_to_dir=split0"0,1,2,0,3,5,7,3,4,6,8,4,0,1,2,0",
  }
  lvl_name,initial_points,triangles=load_level_data(levels[lvl])
  points=initial_points
  world=calc_world(points,wpad)
  goal=calc_goal(points,triangles,rotate_values,scale_values,dfty_params.goal_triperc,wpad)
  goal_progress=update_goal_progress(goal,rotate_index,scale_index,world.x,world.y,triangles)
  checks,timer=0,0
  best_checks,best_time=dget_scores(lvl,current_dfty)
  current_level = lvl
end

function start_level(lvl)
  if(lvl)load_level(lvl)
  menuitem(1,"restart level",function()load_level(current_level)set_mode("lvlstart0")end)
  menuitem(2,"exit level",function()set_mode("menu")end)
  transition_to("lvlstart0")
end

-----------------
-- lvlstart0 mode
-----------------
function init_lvlstart0()
  intro0 = {
    "\^y8welcome to this geometric\nworld, where shapes are hidden\nin plain sight.",
    "\^y8each puzzle features a \"3d\"\nobject that can be rotated,\nscaled and moved.",
    "\^y8this object is composed of\ntriangles that you can turn\non and off.",
    "\^y8your goal is to fill up a\nflat 2d shape (your \"goal\nshape\")...",
    "\^y8by selecting the right\ntriangles and making them\nmatch exactly the goal shape.",
    "\^y8hold ❎ to check your progress\nor if you want to see the goal\nshape again for a moment.",
    "\^y8now, you've got 3 seconds to\nmemorize the shape..."
  }
  intro1={}
  if dget_introseen()==0 then
    intro=intro0
    dset_introseen(1)
  else
    intro=intro1
  end
  introidx=min(1,#intro)
  fr=0
end

function update_lvlstart0()
  fr=(fr+1)%40
  if btnp(5) then
    if introidx==0 then
      set_mode("lvlstart1")
    elseif introidx<#intro then
      introidx+=1
    else
      introidx=0
    end
  end
  update_background()
end

function draw_lvlstart0()
  draw_background()
  rectfill(0,40,127,90,colors.ui[1])
  line(0,40,127,40,colors.ui[2])
  line(0,90,127,90,colors.ui[2])
  if introidx==0 then
    cprint("ready?",60,colors.ui[3])
  else
    print(intro[introidx],5,48,colors.ui[3])
  end
  draw_anixbtn(fr)
end

-----------------
-- lvlstart1 mode
-----------------
function init_lvlstart1()
  t=90
end

function update_lvlstart1()
  t=max(t-1,0)
  if(t==0)set_mode("lvlselect")
  update_background()
end

function draw_lvlstart1()
  draw_background()
  for tri in all(goal.tri_list) do
    local p1,p2,p3=get_tripoints(triangles[tri],goal.points)
    trifill(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,colors.ptr)
  end
  outlined(tostr(flr(t/30)+1),60,60,7,1)
end

-----------------
-- lvlselect mode
-----------------
function init_lvlselect()
  init_hud(1,"select","🅾️mode","❎toggle")
  xbtn=btn_handler(5,toggle_triangle,check_goal)
  trail={}
  trail_steps=split2d"8,2,1|5,2,2|3,1,3|1,0,3"
end

function update_lvlselect()
  timer=inc_timer(timer)
  move_pointer()
  update_btn(xbtn)
  if(btnp(4))set_mode("lvlscale")
  update_trail()
  update_hud()
  update_background()
end

function draw_lvlselect()
  draw_background()
  draw_triangles()
  draw_trail()
  pal(14,colors.ptr)
  spr(1,pointer.x-4,pointer.y-4)
  pal()
  draw_hud(xbtn)
end

function find_triangle_at(px, py)
  for tri in all(triangles) do
    local a,b,c=get_tripoints(tri,points)
    if (is_inside_triangle(a.x,a.y,b.x,b.y,c.x,c.y,px,py)) then
      return tri
    end
  end
end

function toggle_triangle()
  local tri=find_triangle_at(world.x+pointer.x,world.y+pointer.y)
  if tri then
    tri.selected=not tri.selected
    sfx(tri.selected and 0 or 1)
  end
end

function spawn_trail(x,y)
  local ang=rnd()
  add(trail, {
    x=x+sin(ang)*1.2,
    y=y+cos(ang)*1.2,
    age=10+rndi(10)
  })
end

function update_trailp(p)
  for step in all(trail_steps) do
    local age,sz,coli=unpack(step)
    if p.age>=age then
      p.sz=sz
      p.col=colors.trail[coli]
      return
    end
  end
end

function update_trail()
  for p in all(trail) do
    p.age-=1
    if p.age>0 then
      update_trailp(p)
    else
      del(trail,p)
    end
  end
end

function draw_trail()
  for p in all(trail) do
    circfill(p.x,p.y,p.sz,p.col)
  end
end

function move_pointer()
  local dir=pointer.btn_to_dir[btn()&0b1111]
  local nextpx=pointer.x+pointer.dx[dir]*pointer.speed
  local nextpy=pointer.y+pointer.dy[dir]*pointer.speed
  if dir~=pointer.dir and dir>=5 then -- is changing direction to a diagonal move?
    -- anti-cobblestoning
    nextpx=flr(nextpx)
    nextpy=flr(nextpy)
  end
  local nextwx=world.x+mid(nextpx-127,0,nextpx)
  local nextwy=world.y+mid(nextpy-127,0,nextpy)
  nextpx=mid(0,nextpx,127)
  nextpy=mid(0,nextpy,127)
  if nextpx~=pointer.x or nextpy~=pointer.y then
    spawn_trail(pointer.x,pointer.y)
  end
  pointer.x=nextpx
  pointer.y=nextpy
  pointer.dir=dir
  pointer.speed=dir==0 and 1.2 or min(pointer.speed+0.05,2.5)
  world.x=mid(world.x0,nextwx,world.x1-127)
  world.y=mid(world.y0,nextwy,world.y1-127)
end

----------------
-- lvlscale mode
----------------
function init_lvlscale()
  init_hud(2,"scale","🅾️mode","⬆️⬇️scale")
  xbtn=btn_handler(5,noop,check_goal)
  scmage,scage,scf0,scf1,scpts=10,0,0,0,{}
end

function update_lvlscale()
  timer=inc_timer(timer)
  if btnp(2) and scale_index<#scale_values then
    start_scani(scale_values[scale_index],scale_values[scale_index+1])
    scale_index+=1
    update_points()
  end
  if btnp(3) and scale_index>1 then
    start_scani(scale_values[scale_index],scale_values[scale_index-1])
    scale_index-=1
    update_points()
  end
  if btnp(4) then
    set_mode("lvlrotate")
  end
  update_btn(xbtn)
  update_scani()
  update_hud()
  update_background()
end

function draw_lvlscale()
  draw_background()
  draw_triangles(scage>0 and scpts or points)
  draw_hud(xbtn)
end

function start_scani(f0,f1)
  scage,scf0,scf1=scmage,f0,f1
  scpts=transform_points(initial_points,rotate_values[rotate_index],f0)
end

function update_scani()
  if scage>0 then
    scage-=1
    local t=(scmage-scage)/scmage
    local f=lerp(scf0,scf1,easeoutquart(t))
    scpts=transform_points(initial_points,rotate_values[rotate_index],f)
  end
end

-----------------
-- lvlrotate mode
-----------------
function init_lvlrotate()
  init_hud(3,"rotate","🅾️mode","⬆️⬇️rotate")
  xbtn=btn_handler(5,noop,check_goal)
  rotmage,rotage,rotang0,rotang1,rotpts=10,0,0,0,{}
end

function update_lvlrotate()
  timer=inc_timer(timer)
  if btnp(2) or btnp(3) then
    local previdx=rotate_index
    local rotifn=btnp(2) and rotir or rotil
    rotate_index=rotifn(rotate_index,#rotate_values)
    update_points()
    start_rotani(rotate_values[previdx],rotate_values[rotate_index],btnp(2))
  end
  if btnp(4) then
    if can_move() then
      set_mode("lvlmove")
    else
      set_mode("lvlselect")
    end
  end
  update_btn(xbtn)
  update_rotani()
  update_hud()
  update_background()
end

function draw_lvlrotate()
  draw_background()
  draw_triangles(rotage>0 and rotpts or points)
  draw_hud(xbtn)
end

function can_move()
  local w,h=world.x1-world.x0+1,world.y1-world.y0+1
  return w>128 or h>128
end

function start_rotani(ang0,ang1,isup)
  rotage=rotmage
  if isup then
    rotang0,rotang1=ang0,ang1<ang0 and ang1+1 or ang1
  else
    rotang0,rotang1=ang0<ang1 and ang0+1 or ang0,ang1
  end
  rotpts=transform_points(initial_points,ang0,scale_values[scale_index])
end

function update_rotani()
  if rotage>0 then
    rotage-=1
    local t=(rotmage-rotage)/rotmage
    local ang=lerp(rotang0,rotang1,easeoutquart(t))
    rotpts=transform_points(initial_points,ang,scale_values[scale_index])
  end
end

---------------
-- lvlmove mode
---------------
function init_lvlmove()
  init_hud(4,"move","🅾️mode","⬅️➡️⬆️⬇️move")
  xbtn=btn_handler(5,noop,check_goal)
end

function update_lvlmove()
  timer=inc_timer(timer)
  if(btn(0))world.x+=1
  if(btn(1))world.x-=1
  if(btn(2))world.y+=1
  if(btn(3))world.y-=1
  world.x=mid(world.x0,world.x,world.x1-127)
  world.y=mid(world.y0,world.y,world.y1-127)
  if(btnp(4))set_mode("lvlselect")
  update_btn(xbtn)
  update_hud()
  update_background()
end

function draw_lvlmove()
  draw_background()
  draw_triangles()
  draw_hud(xbtn)
end

----------------
-- lvlcheck mode
----------------
function init_lvlcheck()
  lines_dur=30
  shake_dur=5
  sfx(2)
end

function update_lvlcheck()
  timer=inc_timer(timer)
  lines_dur=max(0,lines_dur-1)
  if(lines_dur==0)set_mode(prevmode)
  shake_dur=max(0,shake_dur-1)
  update_background()
end

function draw_lvlcheck()
  draw_background()
  draw_triangles()
  local offx=shake_dur>0 and rnd(5)-2 or 0
  local offy=shake_dur>0 and rnd(5)-2 or 0
  draw_goal_shape(colors.goal[goal_progress.index],offx,offy)
  if current_dfty==1 then
    draw_gphints()
  else
    draw_gpbar()
  end
end

function draw_gphints()
  local st=goal_progress.status
  local offcol=colors.ui[4]
  draw_hud_box2(43,2,42,11)
  pal(15,st.triexact and 11 or (st.trimost and 9 or offcol))
  spr(7,45,3)
  pal(15,st.sc and 11 or offcol)
  spr(2,55,3)
  pal(15,st.rot and 11 or offcol)
  spr(3,65,3)
  pal(15,st.pos and 11 or offcol)
  spr(4,75,3)
  pal()
end

function draw_gpbar()
  local idx=goal_progress.index
  rectfill(50,3,79,5,colors.ui[4])
  rectfill(50,3,50+5*idx,5,colors.goal[idx])
  rect(49,2,80,6,colors.ui[1])
end

--------------
-- lvlend mode
--------------
function init_lvlend()
  elapsed=timer\30+(timer%30==0 and 0 or 1)
  checks_newrecord,time_newrecord=false,false
  if best_checks==0 or checks<best_checks then
    best_checks=checks
    checks_newrecord=true
  end
  if best_time==0 or elapsed<best_time then
    best_time=elapsed
    time_newrecord=true
  end
  dset_scores(best_checks,best_time,current_level,current_dfty)
  fr=0
  ani={
    {
      upd=function(t,data) data.idx=(data.idx+0.25)%#data.col end,
      drw=function(data) draw_goal_shape(data.col[flr(data.idx+1)]) end,
      data={idx=0,col={3,11}}
    },{
      start=1,
      stop=15,
      upd=function(t,data) data.top=lerp(64,40,easeoutquart(t)) data.bottom=lerp(65,89,easeoutquart(t)) end,
      drw=function(data)
        local top,bottom=data.top,data.bottom
        rectfill(0,top,127,bottom,colors.ui[1])
        line(0,top,127,top,colors.ui[2])
        line(0,bottom,127,bottom,colors.ui[2])
      end,
      data={top=64,bottom=65}
    },{
      start=25,
      upd=function(t,data)
        data.show=t==1
        data.fidx=(data.fidx+0.5)%#data.fcol
      end,
      drw=function(data)
        if data.show then
          local col=colors.ui[3]
          print("checks:",37,68,col)
          print("time:",37,76,col)
          rprint(tostr(checks),89,68,col)
          rprint(format_time(elapsed),89,76,col)
          if checks_newrecord then
            print("BEST",92,68,data.fcol[flr(data.fidx+1)])
          end
          if time_newrecord then
            print("BEST",92,76,data.fcol[flr(data.fidx+1)])
          end
          draw_anixbtn(fr%40)
        end
      end,
      data={show=false,fidx=0,fcol={2,14}}
    }
  }
  local titles=split"awesome!,fantastic!,bravo!,amazing!,well done!,wonderful!,marvelous!,superb!,excellent!"
  add_title_ani(ani,rnd(titles),10,52)
  world.x=goal.world_x
  world.y=goal.world_y
  sfx(3)
end

function update_lvlend()
  fr+=1
  if(btnp(5))transition_to("menu")
  for a in all(ani) do
    local start=a.start or 1
    local stop=a.stop
    local t=stop and mapv(fr,start,stop,0,1) or bool2int(fr>=start)
    a.upd(t,a.data)
  end
  update_background()
end

function draw_lvlend()
  draw_background()
  draw_triangles()
  for a in all(ani) do
    a.drw(a.data)
  end
end

function add_title_ani(ani, title, t, y)
  local m=(#title+1)/2
  for i=1,#title do
    local d=m-i
    add(ani,{
      start=t,
      stop=t+8*flr(abs(d)+1),
      upd=update_tletter,
      drw=draw_tletter,
      data={
        s=sub(title,i,i),
        x0=d>=0 and -6 or 128,
        x1=62-d*8,
        y=y
      }
    })
  end
end

function update_tletter(t,data)
  data.x=lerp(data.x0,data.x1,easeoutquart(t))
end

function draw_tletter(data)
  print(data.s,data.x,data.y,colors.ui[5])
end

------------------
-- other functions
------------------
function calc_world(points,pad,oldwrld)
  local x0,y0,x1,y1=points[1].x,points[1].y,points[1].x,points[1].y
  for p in all(points) do
    x0,y0,x1,y1=min(x0,p.x-pad),min(y0,p.y-pad),max(x1,p.x+pad),max(y1,p.y+pad)
  end
  local midx,midy=x0+(x1-x0+1)\2,y0+(y1-y0+1)\2
  x0,y0,x1,y1=min(x0,midx-63),min(y0,midy-63),max(x1,midx+64),max(y1,midy+64)
  return {
    x0=x0,
    y0=y0,
    x1=x1,
    y1=y1,
    x=oldwrld and mid(x0,oldwrld.x,x1-127) or (midx-63),
    y=oldwrld and mid(y0,oldwrld.y,y1-127) or (midy-63)
  }
end

function transform_points(points,angle,sfactor)
  local cx,cy,pts=64,64,{}
  for p in all(points) do
    local x0,y0=rotate(p.x,p.y,cx,cy,angle)
    local x1,y1=scale(x0,y0,cx,cy,sfactor)
    add(pts,{x=round(x1),y=round(y1)})
  end
  return pts
end

function update_points()
  points=transform_points(initial_points,rotate_values[rotate_index],scale_values[scale_index])
  world=calc_world(points,wpad,world)
end

function check_goal()
  checks+=1
  goal_progress=update_goal_progress(goal,rotate_index,scale_index,world.x,world.y,triangles)
  if goal_progress.index==6 then
    set_mode("lvlend")
  else
    set_mode("lvlcheck")
  end
end

function get_tripoints(tri,points)
  return points[tri.points[1]],points[tri.points[2]],points[tri.points[3]]
end

function draw_triangles(pts)
  local wx,wy=world.x,world.y
  for tr in all(triangles) do
    local p1,p2,p3=get_tripoints(tr, pts or points)
    if tr.selected then
      trifill(p1.x-wx,p1.y-wy,p2.x-wx,p2.y-wy,p3.x-wx,p3.y-wy,colors.ptr)
    else
      fillpi(tr.pattern)
      trifill(p1.x-wx,p1.y-wy,p2.x-wx,p2.y-wy,p3.x-wx,p3.y-wy,colors.tri)
      fillp()
    end
  end
end

function draw_goal_shape(col,offx,offy)
  local ox,oy=offx or 0,offy or 0
  for tri in all(goal.tri_list) do
    local p1,p2,p3=get_tripoints(triangles[tri],goal.points)
    fillp(0b0111111111011111.1)
    trifill(ox+p1.x,oy+p1.y,ox+p2.x,oy+p2.y,ox+p3.x,oy+p3.y,col)
    fillp()
  end
  for l in all(goal.ln_list) do
    local p1,p2=goal.points[l[1]],goal.points[l[2]]
    line(ox+p1.x,oy+p1.y,ox+p2.x,oy+p2.y,col)
  end
end

function draw_anixbtn(fr)
  local c0,c1=colors.ui[3],colors.ui[4]
  if fr<20 then
    rectfill(115,81,121,84,c1)
    line(116,85,120,85,c1)
    rprint("❎",122,80,c0)
  else
    rectfill(116,81,120,85,c1)
    rprint("❎",122, 81,c0)
  end
end

function inc_timer(timer)
  return min(timer+1,32766)
end
