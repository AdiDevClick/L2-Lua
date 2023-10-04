
HPWhenHeal = 99;   -- HP%
HPWhenHeal2 = 60;   -- HP%
MPWhenHeal = 100;   -- MP%
HealInRange = 900;
HealSkillId = 11828; -- Progressive Heal
HealSkillId2 = 11762; -- Balance Heal
MPSkillId = 11760; -- Radiant Recharge
ResSkillId = 11784; -- Blessed Resurrection
HealSkillId2command = "/useskill Balance Heal"
-----------
-----------------------
HealSkill2 = GetSkills():FindById(HealSkillId2);
HealSkill = GetSkills():FindById(HealSkillId);
MPSkill = GetSkills():FindById(MPSkillId);
ResSkill = GetSkills():FindById(ResSkillId);
--------------
function Healer()
		
		local me = GetMe()
		local Party = GetPlayerList();
			Member = nil
		for user in Party.list do	
		
		if me:IsAlikeDeath() == false then
	
				if user:IsMyPartyMember() == true
					and user:GetHpPercent() < HPWhenHeal
					and me:GetRangeTo(user) < HealInRange
					and HealSkill2 ~= nil
					and HealSkill2:CanBeUsed() 
					and user:IsAlikeDeath() == false then
						Member = user
				end
			end
						UseSkill(HealSkillId2); -- Balance Heal
						ClearTargets();
						 CancelTarget(false);
						 CancelTarget(false);
						 CancelTarget(false);
end
end
	