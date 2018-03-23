#include "Hitters.as";
#include "CustomBlocks.as";

uint start_blizzard = 5000 + XORRandom(5000);
uint end_blizzard = start_blizzard + 5000 + XORRandom(6000);
//uint start_blizzard = 300;
//uint end_blizzard = start_blizzard + 7000;
uint last_start = 0;
uint last_end = 0;
uint special = 0;
f32 modifier_raw = 1;
f32 modifier = 1;
/*
void onInit(CRules@ this)
{
	u32 time = getGameTime();
	
	start_blizzard = time + 5000 + XORRandom(50000);
	end_blizzard = start_blizzard + 5000 + XORRandom(6000);
}*/

void onRestart(CRules@ this)
{
	u32 time = getGameTime();
	
	start_blizzard = time + 2000 + XORRandom(2000);
	end_blizzard = start_blizzard + 1500 + XORRandom(300);
}

void onTick(CRules@ this)
{
	if (getNet().isServer())
	{
		u32 time = getGameTime();
//*******Blizzard*******Blizzard*******Blizzard*******Blizzard*******Blizzard*******Blizzard*******Blizzard*******Blizzard*******
		if (time == start_blizzard)
		{
			CBlob@ blizzard = server_CreateBlobNoInit("blizzard");
			blizzard.Init();
			blizzard.server_SetTimeToDie((end_blizzard - start_blizzard) / 30);
			
			last_start = start_blizzard;
			last_end = end_blizzard;
			
			start_blizzard = end_blizzard + 5000 + XORRandom(5000);
			end_blizzard = start_blizzard + 5000 + XORRandom(6000);
		}
		if (getGameTime()-last_start < last_end-getGameTime())
			special = getGameTime()-last_start;
		else
			special = last_end-getGameTime();

		CBlob@[] blizzard;
		getBlobsByName("blizzard", @blizzard);
			
		if (blizzard.length != 0)
		{
			CBlob@ blob = getLocalPlayerBlob();
			//CBlob@ blizzardblob = blizzard[1];
			if (blob !is null)
			{
				Vec2f bpos = blob.getPosition();
				Vec2f hit;
				if (getMap().rayCastSolidNoBlobs(Vec2f(bpos.x, 0), bpos, hit))
				{
					f32 depth = Maths::Abs(bpos.y - hit.y) / 8.0f;
					modifier_raw = 1.0f - Maths::Clamp(depth / 8.0f, 0.25, 1);
				}
				else
				{
					modifier_raw = 1;
				}
			
				modifier = Lerp(modifier, modifier_raw, 0.02f);
			
			//this.getSprite().SetEmitSoundSpeed(0.5f + modifier * 0.5f);
			//blizzardblob.getSprite().SetEmitSoundVolume(0.30f + 0.10f * modifier);
			}
			if (getGameTime() % 2 != 0) return;
			CMap@ map = getMap();
			if (map is null || map.tilemapwidth < 2) return;

			f32 x = (XORRandom(12) == 0 ? -10 : (f32((getGameTime() * 40) % map.tilemapwidth) + 0.5f) * map.tilesize);
			if(x == -10) return;
			Vec2f bottom = Vec2f(x, map.tilemapheight * map.tilesize);
			Vec2f top = Vec2f(x, map.tilesize);
			Vec2f end;

			if (map.rayCastSolid(top, bottom, end))
			{
				f32 y = end.y;
				Vec2f pos = Vec2f(x, y -map.tilesize);
				if(y<=8) return;
				CBlob@[] blobs;
				map.getBlobsAtPosition(pos, blobs);
				bool spawn = true;
				for(int i; i < blobs.length; i++)
				{
					CBlob@ b = blobs[i];
					if(b !is null)
					{
						//if(b.getName() == "bush" || b.getName() == "flowers" || b.getName() == "grain_plant" || b.getName() == "seed")
						//	b.server_Die();
						if(b.getName() == "tree_pine" || b.getName() == "tree_bushy")
						{
							spawn = false;
							break;
						}
					}
				}
				if(spawn)
				{
					if(isTileSnowPile(map.getTile(pos).type))
						map.server_SetTile(pos, CMap::tile_snow);
					else
					{
						map.server_SetTile(pos, CMap::tile_snow_pile+XORRandom(5));
						//if(XORRandom(2) == 1) map.AddTileFlag(map.getTileOffset(pos), Tile::MIRROR);
					}
				}
			}
		}
//*******Blizzard*******Blizzard*******Blizzard*******Blizzard*******Blizzard*******Blizzard*******Blizzard*******Blizzard*******

//*******Aurora Borealis*******Aurora Borealis*******Aurora Borealis*******Aurora Borealis*******Aurora Borealis*****************

//*******Aurora Borealis*******Aurora Borealis*******Aurora Borealis*******Aurora Borealis*******Aurora Borealis*****************
	}
	//print("start: "+start_blizzard);
	//print("time:  "+getGameTime());
	//print("end:   "+end_blizzard);
	//print("special:   "+special);
	//error("modifier:         "+modifier);
}

f32 Lerp(f32 v0, f32 v1, f32 t) 
{
	return v0 + t * (v1 - v0);
}

void onRender(CRules@ this)
{
	CBlob@[] blizzard;
	getBlobsByName("blizzard", @blizzard);
			
	if (blizzard.length != 0 && getNet().isClient())
	{
		const f32 right = getScreenWidth();
		const f32 bottom = getScreenHeight();
		GUI::DrawRectangle(Vec2f_zero, Vec2f(right, bottom),
		                   SColor(Maths::Clamp(special*1.8f, 20, 40+modifier*180), 255, 255, 255));
	}
}