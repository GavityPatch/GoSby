if GetObjectName(GetMyHero()) ~= "Katarina" then return end

require('Inspired')
require('DeftLib')
require('DamageLib')

local dagger = {}
local kataR = false
local daggerHitPos = {}
local resetAble = {}
local animationCancel = {}
local kataCounter = 0
local KatarinaMenu = MenuConfig("Katarina", "Katarina")

KatarinaMenu:Menu("Combo", "Combo")
KatarinaMenu.Combo:Boolean("Q", "Use Q", true)
KatarinaMenu.Combo:Boolean("W", "Use W", true)
KatarinaMenu.Combo:Boolean("E", "Use E", true)
KatarinaMenu.Combo:Boolean("R", "Use R", true)

KatarinaMenu:Menu("Harass", "Harass")
KatarinaMenu.Harass:Boolean("Q", "Use Q", true)
KatarinaMenu.Harass:Boolean("W", "Use W", true)
KatarinaMenu.Harass:Boolean("E", "Use E", true)
 
KatarinaMenu:Menu("Killsteal", "Killsteal")
KatarinaMenu.Killsteal:Boolean("SmartKS", "Smart KS", true)
KatarinaMenu.Killsteal:Boolean("UseWards", "Use Wards", true)

if Ignite ~= nil then
KatarinaMenu:Menu("Misc", "Misc")
KatarinaMenu.Misc:Boolean("Autoignite", "Auto Ignite", true)
end

KatarinaMenu:Menu("Lasthit", "Lasthit")
KatarinaMenu.Lasthit:Boolean("Q", "Lasthit with Q", false)

KatarinaMenu:Menu("Drawings", "Drawings")
KatarinaMenu.Drawings:Boolean("Q", "Draw Q Range", true)
KatarinaMenu.Drawings:Boolean("E", "Draw E Range", true)
KatarinaMenu.Drawings:Boolean("D", "Draw Dagger", true)

local Q  = { delay = .25, speed = math.huge , width = nil, range = 625 }
local W  = {}
local E  = { delay = .25, speed = math.huge , width = nil, range = 725 }
local R  = { delay = .25, speed = math.huge , width = nil, range = 500 }
local P  = { range = 350 }

OnCreateObj(function(Object)
	if GetDistance(Object) < 2500 then
		if Object.name == "HiddenMinion" and GetDistance(Object) < 340 then
			table.insert(dagger, Object)
		end
		if Object.name == "HiddenMinion" then
			table.insert(daggerHitPos, Object)
			local delay = 0.2
			if GetDistance(Object) < 50 then
				delay = 0
			end
			DelayAction(function()
				table.insert(resetAble, Object)
			end,1.1 - delay)
		end
	end
end)

OnDeleteObj(function(Object)
	if Object.name == "HiddenMinion" then
		for i,v in pairs(dagger) do
			if GetNetworkID(v) == GetNetworkID(Object) then
				table.remove(dagger,i)
			end
		end
	end
	if Object.name == "HiddenMinion" then
		for i,v in pairs(resetAble) do
			if GetNetworkID(v) == GetNetworkID(Object) then
				table.remove(resetAble,i)
			end
		end
		for i,v in pairs(daggerHitPos) do
			if GetNetworkID(v) == GetNetworkID(Object) then
				table.remove(daggerHitPos,i)
			end
		end
	end
end)

local function Mode()
    if IOW_Loaded then 
        return IOW:Mode()
    elseif DAC_Loaded then 
        return DAC:Mode()
    elseif PW_Loaded then 
        return PW:Mode()
    elseif GoSWalkLoaded and GoSWalk.CurrentMode then 
        return ({"Combo", "Harass", "LaneClear", "LastHit"})[GoSWalk.CurrentMode+1]
    elseif AutoCarry_Loaded then 
        return DACR:Mode()
    elseif _G.SLW_Loaded then 
        return SLW:Mode()
    elseif EOW_Loaded then 
        return EOW:Mode()
    end
    return ""
end

local function Lane()
    if Mode() == "LaneClear" then
        for _,mobs in pairs(minionManager.objects) do
          if GetTeam(mobs) == MINION_ENEMY then
      if IsReady(_Q) and ValidTarget(mobs, Q.range) then
      CastTargetSpell(mobs, _Q)
      end
      
      if IsReady(_W) and ValidTarget(mobs, P.range) then
      CastSpell(_W)
      end
    end
end
end
end
              
OnDraw(function()
    for _,W in pairs(resetAble) do
    if not W.dead then DrawCircle(GetOrigin(W),340,2,255,GoS.White) DrawText(_T,30,WorldToScreen(0, GetOrigin(W)).x-7 ,WorldToScreen(0, GetOrigin(W)).y-20, GoS.Red) end 
end
end)

local function Combo_Kat(target)
    if Mode() == "Combo" then
        local gun = GetItemSlot(myHero,3146)
        if gun >= 1 and ValidTarget(target,550) then
            if CanUseSpell(myHero,gun) == READY then
                CastTargetSpell(target,gun)
            end
        end
        if IsReady(_Q) and KatarinaMenu.Combo.Q:Value() and ValidTarget(target, Q.range) then
            CastTargetSpell(target, _Q)
            end
            if IsReady(_W) and KatarinaMenu.Combo.W:Value() and ValidTarget(target, 200) then
                CastSpell(_W)
                end
                for _, enemy in pairs(GetEnemyHeroes()) do
                    for i,v in pairs(resetAble) do
                if IsReady(_E) and KatarinaMenu.Combo.E:Value() and
					 GetDistance(target,v) < 350 and GetDistance(v) < 1200 then
						CastSkillShot(_E,GetOrigin(target) + (VectorWay(GetOrigin(target),GetOrigin(v))):normalized()*math.random(100,150))
					elseif GetDistance(target,v) < 200 and GetDistance(target) < 800 then
						CastSkillShot(_E,GetOrigin(target) + (VectorWay(GetOrigin(target),GetOrigin(v))):normalized()*math.random(200,350))
                    end
                end
            end
        end
    end



    OnProcessSpell(function(unit,spell)
        if unit == myHero and spell.name == "KatarinaR" then
            kataR = true
        end
    end)

        OnUpdateBuff(function(unit,buff)
            if not unit or not buff then return end
            if unit == myHero and buff.Name == "katarinarsound" then
                kataR = true
            end
        end)
        
        OnRemoveBuff(function(unit,buff)
            if not unit or not buff then return end
            if unit == myHero and buff.Name == "katarinarsound" then
                kataR = false
            end
        end)   


OnSpellCast(function(castProc)
	if kataR == true and castProc.spellID == 1 then
		BlockCast()
	end
end)

local function Misc(target)
    for i,enemy in pairs(GetEnemyHeroes()) do
    if Ignite ~= nil then
        if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetHP(enemy)+GetCurrentHP(enemy)*3 and ValidTarget(enemy, 600) then
            CastTargetSpell(enemy, Ignite)
            end
          end
        end
    end

OnTick(function(myHero)
    local target = GetCurrentTarget()
    Combo_Kat(target)
    Lane()
    Misc(target)
end)
    
PrintChat(string.format("<font color='#1244EA'>Katarina:</font> <font color='#FFFFFF'> By Deftsu Loaded, Have A Good Game ! </font>")) 
PrintChat("Have Fun Using D3Carry Scripts: " ..GetObjectBaseName(myHero)) 


function VectorWay(A,B)
    WayX = B.x - A.x
    WayY = B.y - A.y
    WayZ = B.z - A.z
    return Vector(WayX, WayY, WayZ)
end
