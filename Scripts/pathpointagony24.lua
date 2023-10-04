SCONFIG = L2TConfig.GetConfig();
moveDistance = 30;

SetPause(true);				--Pause
--Remove Old Path Points--
for x = 1, 13 do
	SCONFIG.targeting.pathPoints:Erase(0);
end;
--/Remove Old Path Points--

ShowToClient("Q24", "Request to Find Sakum - Started");

MoveTo(-14012, 123776, -3123, moveDistance);
TargetNpc("Bathis", 30332);
Talk();
ClickAndWait("talk_select", "Quest.");
ClickAndWait("quest_choice?choice=16&option=1", "[533501]");
ClickAndWait("menu_select?ask=10335&reply=1", "Can I help?");
ClickAndWait("quest_accept?quest_id=10335", "Yes, I'll go now.");

MoveTo(-14012, 123776, -3123, moveDistance);
MoveTo(-14188, 123830, -3123, moveDistance);
MoveTo(-14723, 123944, -3130, moveDistance);

TargetNpc("Newbie Helper", 31077);
Talk();
ClickLinkAndWait("blessing_list001.htm");
Click("menu_select?ask=-7&reply=2", "Receive Assistant Magic");
ClearTargets();

MoveTo(-14723, 123944, -3130, moveDistance);
MoveTo(-14562, 124055, -3130, moveDistance);

TargetNpc("Bella", 30256);
MoveTo(-14504, 124097, -3128, moveDistance);
Talk();
ClickAndWait("teleport_request", "Teleport");
Click("teleport_4621380192_15_57_1209024578_3", "1010097");
WaitForTeleport();
Sleep (4000);

TargetNpc("Kallesin", 33177);
MoveTo(-41223, 122932, -2921, moveDistance);
Talk();
ClickAndWait("talk_select", "Quest");
ClickAndWait("menu_select?ask=10335&reply=1", "Yeah, they shouldn't be too hard to take out.");

MoveTo(-41223, 122932, -2921, moveDistance);
MoveTo(-41371, 122747, -2947, moveDistance);
MoveTo(-41428, 122538, -2989, moveDistance);
MoveTo(-41485, 122428, -3015, moveDistance);
MoveTo(-42153, 121467, -3243, moveDistance);
MoveTo(-42654, 119742, -3551, moveDistance);
MoveTo(-43747, 117302, -3582, moveDistance);
MoveTo(-44272, 115482, -3637, moveDistance);
MoveTo(-44628, 115591, -3634, moveDistance);
MoveTo(-45161, 115831, -3600, moveDistance);
MoveTo(-45426, 117570, -3562, moveDistance);

ActivateSoulShot(1463, true); -- Soulshot: (D-grade)
ActivateSoulShot(3948, true); -- Blessed Spiritshot : (D-grade)
ActivateSoulShot(2510, true); -- Spiritshot : (D-grade)

SetPause(true);				--Pause
SCONFIG.potions.HP.enabled = true;			--HP Potions On
SCONFIG.potions.enabled = true;			--Items On

