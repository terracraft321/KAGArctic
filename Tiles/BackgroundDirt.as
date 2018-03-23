/*#include "CustomBlocks.as"

#define SERVER_ONLY

BackgroundBlocks@[] backgroundtiles;

shared class BackgroundBlocks
{
	int offset;

	BackgroundBlocks() {};

	BackgroundBlocks(int _offset)
	{
		offset = _offset;
	};
};

bool started = false;

void onInit(CRules@ this)
{
	onRestart(this);
}

void onRestart(CRules@ this)
{
	this.addCommandID("tile_removed");
	this.addCommandID("tile_placed");
}

void onCommand(CRules@ this, u8 cmd, CBitStream @params)
{
	CMap@ map = getMap();
	if (cmd == this.getCommandID("tile_removed"))
	{
		int offset = params.read_s32();
		for (u32 f = 0; f < backgroundtiles.length; f++)
		{
			if (offset == backgroundtiles[f].offset)
			{
				map.server_SetTile(map.getTileWorldPosition(offset), CMap::tile_ground_back);
				return;
			}
		}
	}
	else if (cmd == this.getCommandID("tile_placed"))
	{
		int offset = params.read_s32();
		for (u32 f = 0; f < backgroundtiles.length; f++)
		{
			if (offset == backgroundtiles[f].offset)
			{
				map.SetTileSupport(offset, -1);
				return;
			}
		}
	}
}

void onTick(CRules@ this)
{
	if (!started)
	{
		CMap@ map = getMap();
		if(map !is null)
		{
			for(int i; i < map.tilemapheight * map.tilemapwidth; i++)
			{
				TileType t = map.getTile(i).type;
				if(t == CMap::tile_purple_grass_dirt || t == CMap::tile_yellow_grass_dirt || t == CMap::tile_red_grass_dirt)
				{
					backgroundtiles.push_back(BackgroundBlocks(i));
					print("offsets: "+i);
				}
			}
		}
		started = true;
	}
}

bool isBackgroundBehind(u32 offset)
{
	for (u32 f = 0; f < backgroundtiles.length; f++)
	{
		print("values: "+offset+" : "+backgroundtiles[f].offset);
		if (offset == backgroundtiles[f].offset)
		{
			print("true");
			return true;
		}
	}
	print("length: "+backgroundtiles.length);
	print("offset: "+offset);
	print("false");
	return false;
}


void onRender(CRules@ this)
{
	if(v_fastrender) return;
	//if (getGameTime() % 5 != 0) return;
	CMap@ map = getMap();
	if(map !is null)
	{
		Driver@ driver = getDriver();
		CCamera@ camera = getCamera();
		for(int i = 0; i < mattertiles.length; i++)
		{
			int num = 0;
			Vec2f tilepos = map.getTileWorldPosition(mattertiles[i].offset);
			for(int t = 0; t < 4; t++)
			{
				if(map.isTileSolid(tilepos + directions[t]))
					num++;
			}
			if(num != 4)
			{
				Vec2f position = driver.getScreenPosFromWorldPos(tilepos);
				if(position.x >= 0 && position.x <= driver.getScreenWidth() && position.y >= 0 && position.y <= driver.getScreenHeight() && (tilepos-camera.getPosition()).getLength() < 150)
				{
					int frame = (((camera.getPosition().x/4)+(camera.getPosition().y/4)) % 3);
					//CParticle@ spark = ParticleAnimated("MatterSparks"+frame+".png", mattertiles[i].position+Vec2f(4, 4), Vec2f(0, 0), 0.0f, 1.0f, 2, 0.0f, false);
					//if (spark !is null)
					//{
					//	spark.Z = 1000;
						//spark.deadeffect = 0;
					//	spark.fadeout = true;
					//}
					//GUI::DrawIcon("world.png", CMap::spark_v0+frame, Vec2f(8, 8), position, 1.0f);
					//GUI::DrawIcon("world.png", CMap::spark_v0+frame, Vec2f(8, 8), position, camera.targetDistance, SColor(255, 255, 255, 255));
					map.DrawTile(tilepos, CMap::spark_v0+frame, SColor(255, 255, 255, 255), camera.targetDistance, false);
				}
			}
		}
	}
}
*/