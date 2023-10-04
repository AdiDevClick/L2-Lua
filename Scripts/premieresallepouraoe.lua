SCONFIG = L2TConfig.GetConfig();
moveDistance = 30;
SetPause(true);

MoveTo(181276, -114266, -6100, moveDistance);
MoveTo(181183, -114245, -6110, moveDistance);
MoveTo(180921, -114915, -6110, moveDistance);
MoveTo(179843, -115532, -6104, moveDistance);
MoveTo(180073, -116225, -6110, moveDistance);
MoveTo(180603, -116271, -6110, moveDistance);
MoveTo(180633, -116252, -6110, moveDistance);
MoveTo(180828, -116139, -6110, moveDistance);
MoveTo(180859, -115454, -6110, moveDistance);
MoveTo(180944, -115130, -6106, moveDistance);
MoveTo(180901, -114897, -6110, moveDistance);
MoveTo(181168, -114219, -6109, moveDistance);
MoveTo(181293, -114259, -6100, moveDistance);

SetPause(false);
range = 300;
local me = GetMe();
local found = nil;
local npc = GetMonsterList();
	for user in npc.list do 
		if (user:GetNpcId() == 21389 or user:GetNpcId() == 22644 
			or user:GetNpcId() == 21655 or user:GetNpcId() == 21387 
			or user:GetNpcId() == 21430 or user:GetNpcId() == 21431 
			or user:GetNpcId() == 22647 or user:GetNpcId() == 22645 
			or user:GetNpcId() == 21391)
		and (user:GetRangeTo(me) < range) and (user:IsAlikeDeath() == false) then
			found = user;
				while ((found:GetRangeTo(me) < range) and (found:IsAlikeDeath() == false)) do
			SetPause(false);
			end;
		end;
	end;

SetPause(true);
L2TConfig.LoadConfig(SCONFIG_FILE);
