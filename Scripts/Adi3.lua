
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


Spike = GetSkillIdByName("Elemental Spike", skill)

Destruction = 
		GetSkillIdByName("Elemental Destruction", skill)

Crash = 
		GetSkillIdByName("Elemental Crash", skill)

AOESkill =
			GetSkillIdByName("Elemental Storm", skills) 
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
			
function Nuke()    
 if
     GetMe():GetMpPercent() > 10 and
     (
         MobsCount(1500) > 1 and 
         (
             CastBuff(Destruction) or 
             CastBuff(Spike) or
             CastBuff(Crash)
         ) or
         CastBuff(CA) or 
         CastBuff(DS) or 
         CastBuff(SB) or 
         CastBuff(MCA) or 
         CastBuff(MSB)
     )
     then return
 end
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

    if not IsPaused() then
        tar = GetTarget()
        if  GetMe():GetMp() > 100 and
            not GetMe():IsBlocked(true) and
            tar and 
            tar:GetDistance() < 1500 then
            Nuke()
        end
    end
