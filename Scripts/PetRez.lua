myptidpetlist =	{} 

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


function Rez()
	local playerlist = GetPartyList();
	myptidpetlist = GetMyPartyPetIDList();
	local playerid = nil;
	for player in playerlist.list do
		if (player:GetDistance() < 900) and (player:IsAlikeDeath() == true) then
			playertarget = GetUserById(player:GetTarget());
			if (playertarget ~= nil) then
				playerid = player:GetId()
			end;
		end;
	end;

	if (playerid ~= nil)  then -- and (myself:GetTarget() ~= playerid) 
		ClearTargets();
		TargetRaw(playerid);
		Sleep(400);
		UseSkillRaw(11784, false, false); -- Resurrection
		Sleep(400);
			ClearTargets();
			 CancelTarget(false);
			 CancelTarget(false);
			 CancelTarget(false);
	end;
end;

function CheckIfInsideList(thevalue,thelist)
	for x=1,#thelist do
		if (thelist[x] == thevalue) then
			return true;
		end;
	end;
	return false;
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

repeat
	if not IsPaused() and GetMe():IsAlikeDeath() == false and 
		GetSkills():FindById(11784):CanBeUsed() then
	Rez() 
	end
	Sleep(400)
until false