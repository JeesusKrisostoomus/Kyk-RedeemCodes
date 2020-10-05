Config = {}

--[[
    This generates a number between 0000000 and 9999999
]]
Config.numericGen = false
Config.minNumber = 0000000
Config.maxNumber = 9999999


--[[
    This generates an alphanumeric code from letters (A-Z) and numbers (0-9)
]]
Config.alphanumericGen = true		-- numericGen must be "false" for this to work
Config.length = 7					-- length of the string