SCONFIG.nuke.enabled = false;				--Auto Nuke 
SCONFIG.targeting.option = L2TConfig.ETargetingType.TT_PATH_POINT;			--Target using path points
SCONFIG.targeting.noMonstersReturnToCenter = true;			--Go to path point center if no monsters
-- 1st Add Path point --
local tmpPoint = L2TConfig.L2PathPoint();
tmpPoint.X = -45657;
tmpPoint.Y = 118090;
tmpPoint.Z = -3563;
tmpPoint.range = 900;
tmpPoint.type = L2TConfig.ETargetingRangeType.TRT_CIRCLE;
SCONFIG.targeting.pathPoints:Add(tmpPoint);
SCONFIG.targeting.pathPoints:Get(0).range = 600;
-- /1st Add Path point --
-- 2st Add Path point --
local tmpPoint = L2TConfig.L2PathPoint();
tmpPoint.X = -45664;
tmpPoint.Y = 118659;
tmpPoint.Z = -3520;
tmpPoint.range = 900;
tmpPoint.type = L2TConfig.ETargetingRangeType.TRT_CIRCLE;
SCONFIG.targeting.pathPoints:Add(tmpPoint);
SCONFIG.targeting.pathPoints:Get(1).range = 600;
-- /2st Add Path point --
-- 3st Add Path point --
local tmpPoint = L2TConfig.L2PathPoint();
tmpPoint.X = -45719;
tmpPoint.Y = 119254;
tmpPoint.Z = -3462;
tmpPoint.range = 900;
tmpPoint.type = L2TConfig.ETargetingRangeType.TRT_CIRCLE;
SCONFIG.targeting.pathPoints:Add(tmpPoint);
SCONFIG.targeting.pathPoints:Get(2).range = 600;
-- /3st Add Path point --
-- 4st Add Path point --
local tmpPoint = L2TConfig.L2PathPoint();
tmpPoint.X = -45871;
tmpPoint.Y = 119813;
tmpPoint.Z = -3419;
tmpPoint.range = 900;
tmpPoint.type = L2TConfig.ETargetingRangeType.TRT_CIRCLE;
SCONFIG.targeting.pathPoints:Add(tmpPoint);
SCONFIG.targeting.pathPoints:Get(3).range = 600;
-- /4st Add Path point --
-- 5st Add Path point --
local tmpPoint = L2TConfig.L2PathPoint();
tmpPoint.X = -45734;
tmpPoint.Y = 119179;
tmpPoint.Z = -3469;
tmpPoint.range = 900;
tmpPoint.type = L2TConfig.ETargetingRangeType.TRT_CIRCLE;
SCONFIG.targeting.pathPoints:Add(tmpPoint);
SCONFIG.targeting.pathPoints:Get(4).range = 600;
-- /5st Add Path point --
-- 6st Add Path point --
local tmpPoint = L2TConfig.L2PathPoint();
tmpPoint.X = -45741;
tmpPoint.Y = 118402;
tmpPoint.Z = -3540;
tmpPoint.range = 900;
tmpPoint.type = L2TConfig.ETargetingRangeType.TRT_CIRCLE;
SCONFIG.targeting.pathPoints:Add(tmpPoint);
SCONFIG.targeting.pathPoints:Get(5).range = 600;
-- /6st Add Path point --
-- 7st Add Path point --
local tmpPoint = L2TConfig.L2PathPoint();
tmpPoint.X = -45980;
tmpPoint.Y = 117509;
tmpPoint.Z = -3563;
tmpPoint.range = 900;
tmpPoint.type = L2TConfig.ETargetingRangeType.TRT_CIRCLE;
SCONFIG.targeting.pathPoints:Add(tmpPoint);
SCONFIG.targeting.pathPoints:Get(6).range = 600;
-- /7st Add Path point --
-- 8st Add Path point --
local tmpPoint = L2TConfig.L2PathPoint();
tmpPoint.X = -45880;
tmpPoint.Y = 116792;
tmpPoint.Z = -3557;
tmpPoint.range = 900;
tmpPoint.type = L2TConfig.ETargetingRangeType.TRT_CIRCLE;
SCONFIG.targeting.pathPoints:Add(tmpPoint);
SCONFIG.targeting.pathPoints:Get(7).range = 600;
-- /8st Add Path point --
-- 9st Add Path point --
local tmpPoint = L2TConfig.L2PathPoint();
tmpPoint.X = -46523;
tmpPoint.Y = 116119;
tmpPoint.Z = -3555;
tmpPoint.range = 900;
tmpPoint.type = L2TConfig.ETargetingRangeType.TRT_CIRCLE;
SCONFIG.targeting.pathPoints:Add(tmpPoint);
SCONFIG.targeting.pathPoints:Get(8).range = 600;
-- /9st Add Path point --
-- 10st Add Path point --
local tmpPoint = L2TConfig.L2PathPoint();
tmpPoint.X = -47256;
tmpPoint.Y = 115653;
tmpPoint.Z = -3624;
tmpPoint.range = 900;
tmpPoint.type = L2TConfig.ETargetingRangeType.TRT_CIRCLE;
SCONFIG.targeting.pathPoints:Add(tmpPoint);
SCONFIG.targeting.pathPoints:Get(9).range = 600;
-- 10st Add Path point --
SetPause(false);				--Play


