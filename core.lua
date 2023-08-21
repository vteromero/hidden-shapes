function noop() end

-- returns width of string in pixels when printed on screen
function strwidth(s)
  local w=0
  for i=1,#s do
    w+=ord(s,i)<128 and 4 or 8
  end
  return w
end

-- right-aligned print. (x,y) is the top-right corner
function rprint(s,x,y,col)
  print(s,x-strwidth(s)+1,y,col)
end

-- horizontally-centered print
function cprint(s,y,col)
  print(s,65-strwidth(s)\2,y,col)
end

-- print outlined text. c0: bg color; c1: text color
function outlined(text,x,y,c0,c1)
  for i=0,2 do
    for j=0,2 do
      print(text,x+i,y+j,c0)
    end
  end
  print(text,x+1,y+1,c1)
end

-- right-aligned print outlined text. c0: bg color; c1: text color
function routlined(text,x,y,c0,c1)
  for i=0,2 do
    for j=0,2 do
      rprint(text,x-i,y+j,c0)
    end
  end
  rprint(text,x-1,y+1,c1)
end

-- rotate idx to the right
function rotir(idx,n)
  return idx%n+1
end

-- rotate idx to the left
function rotil(idx,n)
  return (idx-2)%n+1
end

function round(x)
  return flr(x+0.5)
end

function dist(x0,y0,x1,y1)
  local dx,dy=x1-x0,y1-y0
  return sqrt(dx*dx+dy*dy)
end

function rotate(x,y,cx,cy,angle)
  x-=cx
  y-=cy
  local c,s=cos(angle),-sin(angle)
  return cx+x*c-y*s,cy+x*s+y*c
end

function scale(x,y,cx,cy,factor)
  return cx+(x-cx)*factor,cy+(y-cy)*factor
end

function lerp(a,b,t)
  return a+(b-a)*t
end

-- maps v from range [a, b] to range [c, d]
-- requirements: a < b, c < d
function mapv(v,a,b,c,d)
  local x=mid(v,a,b)
  local p=(x-a)/(b-a)
  return c+p*(d-c)
end

function easeinquart(t)
  return t*t*t*t
end

function easeoutquart(t)
  t-=1
  return 1-t*t*t*t
end

function join(arr)
  local out=""
  for val in all(arr) do
    if #out>0 then
      out..=","..tostr(val)
    else
      out..=tostr(val)
    end
  end
  return out
end

function format_num(n)
  return n<10 and "0"..n or n
end

function format_time(secs)
  local m,s=secs\60,secs%60
  return format_num(m)..":"..format_num(s)
end

-- split 0-based array
function split0(s)
  local arr=split(s)
  local first=deli(arr,1)
  arr[0]=first
  return arr
end

function split2d(s)
  local arr={}
  for v in all(split(s,"|",false)) do
    add(arr,split(v))
  end
  return arr
end

function fillpi(i)
  -- lighter to darker
  local patterns = {
    0b0000000000000000, -- solid (lighter)
    0b1000000000100000, -- dots
    0b1010000010100000, -- dots (evenly distributed)
    0b0010010110000101, -- stiches 1
    0b1010010110100101, -- small chessboard
    0b1010011110101101, -- stiches 2
    0b1111101011111010, -- reverse dots (evenly distributed)
    0b0111111111011111, -- reverse dots
    0b1111111111111111, -- solid (darker)
  }
  fillp(patterns[i])
end

function bool2int(b)
  return b and 1 or 0
end

function rndi(x)
  return flr(rnd(x))
end

-- packs two u16 values into a u32 integer
function pcku32(high,low)
	return high|(low>>16)
end

-- unpacks a u32 value into two u16 integers
function unpcku32(x)
	return x&0xffff,x<<16
end
