function KilledMobsCount(QuestID, MobID)
 
	for index=0,GetQuestManager():GetKillMonsterDataSize() - 1 do
		local temp = GetQuestManager():GetKillMonsterDataByIndex(index);
		if(nil == QuestID and index.NPC_ID == MobID)
		then
			return index.KilledMonstersCount;
		end;	
	end;
return -1;
end;
 
local MaxMobsCount = 40;
while(KilledMobsCount(6666, 666) ~= MaxMobsCount)
do
Sleep(5000);
 
end;