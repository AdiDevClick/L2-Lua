-- Health % to consider target for Group Heal spells
local HealHP = 80
-- Health % to consider target for standard Heal spells
local QuickHealHP = 50
-- Health % to consider target for Quick Heal spells
local GroupHealHP = 70

local Shield = 80

local RechargeMP = 40

local Rebirthparty = 10

local BalanceHP = 75

local UseSpiritOres = true

local SearchRadius = 1000

local HealPartyPets = true


------------------------------------------------
------------ END OF USER SETTINGS --------------
------------------------------------------------
function GetSkillIdByName(name)
	return GetSkillIdByName(name,nil)
end
function GetSkillIdByName(name,skills)
	if not skills then
		skills = GetSkills()
	end
	for s in skills.list do
		if s.name == name then
			return s.skillId
		end
	end
	return nil
end

local Rebirth   = 0
local Celestial = 0
local Salvation = 0
local Crystal   = 0
local Recharge  = 0
local Heal 		= 0
local MHeal 	= 0
local QuickHeal	= 0
local GroupHeal	= 0
local MGroupHeal= 0
local GroupHeal2= 0
local Equalizer	= 0

-- 3031	Spirit Ore
function UpdateSkills(inv)
	local skills = GetSkills()
	local gotOres = false
	if inv and UseSpiritOres then
		ores = inv:FindByDisplayId(3031)
		if ores and ores.ItemNum > 50 then
			gotOres = true
		end
	end
	
	Rebirth = 
		GetSkillIdByName("Rebirth", skills)
	Celestial = 
		GetSkillIdByName("Celestial Protection", skills) or
		GetSkillIdByName("Celestial Shield", skills) or
		GetSkillIdByName("Blessed Blood", skills)
	Salvation = 
		GetSkillIdByName("Emblem of Salvation", skills)
	Crystal = 
		GetSkillIdByName("Crystal Regeneration", skills) or
		GetSkillIdByName("Invocation", skills)
	Recharge =
		GetSkillIdByName("Radiant Recharge", skills) or
		GetSkillIdByName("Recharge", skills)
	MHeal =
		gotOres and GetSkillIdByName("Major Heal", skills)
	Heal = 
		GetSkillIdByName("Radiant Heal", skills) or 
		GetSkillIdByName("Greater Heal", skills) or 
		GetSkillIdByName("Heal", skills)
	QuickHeal = 
		GetSkillIdByName("Panic Heal", skills) or 
		GetSkillIdByName("Greater Battle Heal", skills) or 
		GetSkillIdByName("Battle Heal", skills)
	MGroupHeal = 
		gotOres and GetSkillIdByName("Major Group Heal", skills)
	GroupHeal = 
		GetSkillIdByName("Brilliant Heal", skills) or 
		GetSkillIdByName("Greater Group Heal", skills) or 
		GetSkillIdByName("Group Heal", skills)
	GroupHeal2 =
		GetSkillIdByName("Progressive Heal", skills) or 
		GetSkillIdByName("Body of Avatar", skills)
	Equalizer = 
		GetSkillIdByName("Balance Heal", skills) or 
		GetSkillIdByName("Balance Life", skills)
end
UpdateSkills(GetInventory())

function CastSpell(id)
 if id then
	 local skill = GetSkills():FindById(id)
	 if skill and skill:CanBeUsed() then
		 UseSkillRaw(id,false,false)
		 return true
	 end
 end
 return false
end

function CastHeal(id,tar,dist)
 if id and tar then
	 local skill = GetSkills():FindById(id)
	 if skill and skill:CanBeUsed() then
		for d=dist-50,50,-100 do
			if not tar or tar:GetHpPercent() == 0 then
				return false
			end
			if tar:GetDistance() > dist or not tar:CanSeeMe() then
				local loc = tar:GetLocation()
				MoveTo(loc.X, loc.Y, loc.Z, d)
				local tar = GetUserById(tar:GetId())
			end
		end
		 --old = GetTarget()
		 Target(tar)
		 UseSkillRaw(id,false,false)
		 if old then
			Sleep(300)
			Target(old)
		 end
		 return true
	 end
 end
 return false
end

function PetBelongsToParty( pet )
	if pet then
		party = GetPartyList()
		for p in party.list do
			if p:GetName() == pet:GetMasterName() then
				return true
			end
		end
	end
	return false
end

