Config = {}

--[[ Numeric Generator ]]
Config.numericGenerator = false --[[ If this is true then the code will be generated between Config.minNumber and Config.maxNumber ]]
Config.minNumber = 0000000
Config.maxNumber = 9999999

--[[ Alphanumeric Generator ]]
Config.alphanumericGen = true --[[ If this is true then the code will be generated from random letters and numbers, using Config.length to set code length ]]
Config.length = 10 --[[ This sets the length of generated codes (alphanumericGen only) ]]

--[[ Other Options ]]
Config.globalAnnouncements = true