if GetObjectName(GetMyHero()) ~= "Ornn" then return end


require('Inspired')
require('DeftLib')
require('DamageLib')

local ver 2.0

local OrnnMenu = MenuConfig("Ornn", "Ornn")
OrnnMenu:Menu("Combo", "Combo")
OrnnMenu.Combo:Boolean("Q", "Use Q", true)
OrnnMenu.Combo:Boolean("W", "Use W", true)
OrnnMenu.Combo:Boolean("E", "Use E", true)
OrnnMenu.Combo:Boolean("R", "Use R", true)

local Stealth = false
local EHitRadius = 350
local UltIsChargingIn => GetMyHero.SpellBook.GetSpell(SpellBook.R).Name == "OrnnRCharge" || Game.TickCount - LastRCast < 5000;
local LastRCast = Game.TickCount - 5000;
local Q  = { delay = .25, speed = math.huge , width = nil, range = 800 }
local W  = { delay = .25, speed = 1850      , width = 60 , range = 550 }
local E  = { delay = .25, speed = math.huge , width = nil, range = 800 }
local R  = { delay = .25, speed = math.huge , width = nil, range = 2500 }

OnObjectLoad(function(Object)
    local Obj_AI_Hero Player => GetObjectName.Player;
    local Vector3 GetWalls(this List<Vector3> points, Object target)
    return points.Select(x => GetFirstWall(target.ServerPosition, x)).Where(x => x != Vector3.Zero).ToList();
    
   if Vector3 GetFirstWall(Vector3 start, Vector3 end) then
        local wallPos = Vector3.Zero;
        local distDividend = (start - end) / 20;
        for (i = 0; i < 20; i++) then
        
            local tempPos = start + (distDividend * i);
            if (!tempPos.IsWall())
                continue;
            wallPos = tempPos;
            break;
        end
        return wallPos;
    end
    local Object GetNearestPillar(Obj_AI_Base target) then
    return GetObjectName.AllyMinions.Where(x => x.Distance(target) <= EHitRadius and x.Name == "OrnnQPillar" && !x.IsDead).OrderBy(x => x.Distance(target)).FirstOrDefault();
    end
end)


OnProcessSpell(function(unit, spell)
    if unit.IsMelee && spell.SpellSlot == SpellSlot.R && spell.SpellData.Name == "OrnnR")
    LastRCast = Game.TickCount;
end) 

OnTick(function(myHero)

    local target = GetCurrentTarget()
    local Qtarget = target1:GetTarget()
    local Wtarget = target2:GetTarget()
    local Rtarget = target3:GetTarget()
    local pillar = OnObjectLoad:GetNearestPillar(target);
    local wallsAroundTarget = target:ServerPosition.RotateAround(EHitRadius, 90).GetWalls(target);
    local bestWall = wallsAroundTarget:Where(x => x.Distance(Player) <= E.Range).OrderBy(x => x.Distance(target)).FirstOrDefault();
    local wallBetweenUs = WallManager:GetFirstWall(Player.ServerPosition, target.ServerPosition);

    if IOW:Mode() == "Combo" then

    if OrnnMenu.Combo.W:Valune() and target.Distance(Player) <= W.range and W.IsReady then
    !target.HasBuff("OrnnVulnerableDebuff")
            Cast(W,Wtarget);
        return;
    end
    if OrnnMenu.Combo.Q:Valune() and target.Distance(Player) <= Q.range and Q.IsReady then
    if E.IsReady and Q.IsReady then Cast(Q,Qtarget);
        else if Q.IsReady then
            Cast(Q,Qtarget);
        return;
        end
    end
    if OrnnMenu.Combo.E:Valune() and E.IsReady then
        if pillar.Distance(Player) <= E.Range then
            Cast(E,pillar.ServerPosition);
        else
            if bestWall == Vector.Zero
                return;
            if wallBetweenUs != Vector.Zero)
                return;
            Cast(E,bestWall);
        end
    end
end

OnUpdateBuff(function(unit,buff)
	if unit.isMe and buff.Name:lower() == "OrnnVulnerableDebuff" then
		Stealth = true
	end
end

OnRemoveBuff(function(unit,buff)
    if unit.isMe and buff.Name:lower() == "OrnnVulnerableDebuff" then
		Stealth = false
	end
end

PrintChat(string.format("<font color='#1244EA'>Ahri:</font> <font color='#FFFFFF'> By Deftsu Loaded, Have A Good Game ! </font>")) 
PrintChat("Have Fun Using D3Carry Scripts: " ..GetObjectBaseName(myHero)) 
        