function ProcessHealingTarget(p, nH, nQH, nGH, RR, BH, Celes, Re, HPTreshold, quickHPTreshold, groupHPTreshold, MPTreshold, BalanceTreshold, ShieldTreshold, MPTreslow, searchRadius )
	if p and p:GetDistance() <= 1000 then
		-- Group Heal
		if p:GetHpPercent() < groupHPTreshold or p:GetCpPercent() < 80 then
			nGH[nGH[0].n + 1] = p
			if not nGH[0].u or p:GetHpPercent() < nGH[0].hp or p:GetCpPercent() < nGH[0].cp then
				nGH[0].id = p:GetId()
				nGH[0].u = p
				nGH[0].hp = p:GetHpPercent()
				nGH[0].cp = p:GetCpPercent()
			end
			nGH[0].n = nGH[0].n + 1
		end
		
			-- Quick Heal
		if p:GetHpPercent() < quickHPTreshold or p:GetCpPercent() < 80 and
					(p:GotBuff(11758) == false or
					p:GotBuff(11759) == false or 
					p:GotBuff(11765) == false) and
					p:IsAlikeDeath() == false then
				nQH[nQH[0].n + 1] = p
				if not nQH[0].u or p:GetHpPercent() < nQH[0].hp or p:GetCpPercent() < nQH[0].cp then
					nQH[0].id = p:GetId()
					nQH[0].u = p
					nQH[0].hp = p:GetHpPercent()
					nQH[0].cp = p:GetCpPercent()
				end
				nQH[0].n = nQH[0].n + 1
			else
		
			-- Balance Heal
		if p:GetHpPercent() < BalanceTreshold and
					  (p:GotBuff(11758) == false or
					   p:GotBuff(11759) == false) and
					   p:IsAlikeDeath() == false then
				BH[BH[0].n + 1] = p
				if not BH[0].u or p:GetHpPercent() < BH[0].hp then
					BH[0].id = p:GetId()
					BH[0].u = p
					BH[0].hp = p:GetHpPercent()				
				end
				BH[0].n = BH[0].n + 1
			else	
		
			-- Recharge Heal
		if p:GetMpPercent() < MPTreshold and
					(p:GotBuff(11758) == false or
					p:GotBuff(11759) == false) and
					p:IsAlikeDeath() == false and
					(p:GetClass() == 117 or
					p:GetClass() == 55 or
					p:GetClass() == 132 or
					p:GetClass() == 139 or
					p:GetClass() == 100 or					
					p:GetClass() == 97 or
					p:GetClass() == 16 or
					p:GetClass() == 21 or
					p:GetClass() == 140 or
					p:GetClass() == 141 or 
					p:GetClass() == 142 or
					p:GetClass() == 144 or
					p:GetClass() == 145) and 
					GetMe():GetMpPercent() > 10 then
					RR[RR[0].n + 1] = p
				if not RR[0].u or p:GetMpPercent() < RR[0].mp then
					RR[0].id = p:GetId()
					RR[0].u = p
					RR[0].mp = p:GetMpPercent()				
				end
				RR[0].n = RR[0].n + 1
			else
		
			-- Rebirth
		if p:GetMpPercent() < MPTreslow and
					(p:GotBuff(11759) == false or
					p:GotBuff(11758) == false or 
					p:GotBuff(11765) == false) and
					p:IsAlikeDeath() == false then
					Re[Re[0].n + 1] = p
				if not Re[0].u or p:GetMpPercent() < Re[0].mp then
					Re[0].id = p:GetId()
					Re[0].u = p
					Re[0].mp = p:GetMpPercent()				
				end
				Re[0].n = Re[0].n + 1
			else
		
			-- Salvation
		if	  GetMe():GetClass() == 146 and
			  (GetMe():GotBuff(11826) == false) and
			  GetSkills():FindById(11826) ~= nil and
			  GetSkills():FindById(11826):CanBeUsed() then
			  CastHeal(Salvation, GetMe(), 900)				
		else 
					
			
			-- Crystal Regen
		if (GetMe():GetMpPercent() <= 90 or
			  GetMe():GetHpPercent() <= 50 ) and 
			  GetSkills():FindById(11765):CanBeUsed() then
			  CastSpell(Crystal) -- Crystal Regeneration
			  
		else
		
			-- Celestial Shield
		if p:GetCpPercent() <= 50 or
			  p:GetHpPercent() < Shield and
			  (p:GotBuff(11758) == false or
			  p:GotBuff(11759) == false or
			  p:GotBuff(11765) == false or
			  p:GotBuff(11833) == false) then
				Celes[Celes[0].n + 1] = p
				if not Celes[0].u or p:GetHpPercent() < Celes[0].hp or p:GetCpPercent() < Celes[0].cp then
					Celes[0].id = p:GetId()
					Celes[0].u = p
					Celes[0].hp = p:GetHpPercent()
					Celes[0].cp = p:GetCpPercent()	
				end
				Celes[0].n = Celes[0].n + 1
			else
			
			-- normal Heal
		if p:GetHpPercent() < HPTreshold or p:GetCpPercent() < 80 and
					(p:GotBuff(11758) == false or
					p:GotBuff(11759) == false or 
					p:GotBuff(11765) == false) and
					p:IsAlikeDeath() == false then
				nH[nH[0].n + 1] = p
				if not nH[0].u or p:GetHpPercent() < nH[0].hp or p:GetCpPercent() < nH[0].cp then
					nH[0].id = p:GetId()
					nH[0].u = p
					nH[0].hp = p:GetHpPercent()
					nH[0].cp = p:GetCpPercent()
				end
				nH[0].n = nH[0].n + 1
			end
			
		end
		end
		end
	end
	end
	end
	end
	end
	return nH, nQH, nGH, RR, BH, Celes, Re
