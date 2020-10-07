local oldPrint = print
print = function(trash)
	oldPrint('^7[^2Redeem Codes^7] '..trash..'^0')
end

ESX = nil 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local RandomCode = ""

function RandomCodeGenerator()
	if Config.numericGenerator then
		RandomCode = math.random(Config.minNumber, Config.maxNumber)
		return RandomCode
	elseif Config.alphanumericGen then
		local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
		local length = Config.length
	
		charTable = {}
		for c in chars:gmatch"." do
			table.insert(charTable, c)
		end
	
		for i = 1, length do
			RandomCode = RandomCode .. charTable[math.random(1, #charTable)]
		end
	
		return RandomCode
	else
		print("^1No valid generator method selected.")
	end
	
end

RegisterCommand("genCode", function(source, args, rawCommand)
	if (Config.numericGenerator == false and Config.alphanumericGen == false) then
		if (source ~= 0) then
			TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "No valid generation method selected. Check if the config is setup correctly." }, color = 255,255,255 })
		else
			print("^1Please select a valid generation method from the config first.")
		end
	else
		if (string.lower(args[1]) == "bank") then
			if (args[2] == nil) then
				if (source == 0) then
					print("Invalid arguments")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments." }, color = 255,255,255 })
				end
			else
				MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, amount) VALUES (@code,@type,@amount)", {
					['@code'] = RandomCodeGenerator(),
					['@type'] = "bank", 
					['@amount'] = args[2]
				})
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code generated successfully! Check the database to see the code." }, color = 255,255,255 })
				else
					if RandomCode ~= nil and RandomCode ~= "" then
						print("Code Generated Successfully! Code: "..RandomCode)
					end
				end
				Wait(5)
				RandomCode = ""
			end
		elseif (string.lower(args[1]) == "cash") then
			if (args[2] == nil) then
				if (source == 0) then
					print("Invalid arguments")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments." }, color = 255,255,255 })
				end
			else
				MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, amount) VALUES (@code,@type,@amount)", {
					['@code'] = RandomCodeGenerator(),
					['@type'] = "cash", 
					['@amount'] = args[2]
				})
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code generated successfully! Check the database to see the code." }, color = 255,255,255 })
				else
					if RandomCode ~= nil and RandomCode ~= "" then
						print("Code Generated Successfully! Code: "..RandomCode)
					end
				end
				Wait(5)
				RandomCode = ""
			end
		elseif (string.lower(args[1]) == "item") then
			MySQL.Async.fetchAll('SELECT * FROM `items` WHERE `name` = @name', {
				['@name'] = args[2]
			}, function(data2)
				if (data2[1].name ~= string.lower(args[2])) then
					if (source == 0) then
						print("Invalid item")
					else
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid item." }, color = 255,255,255 })
					end
				else
					if (args[2] == nil) then
						if (source == 0) then
							print("Invalid arguments")
						else
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments." }, color = 255,255,255 })
						end
					else
						MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, item, count) VALUES (@code,@type,@item,@count)", {
							['@code'] = RandomCodeGenerator(),
							['@type'] = "item",
							['@item'] = string.lower(args[2]),
							['@count'] = args[3]
						})
						if (source ~= 0) then
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code generated successfully! Check the database to see the code." }, color = 255,255,255 })
						else
							if RandomCode ~= nil and RandomCode ~= "" then
								print("Code Generated Successfully! Code: "..RandomCode)
							end
						end
						Wait(5)
						RandomCode = ""
					end
				end
			end)			
		else
			if (source ~= 0) then
				TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Unknown Type. Please make sure u typed everything correctly and that the script is correctly setup." }, color = 255,255,255 })
			else
				print("Unknown Type. Please make sure u typed everything correctly and that the script is correctly setup.")
				print("Templates:\nMoney - genCode bank/cash amount \nItems - genCode item item_spawn_code item_count")
			end
		end
	end
end, true)

