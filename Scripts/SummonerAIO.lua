---------------Auto Activating Servitor Shots / Resummon Servitor Configurations---
RequiredSummonsCount = 3; -- Number on servitor needed, if you cant have more than 1 servitor then you need to change it to 1.
shots = "Beast Soulshot"; --- Shots name that the servitor is Based on
SummonServitorSkillId = 11257; -- Skill Id of the servitor needed, 11257 forSaber Tooth Cougar, 11256 for Summon Armored Bear, 11258	for Summon Soul Reaper, 
---------------Servitor Attack / Skill Use Configurations--------------------------
AttackMobAction = 22; --AttackType: 22 for servitors, 16 for pets.
actionid = 1109; -- if you want you servitors to use any particular skill they have otherwise set it -1, for list of servitor/pets skill Ids check this link: http://forum.l2tower.eu/showthread.php?tid=812
---------------Servitor Healing Configurations-------------------------------------
-- At how much hp % should we heal pets?
minHealthPercent = 70; -- in Percent Value, Put -1 if you dont want servitor auto heals.
-- max distance at which we will look into our pets/servitor HP.
maxDistance = 800;
-- Switch back to previous target after healing or not?
switchBack = true;
-- Use TransferPain MP conditions? 101 obviously will mean dont use transfer pain and 0 will mean try to use it all time.
WhenManaPercentIsOver = 30;
-- next variable is to choose weither to follow your servitors or not. (this does not include following them in case they need heal and out of range)
MoveNearServitors = true;
-- next variable is to choose weither to to stay on spot you are at when you activate the script.
StayOnSpot = false;
--note: obviously if you have StayOnSpot = true then its automatic the MoveNearServitors will be ignored.
---------------End of the Configurations-------------------------------------------

function isTransferPainNeedActivation()
	if (me:GetMpPercent() > WhenManaPercentIsOver) then
		return true;
	end;
	return false;
end;

function GetSummonCount()
	local petlistaround = GetPetList();
	local count = 0;
	for Apet in petlistaround.list do
		if (Apet:GetNickName() == me:GetName()) then
			count = count +1;
		end;
	end;
	return count;
end;

function GetItemAmountByName(name)
	local invList = GetInventory();
	for item in invList.list do
		if (item.Name == name) then
			ShotsDisId = item.displayId;
			return item.ItemNum;
		end;
	end;
	return 0;
end; 

old = nil;
ShotsActivated = false;
MoveStamp = GetTime();
ScriptTargetId = 0;
-- If your char is far from your Servitor that need heal it will try to move near it by aproximation to its current location that depend on the CoordinateDeviationFromTarget
CoordinateDeviationFromTarget = 100;
StartLocation = GetMe():GetLocation();

function CastHeal(skillc,tar)
	if (skillc ~= nil) and (tar ~= nil) then
		if (tar:GetDistance() > 600) and (tar:GetDistance() < 4000) then
			if MoveNearServitors then
				loc = tar:GetLocation();
				lX = loc.X + math.random(-CoordinateDeviationFromTarget, CoordinateDeviationFromTarget);
				lY = loc.Y + math.random(-CoordinateDeviationFromTarget, CoordinateDeviationFromTarget);
				MoveToNoWait(lX, lY, loc.Z);
				MoveStamp = GetTime();
			else
				MoveToUserWithDistance(tar,500,50,true);
			end;
			Sleep(1000);
			return false;
		else			
			if switchBack and (GetTarget() ~= nil) and not ((GetTarget():IsSummon()) and (GetTarget():GetNickName() == me:GetName())) then
				old = GetTarget();
			end;
			if ((GetTarget() == nil) or not (GetTarget():GetId() == tar:GetId())) and not (ScriptTargetId == tar:GetId()) then 
				ClearTargets();
				TargetRaw(tar:GetId());
				ScriptTargetId = tar:GetId();
				Sleep(700);
			end;
			NeedReAttack = 0;
			repeat
				UseSkillRaw(skillc.skillId,false,false);
				Sleep(500);
				while me:IsUsingMagic() do
					Sleep(100);
				end;
				if (not tar:IsAttacking()) then
					--Sleep(500);
					NeedReAttack = NeedReAttack +1;
				end;
			until (tar == nil) or (not tar:IsValid()) or (tar:IsAlikeDeath()) or (tar:GetHpPercent() > minHealthPercent) or (GetTarget() == nil) or not (GetTarget():GetId() == tar:GetId()) or (NeedReAttack > 2)

			if (old ~= nil) then
				local RefreshedOld = GetUserById(old:GetId());
				if (RefreshedOld ~= nil) and (RefreshedOld:IsValid()) and RefreshedOld:CanSeeMe() and not RefreshedOld:IsAlikeDeath() then
					ClearTargets();
					TargetRaw(RefreshedOld:GetId());
					ScriptTargetId = RefreshedOld:GetId();
					old = nil;
				else
					ClearTargets();
					ScriptTargetId = 0;
					old = nil;
				end;
			elseif switchBack then
				ClearTargets();
				ScriptTargetId = 0;
			end;
		end;
	end;
