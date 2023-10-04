NpcName1 = "Large Cocoon";
NpcName2 = "Cocoon";
range = 1600;
--------------------------------------------------------------------------------
MakeCancel = false;
--------------------------------------------------------------------------------
function CountMonstersInRange(range)
	local l = GetMonsterList();
	local c = 0;
		
	for user in l.list do 
		if ((user:IsAlikeDeath() == false) and (user:GetRangeTo(GetMe())<range)) then
			c = c + 1;
		end;		
	end;
	return c;
end; 
--------------------------------------------------------------------------------
function GetCocon()
	local NpcL = GetNpcList();
	local r1 = range;
	local id = nil;
	local a = {};
	
	for user in NpcL.list do 
		r2 = GetMe():GetRangeTo(user);
		if(r2 < range) and r2 <= r1 and (user:GetHp() > 1) and ((user:GetName() == NpcName1) or (user:GetName() == NpcName2)) then
			r1 = GetMe():GetRangeTo(user);
			a[0] = user:GetId();
			a[1] = user:GetHp();
		end;
	end;
	return a;
end;

--------------------------------------------------------------------------------
repeat
	MyTr = GetTarget();
	if((MyTr == nil) and (CountMonstersInRange(range) == 0) and (IsPaused() == false)) then
		if(GetCocon()[0] ~= nil) and (GetCocon()[0] > 1) then
			Target(GetCocon()[0]);
			repeat
				Sleep(300);
				Command("/useshortcutforce 1 2");
			until GetTarget():GetHp() == 0;
			ClearTargets();
			CancelTarget(false);
		end;
	end;
	if(MyTr ~= nil) and (MyTr:GetHp() == 0)then
		ClearTargets();
		CancelTarget(false);
		Sleep(500);
	end;
until false;