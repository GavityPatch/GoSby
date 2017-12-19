if GetObjectName(GetMyHero()) ~= "Katarina" then return end

require('Inspired')
require('DeftLib')

local KatarinaMenu = MenuConfig("Katarina", "Katarina")
KatarinaMenu:Menu("Combo", "Combo")
KatarinaMenu.Combo:Boolean("Q", "Use Q", true)
KatarinaMenu.Combo:Boolean("W", "Use W", true)
KatarinaMenu.Combo:Boolean("E", "Use E", true)
KatarinaMenu.Combo:Boolean("R", "Use R", false)
KatarinaMenu:Slider("xR","Ult on X enemies", 3, 1, 5, 1)
KatarinaMenu.Combo:Key("WardJumpkey", "Ward Jump!", string.byte("G"))

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

KatarinaMenu:Menu("JungleClear", "JungleClear")
KatarinaMenu.JungleClear:Boolean("Q", "Use Q", true)
KatarinaMenu.JungleClear:Boolean("W", "Use W", true)
KatarinaMenu.JungleClear:Boolean("E", "Use E", true)

KatarinaMenu:Menu("Lasthit", "Lasthit")
KatarinaMenu.Lasthit:Boolean("Q", "Lasthit with Q", true)

KatarinaMenu:Menu("Laneclear", "Laneclear")
KatarinaMenu.Laneclear:Boolean("Q", "Use Q", false)
KatarinaMenu.Laneclear:Boolean("W", "Use W", false)
KatarinaMenu.Laneclear:Boolean("E", "Use E", false)

KatarinaMenu:Menu("Drawings", "Drawings")
KatarinaMenu.Drawings:Boolean("Q", "Draw Q Range", true)
KatarinaMenu.Drawings:Boolean("W", "Draw W Range", false)
KatarinaMenu.Drawings:Boolean("E", "Draw E Range", true)
KatarinaMenu.Drawings:Boolean("R", "Draw R Range", false)
--True
local GirarR = false
local Dagger = {}
local ArgsW = 0
local spellObj
local kataCounter = 0
local RTime = 0


local Q  = { delay = .25, speed = math.huge , width = nil, range = 625 }
local W  = { delay = .25, speed = 1850      , width = 60 , range = 150 }
local E  = { delay = .25, speed = math.huge , width = nil, range = 700 }
local R  = { delay = .25, speed = math.huge , width = nil, range = 500 }

local function Kat_ProcessSpellComplete(unit, spell)
    if unit == myHero and spell.name == "KatarinaW" then
        ArgsW = GetTickCount()
    end
    if unit == myHero and spell.name == "KatarinaR" then
        RTime = GetTickCount()
    end
end


 local function Kat_UpdateBuff(unit,buff)
        if unit.isMe and buff.Name == "katarinarsound" then 
            IOW.movementEnabled = true
            IOW.attacksEnabled = true
            GirarR = true
        end
end

local function Kat_RemoveBuff(unit,buff)
        if unit.isMe and buff.Name == "katarinarsound" then
            IOW.movementEnabled = false
            IOW.attacksEnabled = false
            GirarR = false
     end
end

local function Kat_OnSpellID(castProc)
	if GirarR == true and castProc.spellID == 1 then
		BlockCast()
	end
end

local function Kat_OnCreateObj(Object) 
    if GetObjectBaseName(Object) == "HiddenMinion" then
    table.insert(Dagger, Object)
    DelayAction(function() table.remove(Dagger, 1) end, 6900)
    end
end

local function CalcDmg(spell, target)
	local dmg={
	[_Q] = 60+20*GetCastLevel(myHero, _Q)+GetBonusDmg(myHero),
    [_W] = 40+10*GetCastLevel(myHero, _W)+GetBonusDmg(myHero),
    [_Q] = 60+20*GetCastLevel(myHero, _Q)+GetBonusDmg(myHero),
	[_R] = 40+40*GetCastLevel(myHero, _R)+GetBonusDmg(myHero),
}
return dmg[spell]
end

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

local function CastQ(target)
    if Ready(_Q) and ValidTarget(target, Q.range) then
        CastTargetSpell(target, _Q)
    end
end

local function CastW(target)
    if Ready(_W) and ValidTarget(target, W.range) then
        CastSpell(_W)
    end
end

