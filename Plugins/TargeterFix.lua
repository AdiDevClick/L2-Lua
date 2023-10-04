TargeterStatus = false;
 
function OnCreate()
	this:RegisterCommand("TargeterFix", 
 
CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME);
end;
 
function OnCommand_TargeterFix(vCommandChatType, vNick, 
 
vCommandParam)
	if (TargeterStatus == false) then
		TargeterStatus = true;
		ShowToClient("Targeter Fix","Fixing Is Activated.");
	else
		TargeterStatus = false;
		ShowToClient("Targeter Fix","Fixing Is Deactivated.");	
	end;
end;
 
function OnLTick1s()
	local myself = GetMe();
	local MyTarget = GetTarget();
	if (TargeterStatus == true) then
		if (myself ~= nil) and (myself:IsAlikeDeath() == 
 
false) and (MyTarget ~= nil) and ((MyTarget:IsMyPartyMember() or MyTarget:IsMe()) or not 
 
(MyTarget:IsMonster())) then
			ClearTargets();
			CancelTarget(false);
                        CancelTarget(false);
                        CancelTarget(false); 
		end;
	end;
end;