--マジカルシルクハット
---@param c Card
function c81210420.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCondition(c81210420.condition)
	e1:SetTarget(c81210420.target)
	e1:SetOperation(c81210420.activate)
	c:RegisterEffect(e1)
end
function c81210420.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c81210420.filter(c)
	return c:GetSequence()<5 and (c:IsPosition(POS_FACEDOWN_DEFENSE) or c:IsCanTurnSet())
end
function c81210420.spfilter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPE_MONSTER+TYPE_NORMAL,0,0,0,0,0,POS_FACEDOWN_DEFENSE)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEDOWN_DEFENSE)
end
function c81210420.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81210420.filter,tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c81210420.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function c81210420.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c81210420.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectMatchingCard(tp,c81210420.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g2:GetFirst()
	if not tc or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,2,2,nil)
	if tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		tc:ClearEffectRelation()
	end
	local tg=sg:GetFirst()
	local fid=e:GetHandler():GetFieldID()
	while tg do
		local e1=Effect.CreateEffect(tg)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tg:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_RACE)
		e2:SetValue(RACE_ALL)
		tg:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
		e3:SetValue(0xff)
		tg:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(0)
		tg:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(0)
		tg:RegisterEffect(e5,true)
		tg:RegisterFlagEffect(81210420,RESET_EVENT+0x47c0000+RESET_PHASE+PHASE_BATTLE,0,1,fid)
		tg:SetStatus(STATUS_NO_LEVEL,true)
		tg=sg:GetNext()
	end
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE)
	Duel.ConfirmCards(1-tp,sg)
	sg:AddCard(tc)
	Duel.ShuffleSetCard(sg)
	sg:RemoveCard(tc)
	sg:KeepAlive()
	local de=Effect.CreateEffect(e:GetHandler())
	de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	de:SetCode(EVENT_PHASE+PHASE_BATTLE)
	de:SetReset(RESET_PHASE+PHASE_BATTLE)
	de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	de:SetCountLimit(1)
	de:SetLabel(fid)
	de:SetLabelObject(sg)
	de:SetOperation(c81210420.desop)
	Duel.RegisterEffect(de,tp)
end
function c81210420.desfilter(c,fid)
	return c:GetFlagEffectLabel(81210420)==fid
end
function c81210420.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local fid=e:GetLabel()
	local tg=g:Filter(c81210420.desfilter,nil,fid)
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
	local tg2=tg:Filter(c81210420.desfilter,nil,fid)
	Duel.SendtoGrave(tg2,REASON_EFFECT)
end
