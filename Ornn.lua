if GetObjectName(GetMyHero()) ~= "Ornn" then return end


require('Inspired')
require('DeftLib')
require('DamageLib')

local OrnnMenu = MenuConfig("Ornn", "Ornn")
OrnnMenu:Menu("Combo", "Combo")
OrnnMenu.Combo:Boolean("Q", "Use Q", true)
OrnnMenu.Combo:Boolean("W", "Use W", true)
OrnnMenu.Combo:Boolean("E", "Use E", true)
OrnnMenu.Combo:Boolean("R", "Use R", true)

PrintChat(string.format("<font color='#1244EA'>Ahri:</font> <font color='#FFFFFF'> By Deftsu Loaded, Have A Good Game ! </font>")) 
PrintChat("Have Fun Using D3Carry Scripts: " ..GetObjectBaseName(myHero)) 
        