-- Health % to consider target for Group Heal spells
local HealHP = 80

local SearchRadius = 1000


------------------------------------------------
------------ END OF USER SETTINGS --------------
------------------------------------------------
function GetSkillIdByName(name)
	return GetSkillIdByName(name,nil)
end
function GetSkillIdByName(name,skills)
	if not skills then
		skills = GetSkills()
	end
	for s in skills.list do
		if s.name == name then
			return s.skillId
		end
	end
	return nil
end


local Heal 		= 0


function UpdateSkills(inv)
	local skills = GetSkills()
	Heal =
		GetSkillIdByName("Healing Melody", skills)		
end
UpdateSkills(GetInventory())


function CastHeal(id,tar,dist)
 if id and tar then
	 local skill = GetSkills():FindById(id)
	 if skill and skill:CanBeUsed() then
		for d=dist-50,50,-100 do
			if not tar or tar:GetHpPercent() == 0 then
				return false
			end
			if tar:GetDistance() > dist or not tar:CanSeeMe() then
				local loc = tar:GetLocation()
				MoveTo(loc.X, loc.Y, loc.Z, d)
				local tar = GetUserById(tar:GetId())
			end
		end
		 --old = GetTarget()
		 Target(tar)
		 UseSkillRaw(id,false,false)
		 if old then
			Sleep(300)
			Target(old)
		 end
		 return true
	 end
 end
 return false
end


function ProcessHealingTarget(p, nH, HPTreshold, searchRadius )
		if p:GetHpPercent() < HPTreshold and
					(p:GotBuff(11758) == false or
					p:GotBuff(11759) == false) and
					p:IsAlikeDeath() == false then
				nH[nH[0].n + 1] = p
				if not nH[0].u or p:GetHpPercent() < nH[0].hp then
					nH[0].id = p:GetId()
					nH[0].u = p
					nH[0].hp = p:GetHpPercent()
				end
				nH[0].n = nH[0].n + 1
			end
	return nH
end

function GetHealingTargets( HPTreshold, searchRadius )
	local party = GetPartyList()
	partyInfo = { 
		count = 0,
		avg = 0,
		low = 100,
	}
	local nH = {} -- Need Heal
	nH[0] = {}
	nH[0].n = 0
	
	for p in party.list do
		hpp = p:GetHpPercent()
		if hpp > 0 then
			partyInfo.count = partyInfo.count + 1
			partyInfo.avg = (partyInfo.avg * (partyInfo.count - 1) + hpp) / partyInfo.count
			if partyInfo.low > hpp then
				partyInfo.low = hpp
			end
		end
	nH = ProcessHealingTarget(p, nH, HPTreshold, searchRadius)
end
	
	p = GetMe()
	if p then
		hpp = p:GetHpPercent()
		if hpp > 0  then
			partyInfo.count = partyInfo.count + 1
			partyInfo.avg = (partyInfo.avg * (partyInfo.count - 1) + hpp) / partyInfo.count
			if partyInfo.low > hpp then
				partyInfo.low = hpp
			end
		end
	nH = ProcessHealingTarget(p, nH, HPTreshold, searchRadius)
end
	
	if HealPartyPets then
		pets = GetPetList()
		for p in pets.list do
			if PetBelongsToParty( pet ) then
				nH = ProcessHealingTarget(p, nH, HPTreshold, searchRadius)
			end
		end
	end
	
	return nH
end

function MobsCount(range)
 local mobs = GetMonsterList()
 local i=0
 for m in mobs.list do
	 if m:GetDistance() <= range and m:GetHpPercent() ~= 0 then
		 i = i+1
	 end
 end
 return i
end

function TickHeal()
	local nH, pI = GetHealingTargets(HealHP, 1000)
		if nH[0].n and nH[0].n > 0 and
		CastHeal(Heal,nH[0].u, 900) then
		return
	end
end

local counter = 0
repeat
	if not IsPaused() then
		TickHeal()
		if Counter == 0 then
			UpdateSkills(GetInventory())
		end
		counter = (counter + 1) % 20
	end
	Sleep(400)
until false
