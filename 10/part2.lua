-- For simplicity, we take addx to be only one cycle long
function parse_opcode(t, s)
   table.insert(t, 0)
   local n = string.match(s, "addx ([%d-]+)")
   if not n then return end -- noop
   n = assert(tonumber(n))
   table.insert(t, n)
end

function run(t)
   local S = {}
   local X = 1
   for i, n in pairs(t) do
      local pos = (i - 1) % 40
      if math.abs(pos - X) <= 1 then
         io.write('#')
      else
         io.write('.')
      end
      if pos == 39 then
         io.write('\n')
      end
      X = X + n
   end
   return S
end

function main()
   local code = {}
   for s in io.lines() do
      parse_opcode(code, s)
   end
   run(code)
end

main()