local function CastE(target)        
        if Ready(_E) and ValidTarget(target, E.range) then
            for i,v in pairs(Dagger) do
                if GetDistance(target,v) < 350 and GetDistance(v) < 1200 then
                    CastSkillShot(_E,GetOrigin(target) + (VectorWay(GetOrigin(target),GetOrigin(v))):normalized()*math.random(100,150))
                elseif GetDistance(target,v) < 200 and GetDistance(target) < 800 then
                    CastSkillShot(_E,GetOrigin(target))
                end
            end
            if GetCurrentHP(target) < CalcDamage(myHero,target,(GetBaseDamage(myHero)+GetBonusDmg(myHero)),15+15*GetCastLevel(myHero,2) + (GetBaseDamage(myHero)+GetBonusDmg(myHero))*0.65 + GetBonusAP(myHero)*0.25) then
                CastSkillShot(_E,GetOrigin(target))
            end
        end
    end

local function CastR(target)
    if KatarinaMenu.Combo.R:Value() and CanUseSpell(myHero, _Q) ~= READY and CanUseSpell(myHero, _W) ~= READY and CanUseSpell(myHero, _E) ~= READY and CanUseSpell(myHero, _R)  ~= ONCOOLDOWN and ValidTarget(target, 550) and GetCastLevel(myHero,_R) > 0 then
        CastSpell(_R)
        end
    end


       
       

local function Kat_LastHit(target)
    if Mode() == "LastHit" then
		if target.team ~= myHero.team and ValidTarget(target, Q.range) then
			if KatarinaMenu.Lasthit.Q:Value() then  
				if GetDistance(target) > 250 and GetCurrentHP(target) < CalcDmg(_Q, target) then CastQ(target) elseif GetDistance(target) < 250 and GetCurrentHP(target) < CalcDmg(_Q, target)*1.5 then CastQ(target) end
			end
		end
	end
end


local function Kat_Clear()
    if Mode() == "LaneClear" then
        for _,mobs in pairs(minionManager.objects) do
          if GetTeam(mobs) == MINION_ENEMY then
      if IsReady(_Q) and ValidTarget(mobs, Q.range) then
      CastTargetSpell(mobs, _Q)
      end
      
             if IsReady(_W) and ValidTarget(mobs, W.range) then
            CastSpell(_W)
          end
       end
    end
   end
end
             

local function Kat_Combo(target)
    if IOW:Mode() == "Combo" and not GirarR then 

        if GirarR == false then
            if KatarinaMenu.Combo.Q:Value() then CastQ(target) end
            if KatarinaMenu.Combo.W:Value() then CastW(target) end
            if KatarinaMenu.Combo.E:Value() then CastE(target) end
            if KatarinaMenu.Combo.R:Value() then CastR(target) end
        end
    end
end

local function Misc(target)
    for i,enemy in pairs(GetEnemyHeroes()) do
        if Ignite ~= nil then
            if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetHP(enemy)+GetCurrentHP(enemy)*3 and ValidTarget(enemy, 600) then
                CastTargetSpell(enemy, Ignite)
            end
         end
     end
end

local function Kat_Tick(myHero)
    if not myHero.dead then
        local target = GetCurrentTarget()
        Kat_Combo(target)
        Misc(target)
        Kat_Clear(minionManager.objects)
        for _, target in pairs(minionManager.objects) do Kat_LastHit(target) Kat_Clear(target) end
	end
end
 
local function Kat_Draw()
    local pos = GetOrigin(myHero)
    if KatarinaMenu.Drawings.Q:Value() then DrawCircle(pos,625,1,25,GoS.Pink) end
    if KatarinaMenu.Drawings.W:Value() then DrawCircle(pos,150,1,25,GoS.Yellow) end
    if KatarinaMenu.Drawings.E:Value() then DrawCircle(pos,700,1,25,GoS.Blue) end
    if KatarinaMenu.Drawings.R:Value() then DrawCircle(pos,550,1,25,GoS.Green) end
end

OnLoad(function()
	OnTick(Kat_Tick)
	OnDraw(Kat_Draw)
    OnProcessSpell(Kat_ProcessSpell)
    OnProcessSpellComplete(Kat_ProcessSpellComplete)
	OnUpdateBuff(Kat_UpdateBuff)
    OnRemoveBuff(Kat_RemoveBuff)
    OnSpellCast(Kat_OnSpellID)
    OnCreateObj(Kat_OnCreateObj)
    OnDeleteObj(Kat_OnDeleteObj)

    PrintChat(string.format("<font color='#1244EA'>Katarina:</font> <font color='#FFFFFF'> Good Game ! </font>")) 
    PrintChat("DevKat Scripts: " ..GetObjectBaseName(myHero)) 
end)

function VectorWay(A,B)
    WayX = B.x - A.x
    WayY = B.y - A.y
    WayZ = B.z - A.z
    return Vector(WayX, WayY, WayZ)
 end