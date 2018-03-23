#include "Hitters.as";
#include "Knocked.as";
#include "ThrowCommon.as";

void onInit(CBlob@ this)
{
	this.set_f32("gib health", 0.0f);
	
	this.set_f32("nextcrow", getGameTime()+100+XORRandom(50));

	this.Tag("player");
	this.Tag("flesh");

	CShape@ shape = this.getShape();
	shape.SetRotationsAllowed(false);
	shape.getConsts().net_threshold_multiplier = 0.5f;

	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().removeIfTag = "dead";
}

void onSetPlayer(CBlob@ this, CPlayer@ player)
{
	if(player !is null)
	{
		player.SetScoreboardVars("ScoreboardIcons.png", 5, Vec2f(16, 16));
	}
}

void onTick(CBlob@ this)
{
	if(!getNet().isClient())
		return;
	if(this.isInInventory())
		return;

	const bool ismyplayer = this.isMyPlayer();

	if(ismyplayer && getHUD().hasMenus()) return;

	if(ismyplayer)
	{
		if(this.isKeyJustPressed(key_action3))
		{
			CBlob@ carried = this.getCarriedBlob();
			if(carried !is null)
			{
				client_SendThrowCommand(this);
			}
		}
	}
	
	u32 time = getGameTime();
	if (this.get_f32("nextcrow") == time)
	{
		this.set_f32("nextcrow", time+100+XORRandom(50));
		Sound::Play("CrowCrow"+(XORRandom(2)+1)+".ogg", this.getPosition(), 1.0f, 1.0f + ((XORRandom(7)-3)/10));
	}
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
    if (!getNet().isServer())
		return;
}

CPlayer@ ResolvePlayer( CBitStream@ data )
{
    u16 playerNetID;
	if(!data.saferead_u16(playerNetID))
		return null;
	
	return getPlayerByNetworkId(playerNetID);
}