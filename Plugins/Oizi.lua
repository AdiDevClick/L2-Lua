oiziStatus = false;
oizionspot = false;
pvp = false;
Lumi = GetTime();
Force = GetTime();
Rain = GetTime(); 
MassVeil = GetTime();
Blast = GetTime();
movestamp = GetTime();
outspot = nil;
myptidpetlist =	{} ;
AllowedMass = GetTime() + 40000;

function OnCreate()
	this:RegisterCommand("oizi", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
	this:RegisterCommand("oizionspot", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
	this:RegisterCommand("oizipvp", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
	this:RegisterCommand("outspot", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
end;

function OnCommand_oizi(vCommandChatType, vNick, vCommandParam)
	if (oiziStatus == false) then
		oiziStatus = true;
		FarmPoint = GetMe():GetLocation();
		retreat = false;
		ShowToClient("oizi Plugin","Tanking Is Activated.");
	else
		oiziStatus = false;
		oiziStatus = false;
		retreat = false;
		ShowToClient("oizi Plugin","Tanking Is Is Deactivated.");	
	end;
end;

function OnCommand_oizipvp(vCommandChatType, vNick, vCommandParam)
	if (pvp == false) then
		pvp = true;
		retreat = false;
		ShowToClient("oizi Plugin","Switched to PvP Iss Mode.");
	else
		pvp = false;
		retreat = false;
		ShowToClient("oizi Plugin","Switched to PvE Iss Mode.");	
	end;
end;

function OnCommand_oizionspot(vCommandChatType, vNick, vCommandParam)
	if (oiziStatus == false) then
		oiziStatus = true;
		oizionspot = true;
		retreat = false;
		FarmPoint = GetMe():GetLocation();
		ShowToClient("oizi Plugin","Tanking Is Activated.");
	else
		oiziStatus = false;
		oizionspot = false;
		retreat = false;
		ShowToClient("oizi Plugin","Tanking Is Is Deactivated.");	
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
	if (myself ~= nil) and (myself:GetClass() == 146) then
		if (oiziStatus) then 
			AOESkill = MySkills:FindById(11817);
			if (myself:IsAlikeDeath() == false) and (GetDistanceVector(FarmPoint,myself:GetLocation()) < 5000) then	
				if (AOESkill ~= nil) and (AOESkill:IsSkillAvailable()) and (AllowedMass < CurrentTime) and CheckSorrounding() and (myself:GetMpPercent() > 10) and (myself:GotBuff(11765) == false) then
					local rn = MySkills:FindById(11767);
					if (rn ~= nil) and (rn:IsSkillAvailable()) then 
						UseSkillRaw(11767,false,false);
						AllowedMass = CurrentTime + 1000;
						else
						UseSkillRaw(11817, false, false); -- Superior Hate Aura 
					end	
					
				elseif (MyCurrentTarget ~= nil) and (MyCurrentTarget:IsAlikeDeath() == false) and ((MyCurrentTarget:IsMonster()) or ((pvp) and (MyCurrentTarget:IsEnemy() and (MyCurrentTarget:GetTarget() ~= myself:GetId()) and (MyCurrentTarget:GetTarget() ~= 0)) and (DoINeedNewTarget() == false))) then 
					Trink = MySkills:FindById(11777); -- Lumi
					AgroSkill2 = MySkills:FindById(11766); -- Dark Blast
					if (MyCurrentTarget:GetDistance() < 900) and (MyCurrentTarget:GotBuff(11777) ==  false) and (MyCurrentTarget:GetHpPercent() > 10) and (Trink ~= nil) and (Trink:IsSkillAvailable()) and (AllowedMass < CurrentTime) and (myself:GetMpPercent() > 10) and (myself:GotBuff(11765) == false) then
						UseSkillRaw(11777, false, false); -- Chain Strike
						AllowedMass = CurrentTime + 3000;
					elseif (MyCurrentTarget:GetDistance() < 900) and (MyCurrentTarget:GetHpPercent() > 30) and (AgroSkill2 ~= nil) and (AgroSkill2:IsSkillAvailable()) and (AllowedMass < CurrentTime) and (myself:GetMpPercent() > 10) and (myself:GotBuff(11765) == false) then
						UseSkillRaw(11766, false, false); -- Superior Hate
						AllowedMass = CurrentTime + 3000;
					else
						movetospot();
					end;
				else
					movetospot();
				end;
			
		
			end
			if (pvp == false) then
				if (DoINeedNewTarget()) then
					-- ShowToClient("Debugger","Targetting Logic Started");
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
		if (oizionspot == true) and (movestamp +2000 < GetTime()) and (GetDistanceVector(GetMe():GetLocation(),FarmPoint) > 150) and (GetDistanceVector(FarmPoint,GetMe():GetLocation()) < 5000) then
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
				if (MyCurrentTarget:GetTarget() == findmypthealer()) or (MyCurrentTarget:GetTarget() ~= GetMe():GetId()) then
					return false;
				end;
		end;
		local playerlist = GetPlayerList();
		for player in playerlist.list do
			if player:IsEnemy() and player:GetTarget() == findmypthealer() and player:GetTarget() ~= GetMe():GetId() and (player:GetDistance() < 1000) and not player:GetTarget() == GetMe():GetId() then
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
		if (member:GetClass() == 146) and (member ~= GetMe():GetId()) then
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
			if (mobtarget ~= nil) and (mobtarget:IsMyPartyMember()) and (mobtarget ~= GetMe():GetId()) then 
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
				if ((MyCurrentTarget:GetDistance() < 600) and (Rain < CurrentTime)) or (MyCurrentTarget:GetDistance() < 900) then
					local MyTargetTarget = GetUserById(MyCurrentTarget:GetTarget());
					if (MyTargetTarget ~= nil) and (MyTargetTarget:IsValid()) and (MyTargetTarget ~= GetMe():GetId()) then
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
	if (count > 1) then
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
		if (skillId == 11777) then
			Lumi = GetTime()+skillReuse;
		elseif (skillId == 11814) then
			Force = GetTime()+skillReuse;
		elseif (skillId == 11817) then 
			Rain = GetTime()+skillReuse; 
		elseif (skillId == 11767) then
			MassVeil = GetTime()+skillReuse;
		elseif (skillId == 11766) then
			Blast = GetTime()+skillReuse;
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
		if (oizionspot == true) and (Message == "out") or FindSubStringInString("go out",Message) or FindSubStringInString("come out",Message) then
			retreat = true;
			oiziStatus = false;
		end;
		if FindSubStringInString("go tank",Message) or FindSubStringInString("tank go",Message) then
			retreat = false;
			oiziStatus = true;
		end;
	end;
end;