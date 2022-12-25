function snafu2dec(s)
   local n = 0
   local p = 1
   for pos = string.len(s), 1, -1 do
      local c = string.sub(s, pos, pos)
      local m
      if c == '-' then
         m = -1
      elseif c == '=' then
         m = -2
      else
         m = string.byte(c, 1) - string.byte('0', 1)
      end
      n = n + m * p
      p = 5 * p
   end
   return n
end

-- Decimal-to-SNAFU, using the following identities:
-- 4 * 5^n = 5^{n+1} - 1 * 5^n
-- 3 * 5^n = 5^{n+1} - 2 * 5^n
function dec2snafu(n)
   assert(n > 0)
   local t = {}
   while n > 0 do
      local r = n % 5
      local s
      n = math.floor(n / 5)
      if 0 <= r and r <= 2 then
         s = tostring(r)
      elseif r == 3 then
         n = n + 1
         s = '='
      elseif r == 4 then
         n = n + 1
         s = '-'
      end
      table.insert(t, 1, s)
   end
   return table.concat(t)
end

function main()
   local tot = 0
   for s in io.lines() do
      -- do
      --    local n = snafu2dec(s)
      --    local s_ = dec2snafu(n)
      --    if s_ ~= s then
      --       print(s, n, s_, snafu2dec(s_))
      --       assert(nil)
      --    end
      -- end
      tot = tot + snafu2dec(s)
   end
   print(dec2snafu(tot))
end

main()
