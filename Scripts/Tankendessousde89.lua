TankStatus = false;
tankonspot = false;
pvp = false;
AuraOfHateRdy = GetTime();
AgressionRdy = GetTime();
ShieldStrike = GetTime(); 
GustBlade = GetTime();
GalaxyChain = GetTime();
movestamp = GetTime();
outspot = nil;
myptidpetlist =	{} ;
AllowedMass = GetTime() + 40000;

function OnCreate()
	this:RegisterCommand("tank", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
	this:RegisterCommand("tankonspot", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
	this:RegisterCommand("pvp", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
	this:RegisterCommand("outspot", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
end;

function OnCommand_tank(vCommandChatType, vNick, vCommandParam)
	if (TankStatus == false) then
		TankStatus = true;
		FarmPoint = GetMe():GetLocation();
		retreat = false;
		ShowToClient("Tank Plugin","Tanking Is Activated.");
	else
		TankStatus = false;
		tankonspot = false;
		retreat = false;
		ShowToClient("Tank Plugin","Tanking Is Is Deactivated.");	
	end;
end;

function OnCommand_outspot(vCommandChatType, vNick, vCommandParam)
	if (outspot == nil) then
		outspot = GetMe():GetLocation();
		ShowToClient("Tank Plugin","Safe Position is saved.");
	else
		outspot = nil;
		ShowToClient("Tank Plugin","Safe Position is removed.");
	end;
end;

function OnCommand_pvp(vCommandChatType, vNick, vCommandParam)
	if (pvp == false) then
		pvp = true;
		retreat = false;
		ShowToClient("Tank Plugin","Switched to PvP Tank Mode.");
	else
		pvp = false;
		retreat = false;
		ShowToClient("Tank Plugin","Switched to PvE Tank Mode.");	
	end;
end;

function OnCommand_tankonspot(vCommandChatType, vNick, vCommandParam)
	if (TankStatus == false) then
		TankStatus = true;
		tankonspot = true;
		retreat = false;
		FarmPoint = GetMe():GetLocation();
		ShowToClient("Tank Plugin","Tanking Is Activated.");
	else
		TankStatus = false;
		tankonspot = false;
		retreat = false;
		ShowToClient("Tank Plugin","Tanking Is Is Deactivated.");	
	end;
end;

function CheckSorrounding()
	if (pvp == false) then
		if (AnyFlaggedAround() == false) and (IsThereMobsAround()) then
			return true;
		end;
	else
		if (AnyFlaggedAround() == true) then
			return true;
		end;
	end;
	return false;
end;

function OnLTick500ms()
	CurrentTime = GetTime();
	myself = GetMe();
	MySkills = GetSkills();
	MyCurrentTarget = GetTarget();
	if (myself ~= nil) and (myself:GetClass() == 139) then
		if (TankStatus) then 
			AOESkill = MySkills:FindById(10013);
			AOESkill2 = MySkills:FindById(10014);
			AOESkill3 = MySkills:FindById(10012);
			AOESkill4 = MySkills:FindById(404);
			HateAuraSkill = MySkills:FindById(10027);
			if (myself:IsAlikeDeath() == false) and (GetDistanceVector(FarmPoint,myself:GetLocation()) < 5000) then	
				if (HateAuraSkill ~= nil) and (HateAuraSkill:IsSkillAvailable()) and (AOESkill2 ~= nil) and (AOESkill2:IsSkillAvailable()) and (AOESkill4 ~= nil) and (AOESkill4:IsSkillAvailable()) and (AllowedMass < CurrentTime) and CheckSorrounding() then
					local ChainHydra = MySkills:FindById(10016);
					if (ChainHydra ~= nil) and (ChainHydra:IsSkillAvailable()) then 
						UseSkillRaw(10016,false,false);
						AllowedMass = CurrentTime + 1000;
						else
						UseSkillRaw(10027, false, false); -- Superior Hate Aura 
					
					
					if (AOESkill ~= nil) and (AOESkill:IsSkillAvailable())  then
						UseSkillRaw(10013, false, false); -- Superior Hate Aura
						AllowedMass = CurrentTime + 1000;
						elseif (AOESkill2 ~= nil) and (AOESkill2:IsSkillAvailable()) then  
						UseSkillRaw(10014, false, false); -- Superior Hate Aura 						
						elseif (AOESkill3 ~= nil) and (AOESkill3:IsSkillAvailable())  then
							UseSkillRaw(10012, false, false); -- Superior Hate Aura
							AllowedMass = CurrentTime + 1000;
							else 
							UseSkillRaw(404, false, false); -- Superior Hate Aura
						end
					end	
				elseif (MyCurrentTarget ~= nil) and (MyCurrentTarget:IsAlikeDeath() == false) and ((MyCurrentTarget:IsMonster()) or ((pvp) and (MyCurrentTarget:IsEnemy() and (MyCurrentTarget:GetTarget() ~= myself:GetId()) and (MyCurrentTarget:GetTarget() ~= 0)) and (DoINeedNewTarget() == false))) then 
					PullSkill = MySkills:FindById(10015);
					AgroSkill = MySkills:FindById(10026);
					if (MyCurrentTarget:GetDistance() < 650) and (MyCurrentTarget:GetDistance() > 100) and (PullSkill ~= nil) and (PullSkill:IsSkillAvailable()) and (MyCurrentTarget:GetTarget() ~= myself:GetId()) and (myself:GetMp() > 2000) then
						UseSkillRaw(10015, false, false); -- Chain Strike
					elseif (MyCurrentTarget:GetDistance() < 900) and (AgroSkill ~= nil) and (AgroSkill:IsSkillAvailable()) then
						UseSkillRaw(10026, false, false); -- Superior Hate
					else
						movetospot();
					end;
				else
					movetospot();
				end;
			
		
			end
			if (pvp == false) then
				if (DoINeedNewTarget()) then
					--ShowToClient("Debugger","Targetting Logic Started");
					TargetAMobThatNeedAgro();
				end;
			else
				if (DoINeedNewTarget()) or IsMyHealerExposed() then
					TargetAnEnemyThatNeedAgro();
				end;
			end;
			
		end;
		if (retreat == true) then
			movetospot();
		end
	end
end	

	


function movetospot()
	if (retreat == false) then
		if (tankonspot == true) and (movestamp +2000 < GetTime()) and (GetDistanceVector(GetMe():GetLocation(),FarmPoint) > 150) and (GetDistanceVector(FarmPoint,GetMe():GetLocation()) < 5000) then
			local m = 50;
			loc =  FarmPoint;
			lX = loc.X + math.random(-m, m);
			lY = loc.Y + math.random(-m, m);
			MoveToNoWait(lX, lY, loc.Z);
			movestamp = GetTime();
		end;
	elseif (outspot ~= nil) and (movestamp + 500 < GetTime()) and (GetDistanceVector(GetMe():GetLocation(),outspot) > 150) and (GetDistanceVector(outspot,GetMe():GetLocation()) < 5000)  then
		MoveToNoWait(outspot);
	end;
end;

function IsMyHealerExposed()
	if (MyCurrentTarget ~= nil) then 
		if (MyCurrentTarget:IsEnemy()) and (MyCurrentTarget:GetDistance() < 1000)  then
				if (MyCurrentTarget:GetTarget() == findmypthealer()) then
					return false;
				end;
		end;
		local playerlist = GetPlayerList();
		for player in playerlist.list do
			if player:IsEnemy() and player:GetTarget() == findmypthealer() and (player:GetDistance() < 1000) then
				return true;
			end;
		end;
	end;
	return false;
end;

function TargetAnEnemyThatNeedAgro()
	local playerlist = GetPlayerList();
	myptidpetlist = GetMyPartyPetIDList();
	local priority = 0;
	local playerid = nil;
	for player in playerlist.list do
		if (player:IsEnemy()) and (player:GetDistance() < 850) then
			playertarget = GetUserById(player:GetTarget());
			if (playertarget ~= nil) then
				if (playertarget:GetId() == findmypthealer()) and (priority <= 5) then
					playerid = player:GetId();
					priority = 5;
				end;
				if (playertarget:IsMyPartyMember()) and (priority <= 2) then
					playerid = player:GetId();
					priority = 2
				end;				
			end;
			if CheckIfInsideList(player:GetTarget(),myptidpetlist) and (priority <= 1)   then
				playerid = player:GetId();
				priority = 1;
			end;
		end;
	end;

	if (playerid ~= nil)  then -- and (myself:GetTarget() ~= playerid) 
		ClearTargets();
			 CancelTarget(false);
			 CancelTarget(false);
			 CancelTarget(false);
		TargetRaw(playerid);
	end;
end;

function findmypthealer()
	local ptmembers = GetPartyList();
	for member in ptmembers.list do
		if (member:GetClass() == 146) then
			return member:GetId();
		end;
	end;
	return nil;
end;

function TargetAMobThatNeedAgro()
	myptidpetlist = GetMyPartyPetIDList();
	local moblist = GetMonsterList();
	priority = 0;
	mobid = nil;
	for mob in moblist.list do
		targetId = mob:GetTarget();
		if (mob:IsValid()) and (targetId ~= nil) and not (targetId == 0) then
			mobtarget = GetUserById(targetId);
			if (mobtarget ~= nil) and(mobtarget:IsMyPartyMember()) then 
				if (mob:GetDistance() < 900) and (mob:IsAlikeDeath() == false) and (findmypthealer() ~= nil) and (mobtarget:GetId() == findmypthealer()) then
					mobid = mob:GetId();
					priority = 7;
				end;
				if (mob:GetDistance() < 400) and (mob:IsAlikeDeath() == false) and (priority <= 4) then
					if (mob:GetDistance() > 50) and (priority <= 5) then
						mobid = mob:GetId();
						priority = 5;
					elseif (priority <= 3) then
						mobid = mob:GetId();
						priority = 4;
					end;
				end;
				if (mob:GetDistance() < 850) and (mob:IsAlikeDeath() == false) and (priority <= 2) then
					if (mob:GetDistance() > 100) then
						mobid = mob:GetId();
						priority = 3;
					else
						mobid = mob:GetId();
						priority = 2;
					end;
				end;	
			end;
			if CheckIfInsideList(mob:GetTarget(),myptidpetlist) and (mob:GetDistance() < 850) and (priority < 1) then
				mobid = mob:GetId();
				priority = 1;
			end;
		end;
	end;
	if (mobid ~= nil) then --and (myself:GetTarget() ~= mobid) 
		ClearTargets();
			 CancelTarget(false);
			 CancelTarget(false);
			 CancelTarget(false);
		TargetRaw(mobid);
	end;
end;

function GetMyPartyPetIDList()
	local tempreturnlist = {} ;
	local tempptmembersnames = {} ;
	local myptmembers = GetPartyList();
	local petlist = GetPetList();
	for member in myptmembers.list do
		tempptmembersnames[#tempptmembersnames+1] = member:GetName();
	end;
	for pet in petlist.list do
		if (CheckIfInsideList(pet:GetNickName(),tempptmembersnames)) then	
			tempreturnlist[#tempreturnlist+1] = pet:GetId();
		end;
	end;	
	return tempreturnlist;
end;

function CheckIfInsideList(thevalue,thelist)
	for x=1,#thelist do
		if (thelist[x] == thevalue) then
			return true;
		end;
	end;
	return false;
end;

function DoINeedNewTarget()
	if (MyCurrentTarget ~= nil) and (MyCurrentTarget:IsValid()) then 
		if not (MyCurrentTarget:IsAlikeDeath()) then
			if ((MyCurrentTarget:IsMonster()) and not (pvp)) or ((MyCurrentTarget:IsEnemy()) and (pvp)) then
				if ((MyCurrentTarget:GetDistance() < 600) and (ShieldStrike < CurrentTime)) or (MyCurrentTarget:GetDistance() < 900) then
					local MyTargetTarget = GetUserById(MyCurrentTarget:GetTarget());
					if (MyTargetTarget ~= nil) and (MyTargetTarget:IsValid()) then
						if (MyTargetTarget:IsMyPartyMember()) or CheckIfInsideList(MyTargetTarget:GetId(),myptidpetlist) then
							return false;
						end;			
					end;
				end;
			end;
		end;
	end;
	return true;	
end;

function IsThereMobsAround()
	local monsterlist = GetMonsterList();
	local count = 0;
	for mob in monsterlist.list do
		if (mob:GetDistance() < 800) and (mob:IsAlikeDeath() == false) and (mob:GetHpPercent() ~= 0) then
			count = count +1;
		end;
	end;
	if (count > 0) then
		return true;
	end;
	return false;
end;



function AnyFlaggedAround()
	local playerlist = GetPlayerList();
	for player in playerlist.list do
		if (player:IsMyPartyMember() == false) and (player:IsEnemy()) then
			if (player:IsPvPFlag() == true) then
				if (player:GetDistance() < 1200) then
					return true;
				end;
			end;
		end;
	end;
	return false;
end;

function OnMagicSkillUse(user, target, skillId, skillvl, skillHitTime, skillReuse)
	if (user:IsMe()) then	
		if (skillId == 10027) then
			AuraOfHateRdy = GetTime()+skillReuse;
		elseif (skillId == 10026) then
			AgressionRdy = GetTime()+skillReuse;
		elseif (skillId == 10015) then 
			ShieldStrike = GetTime()+skillReuse; 
		elseif (skillId == 10013) then 
			GustBlade = GetTime()+skillReuse; 
		elseif (skillId == 10014) then 
			GalaxyChain = GetTime()+skillReuse; 
		end;
		--ShowToClient("skillid",tostring(skillId));
	end;	
end;

function FindSubStringInString(thesub,thestring) -- build it myself the lua built-in one is not working exactly as needed.
	for x = 1, 1 + string.len(thestring)-string.len(thesub),1 do
		if (string.sub(thestring,x,x+string.len(thesub)-1) == thesub) then
			return true;
		end;
	end;
	return false;
end;

function OnChatUserMessage(chatType, nick, msg)
	if (chatType == L2ChatType.CHAT_PARTY) and (outspot ~= nil) then
		Message = string.lower(msg); -- Converts message to lower case letters.
		Message = Message:gsub("^%s*(.-)%s*$", "%1"); -- Trimming message of spaces on start.
		if (tankonspot == true) and (Message == "out") or FindSubStringInString("go out",Message) or FindSubStringInString("come out",Message) then
			retreat = true;
			TankStatus = false;
		end;
		if FindSubStringInString("go tank",Message) or FindSubStringInString("tank go",Message) then
			retreat = false;
			TankStatus = true;
		end;
	end;
end;