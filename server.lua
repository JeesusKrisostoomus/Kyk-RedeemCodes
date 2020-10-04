local oldPrint = print
print = function(trash)
	oldPrint('^2[Redeem Codes] '..trash..'^0')
end

ESX = nil 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local RandomCode = ""

function RandomCodeGenerator()
    math.randomseed(os.time())
	RandomCode = math.random(Config.minNumber, Config.maxNumber)
	return RandomCode
end

--[[
    Register the command to generate the code.
]]
RegisterCommand("genCode", function(source, args, rawCommand)
	if (args[1] == "money" or args[1] == "Money") then
        if (args[2] == nil) then
			if (source == 0) then
				print("Invalid arguments")
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments." }, color = 255,255,255 })
			end
		else
			MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, amount) VALUES (@code,@type,@amount)", {
				['@code'] = RandomCodeGenerator(),
				['@type'] = "money", 
				['@amount'] = args[2]
			})
			if (source ~= 0) then
				TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code generated successfully! Check the database to see the code." }, color = 255,255,255 })
			else
				print("Code Generated Successfully!\n[Code Info] Code Type: Money\n[Code Info] Code: "..RandomCode)
			end
			Wait(5)
			RandomCode = ""
        end
	else
		if (source ~= 0) then
			TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Unknown Type. Please make sure u typed everything correctly and that the script is correctly setup." }, color = 255,255,255 })
		else
			print("Unknown Type. Please make sure u typed everything correctly and that the script is correctly setup.")
		end
    end
end, true)

RegisterCommand("redeem", function(source, args, rawCommand)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if (args[1] == nil) then 
		if (source ~= 0) then
			TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Code cannot be empty!" }, color = 255,255,255 })
		else
			print("Code cannot be empty!")
		end
	else
    	MySQL.Async.fetchAll('SELECT * FROM `RedeemCodes` WHERE `code` = @code', {
				['@code'] = args[1]
		}, function(data)
			if (args[1] == data[1].code) then
				if (source ~= 0) then
					if (data[1].type == "money") then
						xPlayer.addAccountMoney('bank', tonumber(data[1].amount))
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code redeemed successfully! You just recieved: $"..data[1].amount }, color = 255,255,255 })
						MySQL.Async.execute("DELETE FROM RedeemCodes WHERE code = @code;", {
							['@code'] = args[1],
						})
					else
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code redeemed successfully!" }, color = 255,255,255 })
						MySQL.Async.execute("DELETE FROM RedeemCodes WHERE code = @code;", {
							['@code'] = args[1],
						})
					end
				else
					print("Dude you arent supposed to redeem codes as console. Thats against the law.")
				end
			else
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Code!" }, color = 255,255,255 })
				else
					print("Invalid Code")
				end
			end
		end)
	end
end, false)