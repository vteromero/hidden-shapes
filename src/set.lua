function sadd(s,val)
  s[val]=true
end

function sdel(s,val)
  s[val]=nil
end

function stoggle(s,val)
  if s[val]==nil then
    sadd(s,val)
  else
    sdel(s,val)
  end
end

function scount(s)
  local c=0
  for _ in pairs(s) do c+=1 end
  return c
end

function sdiff(s1,s2)
  local out={}
  for k,_ in pairs(s1) do
    sadd(out,k)
  end
  for k,_ in pairs(s2) do
    sdel(out,k)
  end
  return out
end

function to_set(arr)
  local s={}
  for val in all(arr) do
    sadd(s,val)
  end
  return s
end
