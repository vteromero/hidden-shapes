function init_title()
  fr=0
  menuitem(1,"⬅️ ".."PAL:"..colorpals[colorpalidx].name.." ➡️",titlemi_cpal)
  menuitem(2)
end

function update_title()
  fr=(fr+1)%30
  if(btnp(5))transition_to("menu")
  if(btnp(0) or btnp(1))set_dfty(current_dfty==1 and 2 or 1)
  update_titlebg()
end

function draw_title()
  draw_titlebg()
  pal(14,colors.title[4])
  pal(15,colors.title[5])
  sspr(0,8,69,25,30,20)
  pal()
  cprint("difficulty",60,colors.title[6])
  cprint(dfty_params[current_dfty].name,70,colors.title[7])
  local t=fr<15 and fr/14 or (29-fr)/14
  sspr(88,0,3,5,34-4*t,70)
  sspr(91,0,3,5,93+4*t,70)
  cprint("press ❎ to start",95,colors.title[7])
  print(version,2,121,colors.title[8])
  rprint("BY vICENTE rOMERO",125,121,colors.title[8])
end

function titlemi_cpal(b)
  if(b&1>0 or b&2>0)set_colorpal(colorpalidx==1 and 2 or 1)
  if(b&32>0)return false
  menuitem(1,"⬅️ ".."PAL:"..colorpals[colorpalidx].name.." ➡️",titlemi_cpal)
  return true
end
