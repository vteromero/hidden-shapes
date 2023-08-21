function _init()
  version="V1.0.0"
  cartdata"vteromero_hiddenshapes_1_0_0"
  colorpals={
    {
      name="DARK",
      title=split"0,1,2,13,6,1,6,12",
      bg=split"1,0,5",
      ui=split"0,2,6,5,10",
      mnu=split"0,1,5,6,12,13",
      ptr=12,
      tri=0xd7,
      goal=split"8,8,9,9,11,11",
      trail=split"12,13,5"
    },{
      name="LIGHT",
      title=split"7,6,14,13,1,6,1,2",
      bg=split"6,13,7",
      ui=split"7,14,13,6,9",
      mnu=split"7,6,13,13,14,1",
      ptr=14,
      tri=0x1d,
      goal=split"8,8,9,9,11,11",
      trail=split"14,13,5"
    },
  }
  colorpalidx=1
  colors=nil
  prevmode=nil
  mode=nil
  modes={
    title={init_title,update_title,draw_title},
    menu={init_menu,update_menu,draw_menu},
    lvlstart0={init_lvlstart0,update_lvlstart0,draw_lvlstart0},
    lvlstart1={init_lvlstart1,update_lvlstart1,draw_lvlstart1},
    lvlselect={init_lvlselect,update_lvlselect,draw_lvlselect},
    lvlscale={init_lvlscale,update_lvlscale,draw_lvlscale},
    lvlrotate={init_lvlrotate,update_lvlrotate,draw_lvlrotate},
    lvlmove={init_lvlmove,update_lvlmove,draw_lvlmove},
    lvlcheck={init_lvlcheck,update_lvlcheck,draw_lvlcheck},
    lvlend={init_lvlend,update_lvlend,draw_lvlend},
    transition={init_transition,update_transition,draw_transition},
  }
  dfty_params={
    {
      name="NORMAL",
      scale_values=split"1.0,1.3,1.6",
      rotate_values=split"0.0,0.25,0.5,0.75",
      goal_triperc=0.75,
      wpad=5
    },{
      name="HARD",
      scale_values=split"1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9",
      rotate_values=split"0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9",
      goal_triperc=0.6,
      wpad=15
    }
  }
  current_dfty=1
  _upd=nil
  _drw=nil
  poke(0x5f5c,255) -- Prevents auto repeat for btnp()
  set_colorpal(dget_colorpal())
  set_dfty(dget_dfty())
  init_titlebg()
  init_background()
  set_mode("title")
end

function _update()
  _upd()
end

function _draw()
  _drw()
end

function set_mode(m)
  local init,update,draw=unpack(modes[m])
  prevmode=mode
  mode=m
  init()
  _upd=update
  _drw=draw
end

function set_colorpal(i)
  colorpalidx=mid(1,i,#colorpals)
  colors=colorpals[colorpalidx]
  dset_colorpal(colorpalidx)
end

function set_dfty(i)
  current_dfty=mid(1,i,#dfty_params)
  dset_dfty(current_dfty)
end

function dget_colorpal(cpal)
  return dget(0)&0b11
end

function dset_colorpal(cpal)
  dset(0,(dget(0)&~0b11)|cpal)
end

function dget_dfty()
  return (dget(0)>>2)&0b11
end

function dset_dfty(dfty)
  dset(0,(dget(0)&~0b1100)|(dfty<<2))
end

function dget_introseen()
  return (dget(0)>>4)&0b1
end

function dset_introseen(seen)
  dset(0,(dget(0)&~0b10000)|(seen<<4))
end

function scores_di(lvl,dfty)
  return (dfty-1)*20+lvl
end

function dget_scores(lvl,dfty)
  return unpcku32(dget(scores_di(lvl,dfty)))
end

function dset_scores(checks,time,lvl,dfty)
  dset(scores_di(lvl,dfty),pcku32(checks,time))
end
