function trifill(ax,ay,bx,by,cx,cy,col)
  local v1x,v1y,v2x,v2y,v3x,v3y=ax,ay,bx,by,cx,cy
  if v2y<v1y then
    if v3y<v2y then
      v1x,v1y,v3x,v3y=v3x,v3y,v1x,v1y
    elseif v3y < v1y then
      v1x,v1y,v2x,v2y=v2x,v2y,v1x,v1y
      v2x,v2y,v3x,v3y=v3x,v3y,v2x,v2y
    else
      v1x,v1y,v2x,v2y=v2x,v2y,v1x,v1y
    end
  else
    if v3y<v1y then
      v1x,v1y,v3x,v3y=v3x,v3y,v1x,v1y
      v2x,v2y,v3x,v3y=v3x,v3y,v2x,v2y
    elseif v3y<v2y then
      v2x,v2y,v3x,v3y=v3x,v3y,v2x,v2y
    end
  end
  if v2y==v3y then
    trifillt(v1x,v1y,v2x,v2y,v3x,v3y,col)
  elseif v1y==v2y then
    trifillb(v1x,v1y,v2x,v2y,v3x,v3y,col)
  else
    local v4x=v1x+((v2y-v1y)/(v3y-v1y))*(v3x-v1x)
    local v4y=v2y
    trifillt(v1x,v1y,v2x,v2y,v4x,v4y,col)
    trifillb(v2x,v2y,v4x,v4y,v3x,v3y,col)
  end
end

function trifillt(v1x,v1y,v2x,v2y,v3x,v3y,col)
  local invs1,invs2=(v2x-v1x)/(v2y-v1y),(v3x-v1x)/(v3y-v1y)
  local x1,x2=v1x,v1x
  for y=v1y,v2y do
    line(round(x1),y,round(x2),y,col)
    x1+=invs1
    x2+=invs2
  end
end

function trifillb(v1x,v1y,v2x,v2y,v3x,v3y,col)
  local invs1,invs2=(v3x-v1x)/(v3y-v1y),(v3x-v2x)/(v3y-v2y)
  local x1,x2=v3x,v3x
  for y=v3y,v2y,-1 do
    line(round(x1),y,round(x2),y,col)
    x1-=invs1
    x2-=invs2
  end
end

function sign(ax,ay,bx,by,cx,cy)
  return (ax-cx)*(by-cy)-(bx-cx)*(ay-cy)
end

function is_inside_triangle(ax,ay,bx,by,cx,cy,px,py)
  local d0,d1,d2=sign(px,py,ax,ay,bx,by),sign(px,py,bx,by,cx,cy),sign(px,py,cx,cy,ax,ay)
  return (d0>0)==(d1>0) and (d1>0)==(d2>0)
end
