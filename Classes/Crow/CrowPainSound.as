
f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if (damage != 1.45f) //sound for anything 2 heart+
	{
		Sound::Play("CrowCrow"+(XORRandom(2)+1)+".ogg", this.getPosition(), 1.0f, 1.0f);
	}

	return damage;
}
