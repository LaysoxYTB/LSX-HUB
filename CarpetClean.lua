local args = {
	1,
	9999999
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RequestJobComplete"):FireServer(unpack(args))

-- If you want to have this even crazier the 99999999 is your xp you earn and the 1 is the perfection (Dont Touch)
-- You can change the level. Use a while task.wait(1) do end loop on it and it will instantly complete jobs.
-- Code 2:
--[[
while task.wait(1) do
local args = {
	1,
	9999999
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RequestJobComplete"):FireServer(unpack(args))
print'weirdguycoding is cool guy. use 0xBit Script'
end
]]
