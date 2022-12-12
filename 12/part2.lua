function readgrid()
   local G = {}
   local i = 1
   local Ei, Ej
   for s in io.lines() do
      G[i] = {}
      for j = 1, string.len(s) do
         local c = string.sub(s, j, j)
         if c == 'S' then
            c = 'a'
         elseif c == 'E' then
            Ei, Ej, c = i, j, 'z'
         end
         G[i][j] = c
      end
      i = i + 1
   end
   return G, Ei, Ej
end

-- Whether a move from G[i][j] to G[k][l] is allowed.  Assumes (i, j) is a valid
-- index of G, but not (k, l) necessarily.
function allowed(G, i, j, k, l)
   return k >= 1 and k <= #G and l >= 1 and l <= #G[k] and string.byte(G[k][l]) <= string.byte(G[i][j]) + 1
end

function find(t, k, i, j)
   if t[k] and t[k][i] then
      return t[k][i][j]
   end
end

function add(t, k, i, j, x)
   if not t[k] then t[k] = {} end
   if not t[k][i] then t[k][i] = {} end
   t[k][i][j] = x
end

function size(G)
   local tot = 0
   for _, r in pairs(G) do
      tot = tot + #r
   end
   return tot
end

-- M = memoization table mapping (Si, Sj) to the shortest path to E
-- k = max number of steps to take
-- G = height grid
-- Si, Sj = starting position
-- Ei, Ej = ending position
function shortest(M, G, k, Si, Sj, Ei, Ej)
   if Si == Ei and Sj == Ej then
      return 0
   elseif k == 0 then
      return math.huge
   else
      local m = find(M, k, Si, Sj)
      if m then return m end
      local u, d, l, r = math.huge, math.huge, math.huge, math.huge
      if allowed(G, Si, Sj, Si - 1, Sj) then
         u = shortest(M, G, k - 1, Si - 1, Sj, Ei, Ej) + 1
      end
      if allowed(G, Si, Sj, Si + 1, Sj) then
         d = shortest(M, G, k - 1, Si + 1, Sj, Ei, Ej) + 1
      end
      if allowed(G, Si, Sj, Si, Sj - 1) then
         l = shortest(M, G, k - 1, Si, Sj - 1, Ei, Ej) + 1
      end
      if allowed(G, Si, Sj, Si, Sj + 1) then
         r = shortest(M, G, k - 1, Si, Sj + 1, Ei, Ej) + 1
      end
      local m = math.min(u, d, l, r)
      add(M, k, Si, Sj, m)
      return m -- can return math.huge if dead-end
   end
end

function main()
   local G, Ei, Ej = readgrid()
   local r = math.huge
   local M = {}
   for i = 1, #G do
      for j = 1, #G[i] do
         if G[i][j] == 'a' then
            local d = shortest(M, G, size(G), i, j, Ei, Ej)
            if d < r then r = d end
         end
      end
   end
   print(r)
end

main()
