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
      S[i] = i * X
      X = X + n
   end
   return S
end

function main()
   local prog = {}
   for s in io.lines() do
      parse_opcode(prog, s)
   end
   local S = run(prog)
   return S[20] + S[60] + S[100] + S[140] + S[180] + S[220]
end

print(main())
