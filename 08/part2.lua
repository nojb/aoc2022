function read_grid()
   local t = {}
   local i = 1
   for s in io.lines() do
      t[i] = {}
      for j = 1, string.len(s) do
         t[i][j] = tonumber(string.sub(s, j, j))
      end
      i = i + 1
   end
   return t
end

function score(t, i, j)
   local dl, dr, du, dd = 0, 0, 0, 0
   for b = j - 1, 1, -1 do
      dl = dl + 1
      if t[i][j] <= t[i][b] then
         break
      end
   end
   for b = j + 1, #t[i] do
      dr = dr + 1
      if t[i][j] <= t[i][b] then
         break
      end
   end
   for a = i - 1, 1, -1 do
      du = du + 1
      if t[i][j] <= t[a][j] then
         break
      end
   end
   for a = i + 1, #t do
      dd = dd + 1
      if t[i][j] <= t[a][j] then
         break
      end
   end
   return dl * dr * du * dd
end

function main()
   local t = read_grid()
   local max = 0
   for i, r in pairs(t) do
      for j, _ in pairs(r) do
         local score = score(t, i, j)
         if score > max then max = score end
      end
   end
   return max
end

print(main())
