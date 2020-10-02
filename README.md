# FiveM-RedeemCodes
Simple resource for fivem for making codes that players can redeem and use to get rewards.
This is my first public resource so it will probably be broken in some way. If you find any bugs/want to improve this resource you can either make a pull request/make a request in "Issues" or customise this resource to your liking.

If you do decide to customise it on your own then please be sure to credit me. Thanks and enjoy this resource.

***REQUIREMENTS***
- ES_EXTENDED (1.1.0 is prefered but it should work on most of the versions)
- ASYNC (https://github.com/esx-framework/async/releases) [ You Shoud Already have this ]
- MYSQL-ASYNC (https://github.com/brouznouf/fivem-mysql-async/releases) [ You Shoud Already have this ]

***Commands***
- genCode (type) (amount) [Example: genCode money 2000 (This will generate a code that will give the person 2000 ingame currency)]
- redeem (code) [Example: /redeem ThisIsJustADemoCode (This will check if that code exists, if it does then it will reward the money to the player) (TRIGGER FROM INGAME WITH /redeem (code))]

***Other***
- genCode command only works from the console. If you want to generate the codes from ingame then be sure to add ace permissions to the user/group you want to have acces to this command. 
[
  - Allow access to all admins: add_ace group.admin "RedeemCodes.genCode" allow
  - Allow access to specific individual: add_ace identifier.steam:steam_identifier_here "RedeemCodes.genCode" allow
]