end

function GetHealingTargets( HPTreshold, quickHPTreshold, groupHPTreshold, MPTreshold, BalanceTreshold, ShieldTreshold, MPTreslow, searchRadius )

	local party = GetPartyList()
	partyInfo = { count = 0 }

	local nH = {} -- Need Heal
	nH[0] = {}
	nH[0].n = 0
	local nQH = {} -- Need Quick Heal
	nQH[0] = {}
	nQH[0].n = 0
	local nGH = {} -- Need Group Heal
	nGH[0] = {}
	nGH[0].n = 0
	local RR = {} -- Radiant Recharge
	RR[0] = {}
	RR[0].n = 0
	local BH = {} -- Balance Heal
	BH[0] = {}
	BH[0].n = 0
	local Celes = {} -- Celestial Shield
	Celes[0] = {}
	Celes[0].n = 0
	local Re = {} -- Rebirth
	Re[0] = {}
	Re[0].n = 0
	
	for p in party.list do
		hpp = p:GetHpPercent()
		cpp = p:GetCpPercent()
		mpp = p:GetMpPercent()
		if hpp > 0 and cpp > 0 and mpp > 0 then
			partyInfo.count = partyInfo.count + 1
		end
		nH, nQH, nGH, RR, BH, Celes, Re = ProcessHealingTarget(p, nH, nQH, nGH, RR, BH, Celes, Re, HPTreshold, quickHPTreshold, groupHPTreshold, MPTreshold, BalanceTreshold, ShieldTreshold, MPTreslow, searchRadius)
	end
	
	p = GetMe()
	if p then
		hpp = p:GetHpPercent()
		cpp = p:GetCpPercent()
		mpp = p:GetMpPercent()
		if hpp > 0 and cpp > 0 and mpp > 0 then
			partyInfo.count = partyInfo.count + 1
		end
		nH, nQH, nGH, RR, BH, Celes, Re = ProcessHealingTarget(p, nH, nQH, nGH, RR, BH, Celes, Re, HPTreshold, quickHPTreshold, groupHPTreshold, MPTreshold, BalanceTreshold, ShieldTreshold, MPTreslow, searchRadius)
	end
	
	if HealPartyPets then
		pets = GetPetList()
		for p in pets.list do
			if PetBelongsToParty( pet ) then
				nH, nQH, nGH, RR, BH, Celes, Re = ProcessHealingTarget(p, nH, nQH, nGH, RR, BH, Celes, Re, HPTreshold, quickHPTreshold, groupHPTreshold, MPTreshold, BalanceTreshold, ShieldTreshold, MPTreslow, searchRadius)
			end
		end
	end
	
	return nH, nQH, nGH, RR, BH, Celes, Re, partyInfo
end




function TickHeal()
	local nH, nQH, nGH, RR, BH, Celes, Re, pI = GetHealingTargets( HealHP, QuickHealHP, GroupHealHP, RechargeMP, BalanceHP, Shield, Rebirthparty, 1000)
	if pI.count > 3 
		and CastHeal(GroupHeal2,BH[0].u, 1000) then
		return
		
	end
	

	if pI.count > 3 and
		CastHeal(GroupHeal,nQH[0].u or nH[0].u, 1000) then
		return
	end
	
	if BH[0].n and BH[0].n > 0 and 
	   CastSpell(Equalizer,BH[0].u, 1000) then
		return
	end
	
	if RR[0].n and RR[0].n > 0 and 
		CastHeal(Recharge,RR[0].u, 900) then
		return
	end
	
	if Celes[0].n and Celes[0].n > 0 and 
		CastHeal(Celestial,Celes[0].u, 900) then
		return
	end
	
	if Re[0].n and Re[0].n > 0 and 
		CastSpell(Rebirth) then
		return
	end
	
	if  nGH[0] and nGH[0].n and nGH[0].n >= 2 and
		nGH[0].hp and nGH[0].hp > 10 and nGH[0].cp and nGH[0].cp > 10 and 
		(CastSpell(MGroupHeal) or CastSpell(GroupHeal)) then
		return
	end
	if nQH[0].n and nQH[0].n > 0 and 
		CastHeal(QuickHeal,nQH[0].u, 700) then 
		return
	end
	
	if nH[0].n and 
		(nH[0].n > 0 
		or not QuickHeal and nQH[0].n and nQH[0].n > 0) and
		(CastHeal(MHeal,nH[0].u, 700) or CastHeal(Heal,nH[0].u, 700)) then
		return
	end
end
	
local counter = 0
repeat
	if not IsPaused() then
		TickHeal()
		if Counter == 0 then
			UpdateSkills(GetInventory())
		end
		counter = (counter + 1) % 20
	end
	Sleep(1500)
until false