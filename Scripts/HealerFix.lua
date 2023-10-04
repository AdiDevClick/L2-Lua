HealerStatus = false;
 
function OnCreate()
	this:RegisterCommand("HealerFix", 
 
CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
end;
 
function OnCommand_HealerFix(vCommandChatType, vNick, 
 
vCommandParam)
	if (HealerStatus == false) then
		HealerStatus = true;
		ShowToClient("Heal Fix","Fixing Is Activated.");
	else
		HealerStatus = false;
		ShowToClient("Heal Fix","Fixing Is Deactivated.");	
	end;
end;
 
function OnLTick1s()
	local myself = GetMe();
	local MyTarget = GetTarget();
	if (HealerStatus == true) then
		if (myself ~= nil) and (myself:IsAlikeDeath() == 
 
false) and (MyTarget ~= nil) and ((MyTarget:IsMonster()) or not 
 
((MyTarget:IsMyPartyMember()) or (MyTarget:IsMe()))) then
			ClearTargets();
			CancelTarget(false);
                        CancelTarget(false);
                        CancelTarget(false); 
		end;
	end;
end;