IssStatus = false;
issonspot = false;
pvp = false;
MassCripple = GetTime();
MassBlade = GetTime();
Cripple = GetTime(); 
Shadow = GetTime();
Strike = GetTime();
Assault = GetTime();
movestamp = GetTime();
outspot = nil;
myptidpetlist =	{} ;
AllowedMass = GetTime() + 40000;

function OnCreate()
	this:RegisterCommand("iss", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
	this:RegisterCommand("issonspot", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
	this:RegisterCommand("isspvp", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
	this:RegisterCommand("outspot", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
end;

function OnCommand_iss(vCommandChatType, vNick, vCommandParam)
	if (IssStatus == false) then
		IssStatus = true;
		FarmPoint = GetMe():GetLocation();
		retreat = false;
		ShowToClient("Iss Plugin","Tanking Is Activated.");
	else
		IssStatus = false;
		issonspot = false;
		retreat = false;
		ShowToClient("Iss Plugin","Tanking Is Is Deactivated.");	
	end;
end;

function OnCommand_isspvp(vCommandChatType, vNick, vCommandParam)
	if (pvp == false) then
		pvp = true;
		retreat = false;
		ShowToClient("Iss Plugin","Switched to PvP Iss Mode.");
	else
		pvp = false;
		retreat = false;
		ShowToClient("Iss Plugin","Switched to PvE Iss Mode.");	
	end;
end;

function OnCommand_issonspot(vCommandChatType, vNick, vCommandParam)
	if (IssStatus == false) then
		IssStatus = true;
		issonspot = true;
		retreat = false;
		FarmPoint = GetMe():GetLocation();
		ShowToClient("Iss Plugin","Tanking Is Activated.");
	else
		IssStatus = false;
		issonspot = false;
		retreat = false;
		ShowToClient("Iss Plugin","Tanking Is Is Deactivated.");	
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
	if (myself ~= nil) and (myself:GetClass() == 144) then
		if (IssStatus) then
			AOESkill = MySkills:FindById(11514);
			if (myself:IsAlikeDeath() == false) and (GetDistanceVector(FarmPoint,myself:GetLocation()) < 5000) then	
				if (AOESkill ~= nil) and (AOESkill:IsSkillAvailable())and (AllowedMass < CurrentTime) and CheckSorrounding() then
					local MassCrip = MySkills:FindById(11513);
					if (MassCrip ~= nil) and (MassCrip:IsSkillAvailable()) then 
						UseSkillRaw(11513,false,false);
						AllowedMass = CurrentTime + 1000;
						else
						UseSkillRaw(11514, false, false); -- Superior Hate Aura 
					end
					
				elseif (MyCurrentTarget ~= nil) and (MyCurrentTarget:IsAlikeDeath() == false) and ((MyCurrentTarget:IsMonster()) or ((pvp) and (MyCurrentTarget:IsEnemy() and (MyCurrentTarget:GetTarget() ~= myself:GetId()) and (MyCurrentTarget:GetTarget() ~= 0)) and (DoINeedNewTarget() == false))) then 
					PullSkill = MySkills:FindById(11508);
					AgroSkill = MySkills:FindById(11509);
					AgroSkill2 = MySkills:FindById(11510);
					AgroSkill3 = MySkills:FindById(11511);
					if (MyCurrentTarget:GetDistance() < 900) and (MyCurrentTarget:GetDistance() > 250) and (PullSkill ~= nil) and (PullSkill:IsSkillAvailable()) and (MyCurrentTarget:GetTarget() ~= myself:GetId()) and (myself:GetMp() > 500) then
						UseSkillRaw(10015, false, false); -- Chain Strike
					elseif (MyCurrentTarget:GetDistance() < 600) and (AgroSkill ~= nil) and (AgroSkill:IsSkillAvailable()) then
						UseSkillRaw(11509, false, false); -- Superior Hate
					elseif (MyCurrentTarget:GetDistance() < 600) and (AgroSkill2 ~= nil) and (AgroSkill2:IsSkillAvailable()) then
						UseSkillRaw(11510, false, false); -- Superior Hate
					elseif (MyCurrentTarget:GetDistance() < 600) and (AgroSkill3 ~= nil) and (AgroSkill3:IsSkillAvailable()) then
						UseSkillRaw(11511, false, false); -- Superior Hate
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
		if (issonspot == true) and (movestamp +2000 < GetTime()) and (GetDistanceVector(GetMe():GetLocation(),FarmPoint) > 150) and (GetDistanceVector(FarmPoint,GetMe():GetLocation()) < 5000) then
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
			if CheckIfInsideList(mob:GetTarget(),myptidpetlist) and (mob:GetDistance() < 850) and (mob:IsAlikeDeath() == false)  and (priority < 1) then
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
				if ((MyCurrentTarget:GetDistance() < 600) and (Assault < CurrentTime)) or (MyCurrentTarget:GetDistance() < 900) then
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
		if (skillId == 11513) then
			MassCripple = GetTime()+skillReuse;
		elseif (skillId == 11514) then
			MassBlade = GetTime()+skillReuse;
		elseif (skillId == 11509) then 
			Cripple = GetTime()+skillReuse; 
		elseif (skillId == 11510) then 
			Shadow = GetTime()+skillReuse; 
		elseif (skillId == 11511) then 
			Strike = GetTime()+skillReuse; 
		elseif (skillId == 11508) then
			Assault = GetTime()+skillReuse;
		end
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
		if (issonspot == true) and (Message == "out") or FindSubStringInString("go out",Message) or FindSubStringInString("come out",Message) then
			retreat = true;
			IssStatus = false;
		end;
		if FindSubStringInString("go tank",Message) or FindSubStringInString("tank go",Message) then
			retreat = false;
			IssStatus = true;
		end;
	end;
end;