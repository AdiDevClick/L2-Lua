local NukeHP = 0
local CurseHP = 90
local AoeHP = 90
local searchRadius = 1000


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

local SingleNuke = 0
local AOESkill   = 0
local SingleCurse= 0
local AOECurse   = 0
local Wizzard    = 0
local BTM 		 = 0

SingleNuke  = 
			GetSkillIdByName("Elemental Destruction", skills) 
SingleNuke2 =
			GetSkillIdByName("Elemental Crash", skills)
SingleNuke3 =
			GetSkillIdByName("Elemental Spike", skill)
AOESkill    =
			GetSkillIdByName("Elemental Storm", skills) or
			GetSkillIdByName("Elemental Blast", skills) 
SingleCurse    =
			GetSkillIdByName("Devil's Curse", skills)
AOECurse    =
			GetSkillIdByName("Mass Devil's Curse", skills)
BTM			=
			GetSkillIdByName("Ultimate Body To Mind", skills)
Wizzard 	=
			GetSkillIdByName("Wizzard Spirit", skills) or
			GetSkillIdByName("Double Casting", skills) 

function CastBuff(id)
 if id then
	 local skill = GetSkills():FindById(id)
	 if skill and skill:CanBeUsed() then
		 UseSkillRaw(id,false,false)
		 return true
	 end
 end
 return false
end			
			
			
function CastSpell(id,tar,dist)
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


function ProcessNukeTarget(mob, sN, cS, aoeS, HPTreshold, mobHPTreshold, AoeHPTreshold, searchRadius )
	if mob and mob:GetDistance() <= 1000 then
				-- SingleNuke
		if  mob:GetHpPercent() > HPTreshold and
			mob:IsMonster() and 
			GetMe():GetMpPercent() > 10 then
			sN[sN[0].n + 1] = mob
			if not sN[0].u or mob:GetHpPercent() > sN[0].hp then
				sN[0].id = mob:GetId()
				sN[0].u = mob
				sN[0].hp = mob:GetHpPercent()
			end
			sN[0].n = sN[0].n + 1
		end

				--Body To Mind
		if  GetMe():GetMpPercent() <= 90  then
			CastBuff(BTM)
		end;
			
				--Wizzard Spirit
		if (GetMe():GetMpPercent() > 10 ) and
			GetMe():IsInCombat() == true then
			CastBuff(Wizzard)
		end;
	
				-- CurseSkill
		if mob:GetHpPercent() > mobHPTreshold and
			mob:IsMonster() and 
			GetMe():GetMpPercent() >= 10 and not
			GetMe():IsBlocked(true) and
			GetMe():GetHpPercent() > 50 then
			cS[cS[0].n + 1] = mob
			if not cS[0].u or mob:GetHpPercent() > cS[0].hp then
				cS[0].id = mob:GetId()
				cS[0].u = mob
				cS[0].hp = mob:GetHpPercent()
			end
			cS[0].n = cS[0].n + 1
		end
		
				-- AOESkill
		if mob:GetHpPercent() <= AoeHPTreshold then
			aoeS[aoeS[0].n + 1] = mob
			if not aoeS[0].u or mob:GetHpPercent() < aoeS[0].hp then
				aoeS[0].id = mob:GetId()
				aoeS[0].u = mob
				aoeS[0].hp = mob:GetHpPercent()
			end
			aoeS[0].n = aoeS[0].n + 1
		end
	end
	return sN, cS, aoeS
end

function GetNukeTargets( HPTreshold, mobHPTreshold, AoeHPTreshold, searchRadius )

	local mobs = GetMonsterList()
	i=0	
	
	local sN = {} -- Need Heal
	sN[0] = {}
	sN[0].n = 0
	local cS = {} -- Need Heal
	cS[0] = {}
	cS[0].n = 0
	local aoeS = {} -- Need Heal
	aoeS[0] = {}
	aoeS[0].n = 0

	for mob in mobs.list do
		if mob:GetDistance() <= 900 and mob:IsAlikeDeath() == false then
			i = i+1
		end
		sN, cS, aoeS = ProcessNukeTarget(mob, sN, cS, aoeS, HPTreshold, mobHPTreshold, AoeHPTreshold, searchRadius)
	end
	return sN, cS, aoeS, i
end




function TickHeal()
	local sN, cS, aoeS = GetNukeTargets( NukeHP, CurseHP, AoeHP, 1000)
		
			if sN[0].n and sN[0].n > 0 and 
			CastSpell(SingleNuke, sN[0].u, 900) then
			else
			if sN[0].n and sN[0].n > 0 and 
			CastSpell(SingleNuke2, sN[0].u, 900) then
			else
			
			if sN[0].n and sN[0].n > 0 and 
			CastSpell(SingleNuke3, sN[0].u, 900) then
			return
		end
		
			
			
			if cS[0].n and cS[0].n > 0 and 
			CastSpell(SingleCurse, cS[0].u, 900) then
			return
			end
			

			end	
		----------------------------------- spoil
	end
end


repeat
	if not IsPaused() then
		TickHeal()
	end
	Sleep(400)
until false