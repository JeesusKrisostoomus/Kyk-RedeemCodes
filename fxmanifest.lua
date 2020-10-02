fx_version 'cerulean'
games { 'gta5' }

author 'Jeesus Krisostoomus#7737'
description 'https://github.com/JeesusKrisostoomus/FiveM-RedeemCodes'

server_scripts {
    	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
    	'server.lua'
}
shared_scripts {
    	'config.lua'
}

dependencies {
	'async',
    	'mysql-async'
}