--KillMobCounter--
Mode=2;	--							<--------------------------------------------------------------------------MODE---------------------------------------------------------------------------
--Group A infos--
MobNameA = "Ruin Spartoi" --		<-------------------------------
MobIdA = 20054; --					<-------------------------------
MaxA=15; --							<-------------------------------
--Group B infos--
MobNameB = "Ruin Zombie" --			<-------------------------------
MobNameB = "Ruin Zombie Leader" --   <-------------------------------
MobIdB = 20026; --					<-------------------------------
MobIdB = 20029; -- 					<-------------------------------
MaxB=15; --							<-------------------------------
--Group C infos--
MobNameC= "Skeleton Bowman"	--		<-------------------------------
MobIdC = 20051; --					<-------------------------------
MaxC=10; --							<-------------------------------
--Group D infos--
MobNameD= "Skeleton Tracker" --		<-------------------------------
MobIdD = 20035; --					<-------------------------------
MaxD=10; --							<-------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CounterA=0;
CounterB=0;
CounterC=0;
CounterD=0;
Players=GetPlayerList();
Process=-1;
Mob=0;
MyId = GetMe():GetId();
--ShowToClient("MyId",""..MyId.."");
if (Mode==1) then
	repeat
		repeat
			--ShowToClient("loop","Loading");
			Unacceptable = 0;
			if (GetMe():GetTarget()~=0 and GetMe():GetTarget()~=MyId) then
				for Player in Players.list do 
					if (Player:GetRangeTo(GetMe())<30000) and (Player:GetTarget() == GetMe():GetTarget()) and (Player:GetId()~=GetMe():GetId()) then
						Unacceptable = GetMe():GetTarget();
						CancelTarget(true);
						ClearTargets();
						--ShowToClient("Unacceptable","Finded Attacker");
						break;
					end;
				end;
				if ((GetMe():GetTarget()~=0) and (GetMe():GetTarget()~= Unacceptable) and (GetTarget():IsMonster()==true) and (GetTarget():IsAlikeDeath() == false) and (GetTarget():GetNpcId()==MobIdA) and ((GetTarget():GetTarget() == MyId) or ((GetTarget():IsInCombat()==false) and (GetTarget():GetTarget() == 0)))) then
					--ShowToClient("Expression True","All parameter its okay");
					Process=0;
					SCONFIG.nuke.enabled = true;				--Auto Nuke
					break;
				end;
			end;
		until (false);
		while ((Process~=-1) and (GetMe():GetTarget()~=0) and (GetTarget():IsAlikeDeath()==false)) do
			if ((Process==0) and (GetMe():GetTarget()~=0)) then 
				Process=Process+1;
				TargetUniqueId=GetMe():GetTarget();
				--ShowToClient(" In compat with: ",GetTarget():GetName());
				--ShowToClient(" TargetUnigueId: ",""..TargetUniqueId.."");
				TargetUniqueIdTemp=GetMe():GetTarget();
				--ShowToClient(" TargetUnigueIdTemp : ",""..TargetUniqueIdTemp.."");
				MyMonsterTargetTemp=GetUserById(TargetUniqueIdTemp):GetTarget();
				--ShowToClient(" MyMonsterTargetTemp : ",""..MyMonsterTargetTemp.."");
				for Player in Players.list do 
					if (Player:GetRangeTo(GetMe())<30000) and (Player:GetTarget() == GetMe():GetTarget()) and (Player:GetId()~=GetMe():GetId()) then
						Process = -1;
						--ShowToClient("Unacceptable","Finded Attacker");
					end;
				end;
				if (TargetUniqueId~=TargetUniqueIdTemp) or ((MyMonsterTargetTemp~=MyId) and (MyMonsterTargetTemp~=0) or (Process==-1)) then
					if (TargetUniqueId~=TargetUniqueIdTemp) then
						--ShowToClient("Help","Change Target!!! ");
					end;
					if ((MyMonsterTargetTemp~=MyId) and (MyMonsterTargetTemp~=0)) then
						--ShowToClient("Help","Mob Agroed!!! ");
					end;
					if (Process==-1) then
						--ShowToClient("Help","Mob Targeted from other Player!!! ");
					end;
					SCONFIG.nuke.enabled = false;				--Auto Nuke
					CancelTarget(true);
					ClearTargets();
					Process=-1;
					break;
				end;
			elseif ((Process>0) and (GetMe():GetTarget()~=0)) then
				Process=Process+1;
				TargetUniqueIdTemp=GetMe():GetTarget();
				--ShowToClient(" TargetUnigueIdTemp : ",""..TargetUniqueIdTemp.."");
				MyMonsterTargetTemp=GetUserById(TargetUniqueIdTemp):GetTarget();
				--ShowToClient(" MyMonsterTargetTemp : ",""..MyMonsterTargetTemp.."");
				for Player in Players.list do 
					if (Player:GetRangeTo(GetMe())<30000) and (Player:GetTarget() == GetMe():GetTarget()) and (Player:GetId()~=GetMe():GetId()) then
						Process = -1;
						--ShowToClient("Unacceptable","Finded Attacker");
					end;
				end;
				if (TargetUniqueId~=TargetUniqueIdTemp) or ((MyMonsterTargetTemp~=MyId) and (MyMonsterTargetTemp~=0) or (Process==-1)) then
					if (TargetUniqueId~=TargetUniqueIdTemp) then
						--ShowToClient("Help","Change Target!!! ");
					end;
					if ((MyMonsterTargetTemp~=MyId) and (MyMonsterTargetTemp~=0)) then
						--ShowToClient("Help","Mob Agroed!!! ");
					end;
					if (Process==-1) then
						--ShowToClient("Help","Mob Targeted from other Player!!! ");
					end;
					SCONFIG.nuke.enabled = false;				--Auto Nuke
					CancelTarget(true);
					ClearTargets();
					Process=-1;
					break;
				end;
			end;
		end;
		if (((TargetUniqueId==TargetUniqueIdTemp) and ((MyMonsterTargetTemp==MyId) or (MyMonsterTargetTemp==0)) and (GetMe():GetTarget()~=0)) and (Process~=-1)) then
			if (CounterA<=MaxA-1) then
				CounterA = CounterA + 1;
				ShowToClient(MobNameA,""..CounterA.."");
			end;
		end;
	until (CounterA>MaxA-1);
