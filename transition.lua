function init_transition()
  trans_items={}
  trans_cellsz=8
  local rows,cols=128\trans_cellsz,128\trans_cellsz
  for i=0,rows do
    for j=0,cols do
      add(trans_items,{
        x=i*trans_cellsz,
        y=j*trans_cellsz,
        sz=0,
        wait=sqrt(i*i+j*j),
      })
    end
  end
  sfx(4)
end

function update_transition()
  if #trans_items==0 then
    set_mode(target_mode)
  end
  for it in all(trans_items) do
    if it.wait>0 then
      it.wait-=1.5
    elseif it.sz>=trans_cellsz then
      del(trans_items,it)
    else
      it.sz+=1.5
    end
  end
end

function draw_transition()
  for it in all(trans_items) do
    local x,y,sz=it.x,it.y,it.sz
    if sz>0 then
      local hsz,col=sz\2,sz>trans_cellsz-2 and 0 or 6
      rectfill(x-hsz,y-hsz,x+hsz,y+hsz,col)
    end
  end
end

function transition_to(m)
  target_mode=m
  set_mode("transition")
end
