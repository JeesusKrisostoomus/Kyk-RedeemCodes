--[[
    local _source = source
    local money = 0
    local bankmoney = 0
    local identifier = GetPlayerIdentifiers(_source)[1]
    MySQL.Async.execute("INSERT INTO moneyAccounts (identifier, cash, bank) VALUES (@Identifier,@cash,@bank)", {['@identifier'] = identifier, ['@cash'] = money, ['@bank'] = bankmoney})
]]
local oldPrint = print
print = function(trash)
	oldPrint('^2[Redeem Codes] '..trash..'^0')
end

local uC = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
local lC = "abcdefghijklmnopqrstuvwxyz"
local num = "0123456789"
local characterSet = uC .. lC .. num

local RandomCode

function RandomCodeGenerator()
    math.randomseed(os.time())
    for i = 1, Config.codeLength do
        local RandomCode = math.random(#characterSet)
        print("Generated Code: "..RandomCode)
    end
end

--[[
    Register the command to generate the code.
]]
RegisterCommand("genCode", function(source, args, rawCommand)
        if (args[1] == "money") then
            if (args[2] == "") then
                print("Invalid Amount")
            else
                RandomCodeGenerator()
		Wait(5)
		MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, amount) VALUES (@code,@type,@amount)", {['@code'] = RandomCode, ['@type'] = money, ['@amount'] = args[2]})
		Wait(5)
		RandomCode = ""
            end
        else
            print("Unknown Type. Please make sure u typed everything correctly and that the script is correctly setup.")
        end
end, true)
