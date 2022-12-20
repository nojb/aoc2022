function insert(t, x, y, z)
   if not t[x] then t[x] = {} end
   if not t[x][y] then t[x][y] = {} end
   t[x][y][z] = true
end

function read()
   local xy, xz, yz = {}, {}, {}
   for s in io.lines() do
      local x, y, z = string.match(s, "(%d+),(%d+),(%d+)")
      local x, y, z = tonumber(x), tonumber(y), tonumber(z)
      insert(xy, x, y, z)
      insert(xz, x, z, y)
      insert(yz, y, z, x)
   end
   return xy, xz, yz
end

function surface(t)
   local zmin, zmax
   for z, _ in pairs(t) do
      if not zmin or z < zmin then zmin = z end
      if not zmax or z > zmax then zmax = z end
   end
   assert(zmin <= zmax)
   local prev = true
   local surf = 2
   assert(t[zmin] and t[zmax])
   for z = zmin, zmax do
      if t[z] and not prev then
         surf = surf + 1
         prev = true
      elseif not t[z] and prev then
         surf = surf + 1
         prev = false
      end
   end
   assert(surf % 2 == 0)
   return surf
end

function main()
   local xy, xz, yz = read()
   local surf = 0
   for x, t in pairs(xy) do
      for y, t in pairs(t) do
         surf = surf + surface(t)
      end
   end
   for x, t in pairs(xz) do
      for z, t in pairs(t) do
         surf = surf + surface(t)
      end
   end
   for y, t in pairs(yz) do
      for z, t in pairs(t) do
         surf = surf + surface(t)
      end
   end
   print(surf)
end

main()
