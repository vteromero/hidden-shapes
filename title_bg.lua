function init_titlebg()
  ftricolw=10
  ftricols=13
  ftris={}
  spawnfreq=20
  spawnsync=0
  spawntype=0
  sections={80,115,134}
end

function update_titlebg()
  if spawnsync == 0 then
    for i=1,ftricols do
      spawn_tri(i)
    end
  end
  for tri in all(ftris) do
    if tri.wait>0 then
      tri.wait-=1
    else
      if tri.y<sections[1] then
        tri.y+=2
        tri.h=1
      elseif tri.y<sections[2] then
        local t=mid(0,(tri.y-sections[1])/(sections[2]-sections[1]),1)
        local minspd,maxspd=0.5,2
        local spd=minspd+(1-t)*(maxspd-minspd)
        local h=1+flr(t*4)
        tri.y+=spd
        tri.h=h
      else
        if tri.behind>0 then
          tri.y+=0.5
          tri.behind-=1
        else
          tri.y+=0.25
        end
        tri.h=5
        if tri.y>sections[3] then
          del(ftris,tri)
        end
      end
    end
  end
  spawnsync=(spawnsync+1)%spawnfreq
  spawntype=(spawntype+bool2int(spawnsync==0))%2
end

function draw_titlebg()
  cls(colors.title[1])
  for tri in all(ftris) do
    draw_ftri(tri)
  end
end

function draw_ftri(t)
  local x,y,h,typ,coli=t.x,t.y,t.h,t.type,t.coli
  local col=colors.title[coli]
  if h==1 then
    pset(x,y,col)
  else
    local h_to_a=split"1,2,3,5,6"
    local a=h_to_a[h]
    trifill(x,y,x,y-a,typ==0 and x+h or x-h,y-a/2,col)
  end
end

function spawn_tri(colidx)
  local typ=(spawntype+colidx)%2
  local wait=rndi(spawnfreq)
  add(ftris,{
    x=typ==0 and ((colidx-1)*ftricolw) or (colidx*ftricolw-3),
    y=-1,
    h=1,
    coli=rnd(split"2,2,2,2,2,2,2,2,2,3"),
    type=typ,
    wait=wait,
    behind=wait
  })
end
