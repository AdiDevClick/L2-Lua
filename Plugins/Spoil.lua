spoilMsg1 = "The Spoil condition has been activated.";
spoilMsg2 = "                   <<< SPOIL SUCCESSFUL!!! >>>";
spoilMsg3 = "It has already been spoiled.";
cantSpoilMsg1 = "There are no priority rights on a sweeper.";
cantSpoilMsg2 = "Sweeper failed, target not spoiled.";
cantSpoilMsg3 = "cannot be used due to unsuitable terms.";

SpoilMsg = {"The Spoil condition has been activated." ,"It has already been spoiled." , "                   <<< SPOIL SUCCESSFUL!!! >>>"};
cantSpoilMsg = {"There are no priority rights on a sweeper.", "Sweeper failed, target not spoiled.","cannot be used due to unsuitable terms."};

SpoilSkillCommand = "/useskill Blazing Boost";
SpoilSkillCommand2 = "/useskill Spoil Festival";
--------------------------------------------------------------------------------
SpoilStatus = false;
Spoiled = false;
tempId = 0;
--------------------------------------------------------------------------------
function OnCreate()
	this:RegisterCommand("spoil", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
end;
--------------------------------------------------------------------------------
function OnCommand_spoil(vCommandChatType, vNick, vCommandParam)
	if (SpoilStatus == false) then
		SpoilStatus = true;
		ShowToClient("Plugin","Automatic Spoil Mode ACTIVATED.");
	else
		SpoilStatus = false;
		ShowToClient("Plugin","Automatic Spoil Mode DEACTIVATED.");	
	end;
end;
--------------------------------------------------------------------------------
function CheckIfInsideList(Smsg,Rmsglist)
	for x,y in pairs(Rmsglist) do
		if (y == Smsg) then
			return true;
		end;
	end;
	return false;
end;
--------------------------------------------------------------------------------
function OnChatSystemMessage(id, msg)
	if (((msg == spoilMsg1) or (msg == spoilMsg2)or (msg == spoilMsg3)) and (SpoilStatus == true)) then
		Spoiled = true;
		if (GetTarget() ~= nil)then
			tempId = GetTarget():GetId();
		end;
	end;
	if (((msg == cantSpoilMsg1) or (msg == cantSpoilMsg2)or (msg == cantSpoilMsg3)) and (SpoilStatus == true)) then
		ClearTargets();
		CancelTarget(false);
		CancelTarget(false);
		CancelTarget(false); 
	end;
end;
--------------------------------------------------------------------------------
function IfDeadAndSpoiledInRange(range)
	local l = GetMonsterList();
	for monst in l.list do 
		if ((monst:IsAlikeDeath() == true) and (monst:IsSpoiled() == true) and (monst:GetRangeTo(GetMe()) < range)) then
			return monst:GetId();
		end;		
	end;
	return nil;
end;
--------------------------------------------------------------------------------
function IfDeadAndNotSpoiledInRange(range)
	local l = GetMonsterList();
	for monst in l.list do 
		if ((monst:IsAlikeDeath() == false) and (monst:IsSpoiled() == false) and (monst:GetRangeTo(GetMe()) < range)) then
			return monst:GetId();
		end;		
	end;
	return nil;
end;
--------------------------------------------------------------------------------
function OnLTick1s()
	if(SpoilStatus) and (IsPaused() == false)then
		
		local Me = GetMe();
		if (Me:IsAlikeDeath() == false) and (Me ~= nil) then
			----------------------------------- spoil
			if (GetTarget() ~= nil)then
				if(GetTarget():IsMonster()) 
					and (Me:GetRangeTo(GetTarget()) > 300) 
					and (Spoiled == false) and (Me:GetMpPercent() > 0 ) 
					and (GetTarget():GetId() ~= tempId)then
					Command(SpoilSkillCommand)
				else
					Spoiled = false;
				end;
			end;
			
			if (GetTarget() ~= nil)then
				if(GetTarget():IsMonster()) 
					and (IfDeadAndNotSpoiledInRange(400)
					or (Me:GetRangeTo(GetTarget()) < 300)) 
					and (Me:GetMpPercent() > 0 ) 
					and (GetTarget():GetId() ~= tempId)then
					Command(SpoilSkillCommand2)
				else
					Spoiled = false;
				end;
			end;
			----------------------------------- Seeper
			TempIdOfSpoiledMob = IfDeadAndSpoiledInRange(300);
			if(TempIdOfSpoiledMob ~= nil)then
				Command("/useskill Sweeper Festival"); --Sweeper
			end;			
		end;
	end;
end;

------------------------------------------------------------------------------------
function IfNotDeadAndNotSpoiledInRange(range)
	local l = GetMonsterList();
	for monst in (l.list) do 
		if ((monst:IsAlikeDeath() == false) and (monst:GetByName("Lavasaurus")) and (monst:GetRangeTo(GetMe()) < range)) then
			return monst:GetId();
		end;		
	end;
	return nil;
end;

------------------------------------------------------------------------------------
function OnLTick2s()
	if (IsPaused() == false)then
		
		local Me = GetMe();
		if (Me:IsAlikeDeath() == false) and (Me ~= nil) then
			----------------------------------- spoil
			TempIdOfSpoiledMob2 = IfNotDeadAndNotSpoiledInRange(600)
			if (TempIdOfSpoiledMob2 ~= nil)then
				TargetRaw(TempIdOfSpoiledMob2);
					Command(SpoilSkillCommand2)
				else
					Spoiled = false;
				end;
			end;
		end;
	end;