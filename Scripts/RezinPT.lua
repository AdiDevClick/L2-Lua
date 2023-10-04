SCONFIG = L2TConfig.GetConfig();

ResSkillId = 1016; -- Resurrection

local area = GetPlayerList();
target = nil

    for user in area.list do	
    if (user:IsMyPartyMember() == true and user:IsAlikeDeath() == true and GetMe():IsAlikeDeath() == false) then
        target = user
    while (user:IsMyPartyMember() == true and user:IsAlikeDeath() == true and GetMe():IsAlikeDeath() == false and ResSkill ~= nil and
        ResSkill:CanBeUsed()) do
            Target(t)
            Sleep(500);
            UseSkillRaw(1016, false, false); -- Resurrection
            Sleep(500);
            ClearTargets();
            CancelTarget(false);
            CancelTarget(false);
            CancelTarget(false);
            end;
        break;
    end;
end;