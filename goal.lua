function calc_goal(points,triangles,rot_values,sc_values,tri_perc,wpad)
  local rot_idx=rndi(#rot_values)+1
  local sc_idx=rndi(#sc_values)+1
  local pts=transform_points(points,rot_values[rot_idx],sc_values[sc_idx])
  local w=calc_world(pts,wpad)
  local ww=w.x1-w.x0+1
  local wh=w.y1-w.y0+1
  local wx=w.x0+rndi(ww-128)
  local wy=w.y0+rndi(wh-128)
  pts=shift_points(pts,wx,wy)
  local tri_list=pick_triangles(pts,triangles,tri_perc)
  local ln_list=get_tri_outline(triangles,tri_list)
  return {
    rotate_index=rot_idx,
    scale_index=sc_idx,
    world_x=wx,
    world_y=wy,
    tri_list=tri_list,
    ln_list=ln_list,
    points=pts,
  }
end

function update_goal_progress(goal,rot_idx,sc_idx,wx,wy,triangles)
  local seltri_set={}
  for i,t in pairs(triangles) do
    if(t.selected)sadd(seltri_set, i)
  end
  local gtri_set=to_set(goal.tri_list)
  local gtri_all=count(goal.tri_list)
  local gtri_left=scount(sdiff(gtri_set,seltri_set))
  local seltri_wrong=scount(sdiff(seltri_set,gtri_set))
  local tri_perc=(gtri_all-gtri_left)/gtri_all
  local tri_most=tri_perc>=0.65
  local tri_exact=gtri_left==0 and seltri_wrong == 0
  local rot_matches=rot_idx==goal.rotate_index
  local sc_matches=sc_idx==goal.scale_index
  local wpos_is_close=abs(wx-goal.world_x)<=2 and abs(wy-goal.world_y)<=2
  local pindex = 1 +
                 bool2int(tri_most) +
                 bool2int(tri_exact) +
                 bool2int(rot_matches) +
                 bool2int(sc_matches) +
                 bool2int(wpos_is_close)
  return {
    index=pindex,
    status = {
      trimost=tri_most,
      triexact=tri_exact,
      rot=rot_matches,
      sc=sc_matches,
      pos=wpos_is_close
    }
  }
end

function shift_points(points,world_x,world_y)
  local pts = {}
  for p in all(points) do
    add(pts,{x=p.x-world_x,y=p.y-world_y})
  end
  return pts
end

function pick_triangles(points,triangles,tri_perc)
  local visible_tri=get_visible_tri_indexes(points,triangles)
  local n=flr(#visible_tri*tri_perc)
  local tri_list={}
  for i=1,n do
    local j=rndi(#visible_tri)+1
    add(tri_list,visible_tri[j])
    deli(visible_tri,j)
  end
  return tri_list
end

function get_visible_tri_indexes(points,triangles)
  local pv,tri_list={},{}
  for p in all(points) do
    add(pv,p.x>=0 and p.x<128 and p.y>=0 and p.y<128)
  end
  for i,t in pairs(triangles) do
    if pv[t.points[1]] and pv[t.points[2]] and pv[t.points[3]] then
      add(tri_list,i)
    end
  end
  return tri_list
end

function get_tri_outline(triangles,tri_list)
  local ln_set,ln_list={},{}
  for i in all(tri_list) do
    local tr=triangles[i].points
    local pi1,pi2,pi3=tr[1],tr[2],tr[3]
    stoggle(ln_set,join(sort2({pi1,pi2})))
    stoggle(ln_set,join(sort2({pi1,pi3})))
    stoggle(ln_set,join(sort2({pi2,pi3})))
  end
  for k,_ in pairs(ln_set) do
    add(ln_list,split(k))
  end
  return ln_list
end

function sort2(arr)
  return arr[1]<=arr[2] and arr or {arr[2],arr[1]}
end
