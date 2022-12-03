-- score[x][y] is your score when your opponent plays x and you play y.

-- A = X = rock
-- B = Y = paper
-- C = Z = scissor

score = {
   A = { X = 4, Y = 8, Z = 3 },
   B = { X = 1, Y = 5, Z = 9 },
   C = { X = 7, Y = 2, Z = 6 }
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
