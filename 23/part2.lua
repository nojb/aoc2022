function readrow(s)
   local t = {}
   for i = 1, string.len(s) do
      if string.sub(s, i, i) == '#' then
         t[i] = true
      end
   end
   return t
end

function read()
   local t = {}
   for s in io.lines() do
      table.insert(t, readrow(s))
   end
   return t
end

N = 'N'
S = 'S'
W = 'W'
E = 'E'
NE = 'NE'
NW = 'NW'
SE = 'SE'
SW = 'SW'

function getpos(x, y, d)
   if d == N then
      return x, y-1
   elseif d == S then
      return x, y+1
   elseif d == W then
      return x-1, y
   elseif d == E then
      return x+1, y
   elseif d == NE then
      return x+1, y-1
   elseif d == NW then
      return x-1, y-1
   elseif d == SE then
      return x+1, y+1
   elseif d == SW then
      return x-1, y+1
   end
end

-- Whether (x, y) contains an Elf.
function isset(t, x, y)
   return t[y] and t[y][x]
end

function set(t, x, y)
   if not t[y] then t[y] = {} end
   t[y][x] = true
end

function unset(t, x, y)
   if t[y][x] then t[y][x] = nil end
end

-- Row-based iteration of all occupied cells.
function iter(t, f)
   for y, t in pairs(t) do
      for x in pairs(t) do
         f(x, y)
      end
   end
end

function length(t)
   local total = 0
   local function f(_, _) total = total + 1 end
   iter(t, f)
   return total
end

-- Record a proposed move from (x, y) to (x1, y1).
function addmove(t, x, y, d)
   local x1, y1 = getpos(x, y, d)
   if not t[y1] then t[y1] = {} end
   t[y1][x1] = {x = x, y = y, next = t[y1][x1]}
end

-- Whether an Elf should propose a move.
function shouldmove(t, x, y)
   for _, d in pairs{N, S, W, E, NE, SE, NW, SW} do
      if isset(t, getpos(x, y, d)) then
         return true
      end
   end
   return false
end

-- Propose a move (if directions d1, d2, d3 are empty) in direction d2.
function trymove(t, x, y, d1, d2, d3)
   if
      not isset(t, getpos(x, y, d1)) and
      not isset(t, getpos(x, y, d2)) and
      not isset(t, getpos(x, y, d3))
   then
      return d2
   end
end

-- List of directions to try.
D = {{NW, N, NE}, {SW, S, SE}, {NW, W, SW}, {NE, E, SE}}

-- Propose a move (if possible).
function propose(t, i, x, y, next_moves)
   for j = 0, #D - 1 do
      local d = D[(i + j - 1) % #D + 1]
      local move = trymove(t, x, y, table.unpack(d))
      if move then
         addmove(next_moves, x, y, move)
         break
      end
   end
end

function firsthalf(t, i)
   local next_moves = {}
   local function f(x, y)
      if shouldmove(t, x, y) then
         propose(t, i, x, y, next_moves)
      end
   end
   iter(t, f)
   return next_moves
end

function secondhalf(t, next_moves)
   local function f(x, y)
      local moves = next_moves[y][x]
      if moves and not moves.next then
         set(t, x, y)
         unset(t, moves.x, moves.y)
      end
   end
   iter(next_moves, f)
end

-- Perform a full turn (i = turn number).
function doturn(t, i)
   local next_moves = firsthalf(t, i)
   secondhalf(t, next_moves)
   return length(next_moves) ~= 0
end

function main()
   local t = read()
   local i = 1
   while true do
      if not doturn(t, i) then
         break
      end
      i = i + 1
   end
   print(i)
end

main()
