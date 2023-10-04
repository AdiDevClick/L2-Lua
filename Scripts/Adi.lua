tempId = 0

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
local BTM		 = 0
local Wizzard 	 = 0


SingleNuke = 
			GetSkillIdByName("Elemental Destruction", skills) or
			GetSkillIdByName("Elemental Crash", skills) or
			GetSkillIdByName("Elemental Spike", skill)
AOESkill    =
			GetSkillIdByName("Elemental Storm", skills) or
			GetSkillIdByName("Elemental Blast", skills) 
SingleCurse =
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
			
function MobsCount(range)
 mobs = GetMonsterList()
 i=0
 for m in mobs.list do
     if m:GetDistance() <= range and m:GetHpPercent() ~= 0 then
         i = i+1
     end
 end
 return i
end

--------------------------------------------------------------------------------
repeat
	if not IsPaused() then
		local Me = GetMe()		
		if (Me:IsAlikeDeath() == false) and (Me ~= nil) then
			----------------------------------- spoil
				if (GetTarget() ~= nil)then
					if(GetTarget():IsMonster()) 
						and (GetTarget():GetHpPercent() > 0 )
						and (Me:GetRangeTo(GetTarget()) <= 900) 
						and (Me:GetMpPercent() > 10 ) 
						and (Me:GetHpPercent() > 40 ) 
						and not Me():IsBlocked(true)
						and (GetTarget():GetId() ~= tempId)then
						CastBuff(SingleNuke, ID(), 900)
					end;
				end;
			
				if (Me:GetMpPercent() < 90 ) then
					CastBuff(BTM)
				end;
			
				if (Me:GetMpPercent() > 10 )
					and Me:IsInCombat() == true then
					CastBuff(Wizzard)
				end;
			
			
						
				if (GetTarget() ~= nil)then
					if(GetTarget():IsMonster()) 
						and (GetTarget():GetHpPercent() > 90 )
						and MonstersInRange(900)
						or (Me:GetRangeTo(GetTarget()) <= 900)
						and (Me:GetMpPercent() > 10 ) 
						and not Me():IsBlocked(true)
						and (GetTarget():GetId() ~= tempId) then
						CastBuff(SingleCurse)
					end
				end;		
			end;
		end;
until false	



