-- At how much hp % should we heal pets?
minHealthPercent = 90
-- max distance at which we will search for targets.
maxDistance = 800

function Heal()


		local me = GetMe()
		users = GetPlayerList()
		for user in users.list do	
				
		if (me ~= nil and me:IsAlikeDeath() == false) then

			if ((user:GetHpPercent() <= minHealthPercent) 
					and (user:IsAlikeDeath() == false)
					and (user:IsMyPartyMember() == true)
					and (GetSkills():FindById(11762) ~= nil)
					and (GetSkills():FindById(11762):CanBeUsed())) then
						user = GetUserById(user:GetId())
					end
				end
		end
return false	
end		
repeat
		toheal = Heal()
		if(toheal ~= nil)then
		Command("/useskill Balance Heal") -- Balance Life

	end
until false
			