elseif (Mode==2)then
	repeat
		repeat
			--ShowToClient("loop","Loading");
			Unacceptable = 0;
			if (GetMe():GetTarget()~=0 and GetMe():GetTarget()~=MyId) then
				for Player in Players.list do 
					if (Player:GetRangeTo(GetMe())<30000) and (Player:GetTarget() == GetMe():GetTarget()) and (Player:GetId()~=GetMe():GetId()) then
						Unacceptable = GetMe():GetTarget();
						CancelTarget(true);
						ClearTargets();
						--ShowToClient("Unacceptable","Finded Attacker");
						break;
					end;
				end;
				if ((GetMe():GetTarget()~=0) and (GetMe():GetTarget()~= Unacceptable) and (GetTarget():IsMonster()==true) and (GetTarget():IsAlikeDeath() == false) and ((GetTarget():GetNpcId()==MobIdA) or (GetTarget():GetNpcId()==MobIdB) or (GetTarget():GetNpcId()==MobIdC) or (GetTarget():GetNpcId()==MobIdD)) and ((GetTarget():GetTarget() == MyId) or ((GetTarget():IsInCombat()==false) and (GetTarget():GetTarget() == 0)))) then
					--ShowToClient("Expression True","All parameter its okay");
					Process=0;
					SCONFIG.nuke.enabled = true;				--Auto Nuke
					if (GetTarget():GetNpcId()==MobIdA) then
						Mob=1;
					elseif (GetTarget():GetNpcId()==MobIdB) then
						Mob=2;	
					elseif (GetTarget():GetNpcId():GetMobIdB()== 20029) then
						Mob=2;
					elseif (GetTarget():GetNpcId()==MobIdC) then
						Mob=3;
				
					elseif (GetTarget():GetNpcId()==MobIdD) then
						Mob=4;
					end;
					break;
				end;
			end;
		until (false);
		while ((Process~=-1) and (GetMe():GetTarget()~=0) and (GetTarget():IsAlikeDeath()==false)) do
			if ((Process==0) and (GetMe():GetTarget()~=0)) then 
				Process=Process+1;
				TargetUniqueId=GetMe():GetTarget();
				--ShowToClient(" In compat with: ",GetTarget():GetName());
				--ShowToClient(" TargetUnigueId: ",""..TargetUniqueId.."");
				TargetUniqueIdTemp=GetMe():GetTarget();
				--ShowToClient(" TargetUnigueIdTemp : ",""..TargetUniqueIdTemp.."");
				MyMonsterTargetTemp=GetUserById(TargetUniqueIdTemp):GetTarget();
				--ShowToClient(" MyMonsterTargetTemp : ",""..MyMonsterTargetTemp.."");
				for Player in Players.list do 
					if (Player:GetRangeTo(GetMe())<30000) and (Player:GetTarget() == GetMe():GetTarget()) and (Player:GetId()~=GetMe():GetId()) then
						Process=-1;
						--ShowToClient("Unacceptable","Finded Attacker");
					end;
				end;
				if (TargetUniqueId~=TargetUniqueIdTemp) or ((MyMonsterTargetTemp~=MyId) and (MyMonsterTargetTemp~=0) or (Process==-1)) then
					if (TargetUniqueId~=TargetUniqueIdTemp) then
						--ShowToClient("Help","Change Target!!! ");
					end;
					if ((MyMonsterTargetTemp~=MyId) and (MyMonsterTargetTemp~=0)) then
						--ShowToClient("Help","Mob Agroed!!! ");
					end;
					if (Process==-1) then
						--ShowToClient("Help","Mob Targeted from other Player!!! ");
					end;
					SCONFIG.nuke.enabled = false;				--Auto Nuke
					CancelTarget(true);
					ClearTargets();
					Process=-1;
					break;
				end;
			elseif ((Process>0) and (GetMe():GetTarget()~=0)) then
				Process=Process+1;
				TargetUniqueIdTemp=GetMe():GetTarget();
				--ShowToClient(" TargetUnigueIdTemp : ",""..TargetUniqueIdTemp.."");
				MyMonsterTargetTemp=GetUserById(TargetUniqueIdTemp):GetTarget();
				--ShowToClient(" MyMonsterTargetTemp : ",""..MyMonsterTargetTemp.."");
				for Player in Players.list do 
					if (Player:GetRangeTo(GetMe())<30000) and (Player:GetTarget() == GetMe():GetTarget()) and (Player:GetId()~=GetMe():GetId()) then
						Process=-1;
						--ShowToClient("Unacceptable","Finded Attacker");
					end;
				end;
				if (TargetUniqueId~=TargetUniqueIdTemp) or ((MyMonsterTargetTemp~=MyId) and (MyMonsterTargetTemp~=0) or (Process==-1)) then
					if (TargetUniqueId~=TargetUniqueIdTemp) then
						--ShowToClient("Help","Change Target!!! ");
					end;
					if ((MyMonsterTargetTemp~=MyId) and (MyMonsterTargetTemp~=0)) then
						--ShowToClient("Help","Mob Agroed!!! ");
					end;
					if (Process==-1) then
						--ShowToClient("Help","Mob Targeted from other Player!!! ");
					end;
					SCONFIG.nuke.enabled = false;				--Auto Nuke
					CancelTarget(true);
					ClearTargets();
					Process=-1;
					break;
				end;
			end;
		end;
		SCONFIG.nuke.enabled = false;				--Auto Nuke
		if (((TargetUniqueId==TargetUniqueIdTemp) and (MyMonsterTargetName==Kanilov) and ((MyMonsterTargetTemp==MyId) or (MyMonsterTargetTemp==0)) and (GetMe():GetTarget()~=0)) and (Process~=-1)) then
			if (Mob==1) then
				if (CounterA<=MaxA-1) then
					CounterA = CounterA + 1;
					ShowToClient(MobNameA,""..CounterA.."");
				end;
			elseif (Mob==2) then
				if (CounterB<=MaxB-1) then
					CounterB = CounterB + 1;
					ShowToClient(MobNameB,""..CounterB.."");
				end;
			elseif (Mob==3) then
				if (CounterC<=MaxC-1) then
					CounterC = CounterC + 1;
					ShowToClient(MobNameC,""..CounterC.."");
				end;
			elseif (Mob==4) then
				if (CounterD<=MaxD-1) then
					CounterD = CounterD + 1;
					ShowToClient(MobNameD,""..CounterD.."");
				end;
			end;
		end;
	until ((CounterA>MaxA-1)and(CounterB>MaxB-1)and(CounterC>MaxC-1)and(CounterD>MaxD-1));
