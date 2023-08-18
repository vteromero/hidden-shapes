function init_background()
  bgfreq=1000
  bgfr=0
  bgsqpals=split2d"3,2,2|2,3,2"
  bgnr=11
  bgnc=11
  bgcellsz=28
  bgcells,bgrows,bgcols=create_bgcells()
  sldminwait=20
  sldmaxwait=80
  sldmaxage=10
  spawn_slide()
end

function update_background()
  bgfr=(bgfr+1)%bgfreq
  if(bgfr==sldstart)sldage=sldmaxage
  if sldage>0 then
    sldage-=1
    local t=(sldmaxage-sldage)/sldmaxage
    local off=flr(t*(bgcellsz\2))
    local ox=(sldtype==0 or sldtype==2) and -off or off
    local oy=(sldtype==1 or sldtype==2) and -off or off
    local cells=sldtype<2 and bgrows[sldtarget] or bgcols[sldtarget]
    for cell in all(cells) do
      local x,y=get_cell_pos(cell.r,cell.c)
      cell.x=x+ox
      cell.y=y+oy
    end
    if sldage==0 then
      if sldtype==0 or sldtype==2 then
        slide_left(cells)
      else
        slide_right(cells)
      end
      spawn_slide()
    end
  end
end

function draw_background()
  cls(colors.bg[1])
  for cell in all(bgcells) do
    local cpal,x,y=cell.cpal,cell.x,cell.y
    draw_bgsq(x,y,4,colors.bg[cpal[1]])
    draw_bgsq(x,y,8,colors.bg[cpal[2]])
    draw_bgsq(x,y,12,colors.bg[cpal[3]])
  end
end

function create_bgcells()
  local rows,cols,cells={},{},{}
  for i=1,bgnr do
    add(rows, {})
  end
  for i=1,bgnc do
    add(cols, {})
  end
  for r=1,bgnr do
    for c=1,bgnc do
      local x,y=get_cell_pos(r,c)
      local cell={r=r,c=c,x=x,y=y,cpal=rnd(bgsqpals)}
      add(rows[r],cell)
      add(cols[c],cell)
      add(cells,cell)
    end
  end
  return cells,rows,cols
end

function get_cell_pos(r,c)
  local halfcell=bgcellsz\2
  local cr,cc=bgnr\2+1,bgnc\2+1
  local dr,dc=r-cr,c-cc
  local x=64+(dr+dc)*halfcell
  local y=64+(dr-dc)*halfcell
  return x,y
end

function spawn_slide()
  sldage=0
  sldtarget=rndi(bgnr)+1
  sldtype=rndi(4)
  sldstart=(bgfr+sldmaxwait+rndi(sldmaxwait-sldminwait))%bgfreq
end

function draw_bgsq(cx,cy,h,col)
  local x0,x1,x2=cx-h,cx,cx+h
  local y0,y1,y2=cy-h,cy,cy+h
  line(x1,y0,x2,y1,col)
  line(x2,y1,x1,y2,col)
  line(x1,y2,x0,y1,col)
  line(x0,y1,x1,y0,col)
end

function slide_left(cells)
  local tmppal=cells[1].cpal
  for i=1,#cells do
    local cell=cells[i]
    cell.x,cell.y=get_cell_pos(cell.r,cell.c)
    if(i<#cells)cell.cpal=cells[i+1].cpal
  end
  cells[#cells].cpal=tmppal
end

function slide_right(cells)
  local tmppal=cells[#cells].cpal
  for i=#cells,1,-1 do
    local cell=cells[i]
    cell.x,cell.y=get_cell_pos(cell.r,cell.c)
    if(i>1)cell.cpal=cells[i-1].cpal
  end
  cells[1].cpal=tmppal
end