end;

function PetBelongsToMe(pet)
	if me:GetName() == pet:GetNickName() then
		return true;
	end;
	return false;
end;

function GetServitorHealSkill()
	ServitorHealSkill = nil;
	ServitorHealSkill = MySkills:FindById(11302); -- Major Servitor heal
	if (ServitorHealSkill == nil) or not ServitorHealSkill:IsSkillAvailable() then	
		ServitorHealSkill = MySkills:FindById(1127); -- Servitor Heal
	end;
	
	if (ServitorHealSkill == nil) or not ServitorHealSkill:IsSkillAvailable() then	
		ServitorHealSkill = MySkills:FindById(11755); -- Radiant Heal
	end;	
	
	if (ServitorHealSkill == nil) or not ServitorHealSkill:IsSkillAvailable() then	
		ServitorHealSkill = MySkills:FindById(11756); -- Panic Heal
	end;		
	
	if (ServitorHealSkill == nil) or not ServitorHealSkill:IsSkillAvailable() then	
		ServitorHealSkill = MySkills:FindById(1218); --Greater Battle Heal
	end;
	
	if (ServitorHealSkill == nil) or not ServitorHealSkill:IsSkillAvailable() then	
		ServitorHealSkill = MySkills:FindById(1015); -- battle heal
	end;
end;

function MoveToUserWithDistance(user,Distance,Diviation,GetClosest)
	if (GetMe() ~= nil) and (user ~= nil) and not ((user:GetDistance() > Distance -(Diviation/2)) and (user:GetDistance() < Distance + (Diviation/2))) and (user:GetDistance() < 5000) then
		local MyLoc = GetMe():GetLocation();
		local UserLoc = user:GetLocation(); 
		local YQ = MyLoc.Y;
		local YP = UserLoc.Y;
		local XQ = MyLoc.X;
		local XP = UserLoc.X;
		local xdif = XQ-XP;
		local ydif = YQ-YP;
		if (xdif == 0) then
			xdif = 1;
		end;
		if (ydif == 0) then
			ydif = 1;
		end;
		local Mp = ydif/xdif ; -- the inclination of the line 	
		if ((-2*XP-2*Mp*Mp*XP)*(-2*XP-2*Mp*Mp*XP) -4*(Mp*Mp+1)*(Mp*Mp*XP*XP + XP*XP-Distance*Distance) > 0) then
			undersqrt = (-2*XP-2*Mp*Mp*XP)*(-2*XP-2*Mp*Mp*XP) -4*(Mp*Mp+1)*(Mp*Mp*XP*XP + XP*XP-Distance*Distance);
		else
			undersqrt = (-2*XP-2*Mp*Mp*XP)*(-2*XP-2*Mp*Mp*XP) -4*(Mp*Mp+1)*(Mp*Mp*XP*XP + XP*XP+Distance*Distance);
		end;
		local XN1 = math.ceil((-1*(-2*XP-2*Mp*Mp*XP)+math.sqrt(undersqrt))/(2*(Mp*Mp+1)));
		local XN2 = math.ceil((-1*(-2*XP-2*Mp*Mp*XP)-math.sqrt(undersqrt))/(2*(Mp*Mp+1)));
		local YN1 = math.ceil(YP + Mp*(XN1-XP));
		local YN2 = math.ceil(YP + Mp*(XN2-XP));
		if GetDistanceFloat(MyLoc.X,MyLoc.Y,MyLoc.Z,XN1,YN1,UserLoc.Z) > GetDistanceFloat(MyLoc.X,MyLoc.Y,MyLoc.Z,XN2,YN2,UserLoc.Z) then
			if GetClosest then
				MoveToNoWait(XN2,YN2,50 + MyLoc.Z);
			else
				MoveToNoWait(XN1,YN1,50 + MyLoc.Z);
			end;
		else
			if GetClosest then
				MoveToNoWait(XN1,YN1,50 + MyLoc.Z);
			else
				MoveToNoWait(XN2,YN2,50 + MyLoc.Z);
			end;		
		end;
	end;
end;

