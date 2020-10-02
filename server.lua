local oldPrint = print
print = function(trash)
	oldPrint('^2[Redeem Codes] '..trash..'^0')
end

ESX = nil 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

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

RegisterCommand("redeem", function(source, args, rawCommand)
    MySQL.Async.fetchAll('SELECT * FROM `RedeemCodes` WHERE `code` = @code', {
			['@code'] = args[1]
	}, function(data)
            	if (args[1] == data.code) then
			xPlayer.addAccountMoney('bank', data.amount)
			TriggerClientEvent('chat:addMessage', {
  				color = { 0, 255, 0},
  				multiline = true,
  				args = {"Success", "Code redeemed successfuly! You just recieved: $"..data.amount}
			})
			--DELETE post FROM blog INNER JOIN post WHERE blog.id = post.blog_id;
			MySQL.Async.execute("DELETE FROM RedeemCodes WHERE code = data.code;")
		else
			TriggerClientEvent('chat:addMessage', {
  				color = { 255, 0, 0},
  				multiline = true,
  				args = {"ERROR", "It seems like this code is invalid!"}
			})
		end
    end)    
end, false)
