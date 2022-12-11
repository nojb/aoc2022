-- score[x][y] is your score if your opponent plays x and you play according to
-- strategy y

-- A = rock, B = paper, C = scissor
-- X = lose, Y = draw, Z = win

score = {
   A = { X = 3, Y = 4, Z = 8 },
   B = { X = 1, Y = 5, Z = 9 },
   C = { X = 2, Y = 6, Z = 7 }
}

total = 0

while true do
   local line = io.read()
   if line == nil then -- end of file
      break
   else
      a, b = string.match(line, "(%w+) (%w+)")
      total = total + score[a][b]
   end
end

print(total)