repeat
	me = GetMe();
	MySkills = GetSkills();
	GetServitorHealSkill();
	NeededHeal = nil;
	if (me ~= nil) and not (me:IsAlikeDeath()) then
	
		-----------------------CheckingMyServitorsQuantity---------------------------
	
		if (GetSummonCount() < RequiredSummonsCount) then
			if (GetSummonCount() == 0) then
				ShotsActivated = false;
			end;
			UseSkillRaw(SummonServitorSkillId,false,false); 
			Sleep(1500);
		end;
		
		--------------------------Summoning Shots/Opening----------------------------	

		if (GetItemAmountByName(shots) < 7*1000) then
			if (GetItemAmountByName(shots) == 0) then
				ShotsActivated = false;
			end;
			if (MySkills:FindById(11316) ~= nil) and (MySkills:FindById(11316):IsSkillAvailable()) then
				UseSkillRaw(11316,false,false);
				Sleep(5000);
			elseif (GetItemAmountByName(shots .. " Compressed Pack") > 0) then
				UseItem(ShotsDisId);
				Sleep(5000);
			end;
		end;

		------------------------ActivatingSummonShots-------------------------------
	 
		if not (ShotsActivated) and (GetSummonCount() > 0) and (GetItemAmountByName(shots) > 5) then
			ActivateSoulShot(ShotsDisId, true);
			ShotsActivated = true;
			Sleep(2000);
		end;
		
		------------------------------Buffs/Skills----------------------------------

		if (MySkills:FindById(1937) ~= nil) and not me:GotBuff(1937) then
			UseSkillRaw(1937,false,false);
			Sleep(3000);
		end;

		if not me:GotBuff(11270) and not me:GotBuff(1262) then
			if isTransferPainNeedActivation() then
				if (MySkills:FindById(11270) ~= nil) and not me:GotBuff(11270) then
					UseSkillRaw(11270,false,false);
					Sleep(3000);
				elseif (MySkills:FindById(1262) ~= nil) and not me:GotBuff(1262) then
					UseSkillRaw(1262,false,false);
					Sleep(3000);
				end;
			end;
		end;
		
		if not me:GotBuff(11288) and not me:GotBuff(1557) then
			if (MySkills:FindById(11288) ~= nil) and not me:GotBuff(11288) then
				UseSkillRaw(11288,false,false);
				Sleep(3000);
			elseif (MySkills:FindById(1557) ~= nil) and not me:GotBuff(1557) then
				UseSkillRaw(1557,false,false);
				Sleep(3000);
			end;
		end;		
		
		if (MySkills:FindById(11269) ~= nil) and (MySkills:FindById(11269):IsSkillAvailable()) and (GetPartyList():GetCount() > 2) then
			UseSkillRaw(11269,false,false);
			Sleep(12000);
		end;
		
		-------------------------ServitorSkills-------------------------------------
		
		target = GetTarget();
		if (target ~= nil) and (me ~= nil) and target:IsMonster() and (GetSummonCount() > 0) and (target:GetDistance() < 4000) then --and (ScriptTargetId == 0)
			if not (target:IsAlikeDeath()) then
				if (actionid > 0) then
					Action(actionid,false,false);
					Sleep(150);
				end;
				Action(AttackMobAction, false, false);
				Sleep(150);
			elseif (ScriptTargetId == target:GetId()) then
				ClearTargets();
			end;
		end;
		
		--------------------------HealingServitors----------------------------------
		
		if (ServitorHealSkill ~= nil) then
			pets = GetPetList();
			CurrentCriticalHP = minHealthPercent;
			for pet in pets.list do
				if (pet:GetDistance() < maxDistance) and PetBelongsToMe(pet) and (pet:GetHpPercent() <= CurrentCriticalHP) and not pet:IsAlikeDeath() then
					NeededHeal = pet;
					CurrentCriticalHP = pet:GetHpPercent();
				end;
			end;
			if (NeededHeal ~= nil) then
				CastHeal(ServitorHealSkill, NeededHeal);
			elseif StayOnSpot then
				if (GetDistanceVector(StartLocation,me:GetLocation()) > 60) and (GetDistanceVector(StartLocation,me:GetLocation()) < 2500) then
					MoveToNoWait(StartLocation);
				end;
			elseif MoveNearServitors then
				target = GetTarget();
				if not IsPaused() and (target ~= nil) and not (target:IsAlikeDeath()) and (target:GetDistance() < 8000) and (target:GetDistance() > 600) and (MoveStamp + 4000 < GetTime()) then
					loc =  GetTarget():GetLocation();
					lX = loc.X + math.random(-300, 300);
					lY = loc.Y + math.random(-300, 300);
					MoveToNoWait(lX, lY, loc.Z);
					MoveStamp = GetTime();
				end;
			end;
		end;
	end;
	Sleep(500);
until false;