RegisterCommand("multiGen", function(source, args, rawCommand)
	if (Config.numericGenerator == false and Config.alphanumericGen == false) then
		print("^1Please select a valid generation method from the config first.")
	else
		if (string.lower(args[1] == "bank")) then
			if (args[2] == nil) then
				if (source == 0) then
					print("Invalid arguments")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments." }, color = 255,255,255 })
				end
			else
				if (args[3] == nil) then args[3] = 0 end --[[ I have no clue why 0 == 1, 1 == 2 but hey whatever.]]
				if (tonumber(args[3]) < 21) then
					for shit=0, args[3]-1 do
						MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, amount) VALUES (@code,@type,@amount)", {
							['@code'] = RandomCodeGenerator(),
							['@type'] = "bank", 
							['@amount'] = args[2]
						})
						print("Code Generated Successfuly! Code: "..RandomCode)
						RandomCode = ""
					end
					if (source ~= 0) then
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Codes generated successfully! Check the database to see the codes." }, color = 255,255,255 })
					else
						print("Codes Generated Successfully!")
					end
				else
					if (source ~= 0) then
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Chill. Lets not crash the database." }, color = 255,255,255 })
					else
						print("Chill. Lets not crash the database.")
					end
				end
			end
		elseif (args[1] == "cash" or args[1] == "Cash") then
			if (args[2] == nil) then
				if (source == 0) then
					print("Invalid arguments")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments." }, color = 255,255,255 })
				end
			else
				if (args[3] == nil) then args[3] = 0 end --[[ I have no clue why 0 == 1, 1 == 2 but hey whatever.]]
				if (tonumber(args[3]) < 21) then
					for shit=0, args[3]-1 do
						MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, amount) VALUES (@code,@type,@amount)", {
							['@code'] = RandomCodeGenerator(),
							['@type'] = "cash", 
							['@amount'] = args[2]
						})
						print("Code Generated Successfuly! Code: "..RandomCode)
						RandomCode = ""
					end
					if (source ~= 0) then
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Codes generated successfully! Check the database to see the codes." }, color = 255,255,255 })
					else
						print("Codes Generated Successfully!")
					end
				else
					if (source ~= 0) then
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Chill. Lets not crash the database." }, color = 255,255,255 })
					else
						print("Chill. Lets not crash the database.")
					end
				end
			end
		elseif (string.lower(args[1] == "item")) then
			if (args[2] == nil) then
				if (source == 0) then
					print("Invalid arguments")
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Arguments." }, color = 255,255,255 })
				end
			else
				if (args[3] == nil) then args[3] = 0 end --[[ I have no clue why 0 == 1, 1 == 2 but hey whatever.]]
				if (args[4] == nil) then args[4] = 0 end --[[ I have no clue why 0 == 1, 1 == 2 but hey whatever.]]
				if (tonumber(args[4]) < 21) then
					for shit=0, args[4]-1 do
						MySQL.Async.execute("INSERT INTO RedeemCodes (code, type, item, count) VALUES (@code,@type,@item,@count)", {
							['@code'] = RandomCodeGenerator(),
							['@type'] = "item", 
							['@item'] = args[2],
							['@count'] = args[3]
						})
						print("Code Generated Successfuly! Code: "..RandomCode)
						RandomCode = ""
					end
					if (source ~= 0) then
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Codes generated successfully! Check the database to see the codes." }, color = 255,255,255 })
					else
						print("Codes Generated Successfully!")
					end
				else
					if (source ~= 0) then
						TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Chill. Lets not crash the database." }, color = 255,255,255 })
					else
						print("Chill. Lets not crash the database.")
					end
				end
			end
		else
			if (source ~= 0) then
				TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Unknown Type. Please make sure u typed everything correctly and that the script is correctly setup." }, color = 255,255,255 })
			else
				print("Unknown Type. Please make sure u typed everything correctly and that the script is correctly setup.")
				print("Templates:\nMoney - genCode bank/cash amount how_many_codes\nItems - genCode item item_spawn_code item_count how_many_codes")
			end
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
			if (json.encode(data) == "[]" or json.encode(data) == "null") then
				if (source ~= 0) then
					TriggerClientEvent('chat:addMessage', source, { args = { '^7[^1Error^7]^2', "Invalid Code!" }, color = 255,255,255 })
				else
					print("You cant redeem codes as console!")
				end
			else
				if (args[1] == data[1].code) then
					if (source ~= 0) then
						if (data[1].type == "bank") then
							xPlayer.addAccountMoney('bank', tonumber(data[1].amount))
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code redeemed successfully! You just recieved: $"..data[1].amount }, color = 255,255,255 })
							MySQL.Async.execute("DELETE FROM RedeemCodes WHERE code = @code;", {
								['@code'] = args[1],
							})
						elseif (data[1].type == "cash") then
							xPlayer.addMoney(data[1].amount)
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code redeemed successfully! You just recieved: $"..data[1].amount.." Cash." }, color = 255,255,255 })
							MySQL.Async.execute("DELETE FROM RedeemCodes WHERE code = @code;", {
								['@code'] = args[1],
							})
						elseif (data[1].type == "item") then
							xPlayer.addInventoryItem(data[1].item, data[1].count)
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code redeemed successfully! You just recieved: "..data[1].count.." of "..data[1].item }, color = 255,255,255 })
							MySQL.Async.execute("DELETE FROM RedeemCodes WHERE code = @code;", {
								['@code'] = args[1],
							})
						else
							TriggerClientEvent('chat:addMessage', source, { args = { '^7[^2Success^7]^2', "Code redeemed successfully! Reward: Unknown" }, color = 255,255,255 })
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
			end
		end)
	end
end, false)

--[[
	Huge thanks to https://github.com/XvenDeR for helping with alot of stuff.
]]