int timetodie = 0;
int special = 0;

void onInit(CBlob@ this)
{
	this.getShape().SetStatic(true);
	this.getCurrentScript().tickFrequency = 1;
	
	this.getShape().SetRotationsAllowed(true);
	
	getMap().CreateSkyGradient("skygradient_blizzard.png");
	
	if (getNet().isServer())
	{
		this.server_SetTimeToDie(20);
		timetodie = this.getTimeToDie()*30;
	}
	special = 0;
	offsety = 0;
}

const int spritesize = 256;
f32 speed = 5.0f;
f32 offsety = 0;
f32 modifier_raw = 1;
f32 modifier = 1;

void onInit(CSprite@ this)
{
	this.getConsts().accurateLighting = false;
	
	if (getNet().isClient())
	{
		Vec2f size = Vec2f(6, 5);
		
		for (int y = 0; y < size.y; y++)
		{
			for (int x = 0; x < size.x; x++)
			{
				CSpriteLayer@ l = this.addSpriteLayer("l_x" + x + "y" + y, "Blizzard.png", spritesize, spritesize, this.getBlob().getTeamNum(), 0);
				l.SetOffset(Vec2f(x * spritesize, y * spritesize) - (Vec2f(size.x * spritesize, size.y * spritesize) / 2));
				l.SetLighting(false);
				l.SetRelativeZ(-600);
			}
		}
		
		this.SetEmitSound("blizzard_loop.ogg");
		this.SetEmitSoundPaused(false);
	}
}

void onTick(CBlob@ this)
{
	if (getNet().isServer())
	{
		if(timetodie-this.getTickSinceCreated() > this.getTickSinceCreated())
			special = this.getTickSinceCreated();
		else
			special = (timetodie-this.getTickSinceCreated());
	}
	if (getNet().isClient())
	{
		CBlob@ blob = getLocalPlayerBlob();
		CSprite@ sprite = this.getSprite();
		if (blob !is null)
		{
			Vec2f bpos = blob.getPosition();
			Vec2f pos = Vec2f(int(bpos.x / spritesize) * spritesize, int(bpos.y / spritesize) * spritesize); 
			this.setPosition(pos);
			//this.getSprite().SetEmitSoundPlayPosition(getMap().getTileOffset(bpos));

			Vec2f size = Vec2f(6, 5);
			f32 sine = Maths::Sin(getGameTime() * 0.0025f);
			speed = 6.0f + sine * 3.0f;
			
			this.getSprite().SetEmitSoundSpeed(0.5f + sine * 0.5f);
			
			Vec2f hit;
			if (getMap().rayCastSolidNoBlobs(Vec2f(bpos.x, 0), bpos, hit))
			{
				f32 depth = Maths::Abs(bpos.y - hit.y) / 8.0f;
				modifier_raw = 1.0f - Maths::Clamp(depth / 8.0f, 0.25, 1);
				
				// print("underground: " + modifier);
			}
			else
			{
				modifier_raw = 1;
			}
			
			modifier = Lerp(modifier, modifier_raw, 0.06f);
			Vec2f fixpos = pos-bpos;
			f32 fix = fixpos.getLength();
			this.getSprite().SetEmitSoundVolume(3.30f + modifier + fix);
			print("modif: "+(3.30f + modifier + fix));
			
			this.getShape().SetAngleDegrees(30 + sine * 30.0f);

			offsety = offsety+speed;
			if(offsety >= spritesize)
				offsety = offsety-spritesize;

			for (int y = 0; y < size.y; y++)
			{
				for (int x = 0; x < size.x; x++)
				{
					CSpriteLayer@ l = sprite.getSpriteLayer("l_x" + x + "y" + y);
					l.SetOffset(Vec2f(x * spritesize, y * spritesize) - (Vec2f(size.x * spritesize, size.y * spritesize) / 2) + Vec2f(0,offsety));
				}
			}
		}
	}
}

f32 Lerp(f32 v0, f32 v1, f32 t) 
{
	return v0 + t * (v1 - v0);
}

void onDie(CBlob@ this)
{
	getMap().CreateSkyGradient("skygradient.png");
}