end

MoveTo(-46675, 114678, -3679, moveDistance);
MoveTo(-46582, 114384, -3659, moveDistance);
MoveTo(-46450, 114132, -3584, moveDistance);
MoveTo(-46289, 113804, -3581, moveDistance);
MoveTo(-46195, 113582, -3581, moveDistance);
MoveTo(-46147, 112898, -3816, moveDistance);
MoveTo(-46142, 112664, -3816, moveDistance);
MoveTo(-46126, 112145, -3816, moveDistance);
MoveTo(-46119, 111933, -3816, moveDistance);
MoveTo(-46111, 111661, -3816, moveDistance);
MoveTo(-46100, 111349, -3816, moveDistance);
MoveTo(-46108, 110979, -3814, moveDistance);
MoveTo(-46112, 110753, -3816, moveDistance);
MoveTo(-46124, 110355, -3816, moveDistance);
MoveTo(-46132, 110092, -3816, moveDistance);
MoveTo(-46148, 109552, -3816, moveDistance);
TargetNpc("Zenath", 33509);
MoveTo(-46112, 109442, -3816, moveDistance);
Talk();
ClickAndWait("talk_select", "Quest");
ClickAndWait("quest_choice?choice=0&option=1", "[533502]");
ClickAndWait("menu_select?ask=10335&reply=1", "\"Well...\"");
ClickAndWait("menu_select?ask=10335&reply=2", "\"Oh?\"");
MoveTo(-46112, 109442, -3816, moveDistance);
ClearTargets();
 
ShowToClient("Q24", "Request to Find Sakum - Finished");