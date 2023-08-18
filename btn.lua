function btn_handler(b,onpress,onhold)
  return {b=b,onpress=onpress,onhold=onhold,t=0}
end

function btn_pressed(bt)
  return bt.t<10
end

function btn_held(bt)
  return bt.t>=25
end

function btn_holding(bt)
  return not (btn_pressed(bt) or btn_held(bt))
end

function update_btn(bt)
  if(btnp(bt.b))bt.t=1
  if bt.t>0 then
    if btn(bt.b) then
      if(btn_held(bt))bt.onhold()
      bt.t+=1
    else
      if(btn_pressed(bt))bt.onpress()
      bt.t=0
    end
  end
end
