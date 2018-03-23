#include "DummyCommon.as";
#include "ParticleSparks.as";
#include "CustomBlocks.as";
//#include "BackgroundDirt.as";

//bool commandsinitialized = false;

void onInit(CMap@ this)
{
	this.legacyTileMinimap = false;
	this.MakeMiniMap();/*
	CRules@ rules = getRules();
	rules.addCommandID("tile_removed");
	rules.addCommandID("tile_placed");
	commandsinitialized = true;*/
}

void CalculateMinimapColour( CMap@ this, u32 offset, TileType tile, SColor &out col)
{
    if (this.isTileSolid(tile) || isTileCustomSolid(tile))
	{
		if ((!(this.isTileSolid(this.getTile(offset-1).type) || isTileCustomSolid(this.getTile(offset-1).type))) || 
			(!(this.isTileSolid(this.getTile(offset+1).type) || isTileCustomSolid(this.getTile(offset+1).type))) || 
			(!(this.isTileSolid(this.getTile(offset-this.tilemapwidth).type) || isTileCustomSolid(this.getTile(offset-this.tilemapwidth).type))) || 
			(!(this.isTileSolid(this.getTile(offset+this.tilemapwidth).type) || isTileCustomSolid(this.getTile(offset+this.tilemapwidth).type)))) col = SColor(0xff844715);
		else col = SColor(0xffC4873A);
	}
	else if (!this.isTileSolid(tile) && tile != 0 && !isGrassTile(tile) && !isTileCustomSolid(tile))
	{
		if( (this.getTile(offset-1).type == 0) || 
			(this.getTile(offset+1).type == 0) || 
			(this.getTile(offset-this.tilemapwidth).type == 0) || 
			(this.getTile(offset+this.tilemapwidth).type == 0)) col = SColor(0xffC4873A);
		else col = SColor(0xffF3AC5C);
	}
	else col = SColor(0xffEDCCA6);

	if (this.isInWater(this.getTileWorldPosition(offset)))
	{
		col = col.getInterpolated(SColor(255,29,133,171),0.5f);
	}
	else if (this.isInFire(this.getTileWorldPosition(offset)))
	{
		col = col.getInterpolated(SColor(255,239,67,47),0.5f);
	}
}

bool onMapTileCollapse(CMap@ map, u32 offset)
{
	if(map.getTile(offset).type > 255 && map.getTile(offset).type < 262)
	{
		CBlob@ blob = getBlobByNetworkID(server_getDummyGridNetworkID(offset));
		if(blob !is null)
		{
			blob.server_Die();
		}
	}
	if(map.getTile(offset).type >= CMap::tile_ice && map.getTile(offset).type <= CMap::tile_ice_v2)
		return false;

	if( (map.getTile(offset).type >= CMap::tile_snow && map.getTile(offset).type <= CMap::tile_snow_d1) ||
		(map.getTile(offset).type >= CMap::tile_snow_brick && map.getTile(offset).type <= CMap::tile_snow_brick_d4) ||
		(map.getTile(offset).type >= CMap::tile_snow_brick_back && map.getTile(offset).type <= CMap::tile_snow_brick_back_d4))
		snowparts(map.getTileWorldPosition(offset), 7 + XORRandom(5));
		
	if (isGrassTile(map.getTile(offset-map.tilemapwidth).type))
		map.server_SetTile(map.getTileWorldPosition(offset-map.tilemapwidth), CMap::tile_empty);
	/*
	CRules@ rules = getRules();
	CBitStream params;
	params.write_s32(offset);
	rules.SendCommand(rules.getCommandID("tile_removed"), params);
*/
	return true;
}

TileType server_onTileHit(CMap@ map, f32 damage, u32 index, TileType oldTileType)
{
	if(map.getTile(index).type > 261)
	{
		switch(oldTileType)
		{
			case CMap::tile_snow:
				return CMap::tile_snow_d0;

			case CMap::tile_snow_v0:
			case CMap::tile_snow_v1:
			case CMap::tile_snow_v2:
			case CMap::tile_snow_v3:
			case CMap::tile_snow_v4:
			case CMap::tile_snow_v5:
			case CMap::tile_snow_v6:
			case CMap::tile_snow_v7:
			case CMap::tile_snow_v8:
			case CMap::tile_snow_v9:
			case CMap::tile_snow_v10:
			case CMap::tile_snow_v11:
			case CMap::tile_snow_v12:
			case CMap::tile_snow_v13:
			case CMap::tile_snow_v14:
			{
				Vec2f pos = map.getTileWorldPosition(index);
				
				map.server_SetTile(pos, CMap::tile_snow_d0);

				for (u8 i = 0; i < 4; i++)
				{
					snow_Update(map, pos + directions[i]);
				}
				return CMap::tile_snow_d0;
			}

			case CMap::tile_snow_d0:
				return CMap::tile_snow_d1;

			case CMap::tile_grass_purple:
				return CMap::tile_grass_purple_d0;

			case CMap::tile_grass_yellow:
				return CMap::tile_grass_yellow_d0;

			case CMap::tile_grass_red:
				return CMap::tile_grass_red_d0;

			case CMap::tile_purple_grass_dirt:
			case CMap::tile_yellow_grass_dirt:
			case CMap::tile_red_grass_dirt:
				return CMap::tile_ground_d1;

			case CMap::tile_snow_brick:
			case CMap::tile_snow_brick_d0:
			case CMap::tile_snow_brick_d1:
			case CMap::tile_snow_brick_d2:
			case CMap::tile_snow_brick_d3:
			case CMap::tile_snow_brick_back:
			case CMap::tile_snow_brick_back_d0:
			case CMap::tile_snow_brick_back_d1:
			case CMap::tile_snow_brick_back_d2:
			case CMap::tile_snow_brick_back_d3:
			case CMap::tile_grass_purple_d0:
			case CMap::tile_grass_purple_d1:
			case CMap::tile_grass_yellow_d0:
			case CMap::tile_grass_yellow_d1:
			case CMap::tile_grass_red_d0:
			case CMap::tile_grass_red_d1:
				return oldTileType+1;

			case CMap::tile_ice:
			case CMap::tile_ice_v0:
			case CMap::tile_ice_v1:
			case CMap::tile_ice_v2:
			case CMap::tile_snow_d1:
			case CMap::tile_snow_brick_d4:
			case CMap::tile_snow_brick_back_d4:
			case CMap::tile_snow_pile:
			case CMap::tile_snow_pile_v0:
			case CMap::tile_snow_pile_v1:
			case CMap::tile_snow_pile_v2:
			case CMap::tile_snow_pile_v3:
			case CMap::tile_grass_purple_d2:
			case CMap::tile_grass_yellow_d2:
			case CMap::tile_grass_red_d2:
			case CMap::tile_ice_spike:
			case CMap::tile_ice_spike_v0:
				return CMap::tile_empty;
		}
	}
	return map.getTile(index).type;
}

void onSetTile(CMap@ map, u32 index, TileType tile_new, TileType tile_old)
{
	if(tile_new > 255 && tile_new < CMap::tile_ice)
	{
		map.SetTileSupport(index, 10);

		switch(tile_new)
		{
			case Dummy::SOLID:
			case Dummy::OBSTRUCTOR:
				map.AddTileFlag(index, Tile::SOLID | Tile::COLLISION);
				break;
			case Dummy::BACKGROUND:
			case Dummy::OBSTRUCTOR_BACKGROUND:
				map.AddTileFlag(index, Tile::BACKGROUND | Tile::LIGHT_PASSES | Tile::WATER_PASSES);
				break;
			case Dummy::LADDER:
				map.AddTileFlag(index, Tile::BACKGROUND | Tile::LIGHT_PASSES | Tile::LADDER | Tile::WATER_PASSES);
				break;
			case Dummy::PLATFORM:
				map.AddTileFlag(index, Tile::PLATFORM);
				break;
		}
	}

	switch(tile_new)
	{		
		case CMap::tile_ice:
		{
			map.SetTileSupport(index, 10);

			Vec2f pos = map.getTileWorldPosition(index);
			OnIceTileUpdate(false, true, map, pos);

			bool isLeft = (map.getTile(pos-Vec2f(8.0f, 0.0f)).type >= CMap::tile_ice && map.getTile(pos-Vec2f(8.0f, 0.0f)).type <= CMap::tile_ice_v2) ? true : false;
			bool isRight = (map.getTile(pos+Vec2f(8.0f, 0.0f)).type >= CMap::tile_ice && map.getTile(pos+Vec2f(8.0f, 0.0f)).type <= CMap::tile_ice_v2) ? true : false;

			if(isLeft && isRight)
				map.SetTile(index, CMap::tile_ice_v1);
			else if(isLeft || isRight)
			{
				if(isLeft && !isRight)
					map.SetTile(index, CMap::tile_ice_v2);
				if(!isLeft && isRight)
					map.SetTile(index, CMap::tile_ice_v0);
			}
			map.AddTileFlag(index, Tile::LIGHT_PASSES | Tile::SOLID | Tile::COLLISION | Tile::WATER_PASSES);
			map.RemoveTileFlag(index, Tile::LIGHT_SOURCE);
			break;
		}

		case CMap::tile_ice_v0:
		case CMap::tile_ice_v1:
		case CMap::tile_ice_v2:
		{
			map.AddTileFlag(index, Tile::LIGHT_PASSES | Tile::SOLID | Tile::COLLISION | Tile::WATER_PASSES);
			map.RemoveTileFlag(index, Tile::LIGHT_SOURCE);
			break;
		}
		
		case CMap::tile_snow:
		{
			map.SetTileSupport(index, 15);
			Vec2f pos = map.getTileWorldPosition(index);
			snow_SetTile(map, pos);
			map.AddTileFlag(index, Tile::SOLID | Tile::COLLISION);
			map.RemoveTileFlag(index, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
			break;
		}
		
		case CMap::tile_snow_v0:
		case CMap::tile_snow_v1:
		case CMap::tile_snow_v2:
		case CMap::tile_snow_v3:
		case CMap::tile_snow_v4:
		case CMap::tile_snow_v5:
		case CMap::tile_snow_v6:
		case CMap::tile_snow_v7:
		case CMap::tile_snow_v8:
		case CMap::tile_snow_v9:
		case CMap::tile_snow_v10:
		case CMap::tile_snow_v11:
		case CMap::tile_snow_v12:
		case CMap::tile_snow_v13:
		{
			map.SetTileSupport(index, 15);
			map.AddTileFlag(index, Tile::SOLID | Tile::COLLISION);
			map.RemoveTileFlag(index, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
			break;
		}
		case CMap::tile_snow_v14:
		{
			map.SetTileSupport(index, 15);
			if((index / map.tilemapwidth + index % map.tilemapwidth) % 2 == 0) map.AddTileFlag(index, Tile::MIRROR);
			map.AddTileFlag(index, Tile::SOLID | Tile::COLLISION);
			map.RemoveTileFlag(index, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
			break;
		}
		
		case CMap::tile_snow_d0:
		case CMap::tile_snow_d1:
		{
			map.SetTileSupport(index, 15);
			map.AddTileFlag(index, Tile::SOLID | Tile::COLLISION);
			map.RemoveTileFlag(index, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
			OnSnowTileHit(map, index);
			break;
		}
		
		case CMap::tile_snow_brick:
		{
			map.SetTileSupport(index, 15);
			Vec2f pos = map.getTileWorldPosition(index);
			if (getNet().isClient()) Sound::Play("build_wall2.ogg", pos, 1.0f, 1.0f);
			if(pos.y % 2 == 0) map.AddTileFlag(index, Tile::MIRROR);
			map.AddTileFlag(index, Tile::SOLID | Tile::COLLISION);
			map.RemoveTileFlag(index, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
			break;
		}
		
		case CMap::tile_snow_brick_d0:
		case CMap::tile_snow_brick_d1:
		case CMap::tile_snow_brick_d2:
		case CMap::tile_snow_brick_d3:
		case CMap::tile_snow_brick_d4:
		{
			map.SetTileSupport(index, 15);
			Vec2f pos = map.getTileWorldPosition(index);
			if(pos.y % 2 == 0) map.AddTileFlag(index, Tile::MIRROR);
			map.AddTileFlag(index, Tile::SOLID | Tile::COLLISION);
			map.RemoveTileFlag(index, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
			OnSnowBrickTileHit(map, index);
			break;
		}
		
		case CMap::tile_snow_brick_back:
		{
			map.SetTileSupport(index, 15);
			Vec2f pos = map.getTileWorldPosition(index);
			if (getNet().isClient()) Sound::Play("build_wall2.ogg", pos, 1.0f, 1.0f);
			if(pos.y % 2 == 0) map.AddTileFlag(index, Tile::MIRROR);
			map.AddTileFlag(index, Tile::BACKGROUND | Tile::LIGHT_PASSES);
			map.RemoveTileFlag(index, Tile::LIGHT_SOURCE | Tile::COLLISION | Tile::SOLID);
			break;
		}
		
		case CMap::tile_snow_brick_back_d0:
		case CMap::tile_snow_brick_back_d1:
		case CMap::tile_snow_brick_back_d2:
		case CMap::tile_snow_brick_back_d3:
		case CMap::tile_snow_brick_back_d4:
		{
			map.SetTileSupport(index, 15);
			Vec2f pos = map.getTileWorldPosition(index);
			if(pos.y % 2 == 0) map.AddTileFlag(index, Tile::MIRROR);
			map.AddTileFlag(index, Tile::BACKGROUND | Tile::LIGHT_PASSES);
			map.RemoveTileFlag(index, Tile::LIGHT_SOURCE | Tile::COLLISION | Tile::SOLID);
			OnSnowBrickTileHit(map, index);
			break;
		}
		
		case CMap::tile_snow_pile:
		case CMap::tile_snow_pile_v0:
		case CMap::tile_snow_pile_v1:
		case CMap::tile_snow_pile_v2:
		case CMap::tile_snow_pile_v3:
		{
			map.SetTileSupport(index, 0);
			if(XORRandom(2) == 1) map.AddTileFlag(index, Tile::MIRROR);
			map.AddTileFlag(index, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
			map.RemoveTileFlag(index, Tile::SOLID | Tile::COLLISION);
			break;
		}
		
		case CMap::tile_grass_purple:
		case CMap::tile_grass_yellow:
		case CMap::tile_grass_red:
		{
			map.SetTileSupport(index, 0);
			map.AddTileFlag(index, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
			map.RemoveTileFlag(index, Tile::SOLID | Tile::COLLISION);
			break;
		}
		
		case CMap::tile_grass_purple_d0:
		case CMap::tile_grass_purple_d1:
		case CMap::tile_grass_purple_d2:
		{
			map.SetTileSupport(index, 0);
			map.AddTileFlag(index, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
			map.RemoveTileFlag(index, Tile::SOLID | Tile::COLLISION);
			OnGrassTileHit(map, index, 0);
			break;
		}
		case CMap::tile_grass_yellow_d0:
		case CMap::tile_grass_yellow_d1:
		case CMap::tile_grass_yellow_d2:
		{
			map.SetTileSupport(index, 0);
			map.AddTileFlag(index, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
			map.RemoveTileFlag(index, Tile::SOLID | Tile::COLLISION);
			OnGrassTileHit(map, index, 1);
			break;
		}
		case CMap::tile_grass_red_d0:
		case CMap::tile_grass_red_d1:
		case CMap::tile_grass_red_d2:
		{
			map.SetTileSupport(index, 0);
			map.AddTileFlag(index, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
			map.RemoveTileFlag(index, Tile::SOLID | Tile::COLLISION);
			OnGrassTileHit(map, index, 2);
			break;
		}
		
		case CMap::tile_ice_spike:
		case CMap::tile_ice_spike_v0:
		{
			map.SetTileSupport(index, 0);
			map.AddTileFlag(index, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
			map.RemoveTileFlag(index, Tile::SOLID | Tile::COLLISION);
			break;
		}
		
		case CMap::tile_purple_grass_dirt:
		case CMap::tile_yellow_grass_dirt:
		case CMap::tile_red_grass_dirt:
		{
			map.SetTileSupport(index, -1);
			map.AddTileFlag(index, Tile::SOLID | Tile::COLLISION);
			map.RemoveTileFlag(index, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
			break;
		}
	}

	if (tile_new == CMap::tile_ground)
	{
		map.SetTileDirt(index, CMap::tile_ground_back);
		if (isPurpleGrassTile(map.getTile(index-map.tilemapwidth).type))
			map.SetTile(index, CMap::tile_purple_grass_dirt);
		else if (isYellowGrassTile(map.getTile(index-map.tilemapwidth).type))
			map.SetTile(index, CMap::tile_yellow_grass_dirt);
		else if (isRedGrassTile(map.getTile(index-map.tilemapwidth).type))
			map.SetTile(index, CMap::tile_red_grass_dirt);
	}

	if (tile_new == CMap::tile_empty || tile_new == CMap::tile_ground_back)
	{
		Vec2f pos = map.getTileWorldPosition(index);
		if (isTileIce(tile_old))
		{
			OnIceTileHit(map, index);
			OnIceTileUpdate(false, true, map, pos);
		}

		else if (isTileSnow(tile_old))
		{
			for (u8 i = 0; i < 4; i++)
			{
				snow_Update(map, pos + directions[i]);
			}
			OnSnowTileHit(map, index);
		}
		else if (isTileSnowPile(tile_old))
			OnSnowTileHit(map, index);
			
		else if (isTileSnowBrick(tile_old) || isTileSnowBrickBackground(tile_old))
			OnSnowBrickTileHit(map, index);
	
		else if (isPurpleGrassTile(tile_old))
		{
			OnGrassTileHit(map, index, 0);
			if(map.getTile(index+map.tilemapwidth).type == CMap::tile_purple_grass_dirt)
				map.SetTile(index+map.tilemapwidth, CMap::tile_ground);
		}
		else if (isYellowGrassTile(tile_old))
		{
			OnGrassTileHit(map, index, 1);
			if(map.getTile(index+map.tilemapwidth).type == CMap::tile_yellow_grass_dirt)
				map.SetTile(index+map.tilemapwidth, CMap::tile_ground);
		}
		else if (isRedGrassTile(tile_old))
		{
			OnGrassTileHit(map, index, 2);
			if(map.getTile(index+map.tilemapwidth).type == CMap::tile_red_grass_dirt)
				map.SetTile(index+map.tilemapwidth, CMap::tile_ground);
		}

		else if (tile_old == CMap::tile_ice_spike || tile_old == CMap::tile_ice_spike_v0)
			OnIceTileHit(map, index);

		if (isGrassTile(map.getTile(index-map.tilemapwidth).type))
			map.server_SetTile(map.getTileWorldPosition(index-map.tilemapwidth), CMap::tile_empty);
	}
	/*
	if(commandsinitialized && getNet().isServer())
	{
		CRules@ rules = getRules();
		if(tile_new == CMap::tile_empty && tile_old != CMap::tile_empty)
		{
			CBitStream params;
			params.write_s32(index);
			rules.SendCommand(rules.getCommandID("tile_removed"), params);
		}
		if(tile_new == CMap::tile_ground_back)
		{
			CBitStream params;
			params.write_s32(index);
			rules.SendCommand(rules.getCommandID("tile_placed"), params);
		}
	}*/
	
	if (tile_old == CMap::tile_purple_grass_dirt || tile_old == CMap::tile_yellow_grass_dirt || tile_old == CMap::tile_red_grass_dirt)
		if (getNet().isClient()) Sound::Play("dig_dirt"+(XORRandom(3)+1)+".ogg", map.getTileWorldPosition(index), 1.0f, 1.0f);
}

void OnIceTileUpdate(bool updateThis, bool updateOthers, CMap@ map, Vec2f pos)
{
	bool isLeft = (map.getTile(pos-Vec2f(8.0f, 0.0f)).type >= CMap::tile_ice && map.getTile(pos-Vec2f(8.0f, 0.0f)).type <= CMap::tile_ice_v2) ? true : false;
	bool isRight = (map.getTile(pos+Vec2f(8.0f, 0.0f)).type >= CMap::tile_ice && map.getTile(pos+Vec2f(8.0f, 0.0f)).type <= CMap::tile_ice_v2) ? true : false;

	if(updateThis)
	{
		if(isLeft && isRight)
			map.SetTile(map.getTileOffset(pos), CMap::tile_ice_v1);
		else if(isLeft || isRight)
		{
			if(isLeft && !isRight)
				map.SetTile(map.getTileOffset(pos), CMap::tile_ice_v2);
			if(!isLeft && isRight)
				map.SetTile(map.getTileOffset(pos), CMap::tile_ice_v0);
		}
		else
			map.SetTile(map.getTileOffset(pos), CMap::tile_ice);
	}
	if(updateOthers)
	{
		if(isLeft)
			OnIceTileUpdate(true, false, map, pos - Vec2f( 8.0f, 0.0f));
		if(isRight)
			OnIceTileUpdate(true, false, map, pos + Vec2f( 8.0f, 0.0f));
	}
}

void OnIceTileHit(CMap@ map, u32 index)
{
	if (getNet().isClient())
	{
		Vec2f pos = map.getTileWorldPosition(index);
		iceparts(pos, 5 + XORRandom(5));	
		Sound::Play("GlassBreak1.ogg", pos, 1.0f, 2.0f);
	}
}

void iceparts(Vec2f at, int amount)
{
	SColor[] colors = {	SColor(255, 44, 175, 222),
						SColor(255, 255, 255, 255),
						SColor(255, 48, 154, 192)};
	for (int i = 0; i < amount; i++)
	{
		Vec2f temp = at;
		switch(XORRandom(4))
		{
			case 0:
				temp += Vec2f(4, 0);
				break;
			case 1:
				temp += Vec2f(8, 4);
				break;
			case 2:
				temp += Vec2f(0, 4);
				break;
			case 3:
				temp += Vec2f(4, 8);
				break;
		}
		Vec2f vel = getRandomVelocity( 0.6f, 1.5f, 180.0f);
		vel.y = -Maths::Abs(vel.y)+Maths::Abs(vel.x)/4.0f-float(XORRandom(100))/100.0f;
		ParticlePixel(temp, vel, colors[XORRandom(3)], false);
		makeGibParticle("IceShards.png", temp, vel, 0, XORRandom(4)+1, Vec2f(4.0f, 4.0f), 2.0f, 0, "");
		//ParticleAnimated("IceShards.png", at, vel, XORRandom(180), 1.0f, 0, XORRandom(5), Vec2f(4.0f, 4.0f), 0, 2.0f, false);
	}
}

void OnSnowTileHit(CMap@ map, u32 index)
{
	if (getNet().isClient())
	{
		Vec2f pos = map.getTileWorldPosition(index);
		snowparts(pos, 7 + XORRandom(5));	
		Sound::Play("cut_grass"+(XORRandom(2)+1)+".ogg", pos, 1.0f, 0.7f);
	}
}

void OnSnowBrickTileHit(CMap@ map, u32 index)
{
	if (getNet().isClient())
	{
		Vec2f pos = map.getTileWorldPosition(index);
		snowparts(pos, 3 + XORRandom(2));	
		Sound::Play("cut_grass2.ogg", pos, 1.0f, 0.4f);
	}
}

void snowparts(Vec2f at, int amount)
{
	SColor[] colors = {	SColor(255, 255, 255, 255),
						SColor(255, 239, 239, 239),
						SColor(255, 206, 206, 206)};
	for (int i = 0; i < amount; i++)
	{
		Vec2f temp = at;
		switch(XORRandom(4))
		{
			case 0:
				temp += Vec2f(4, 0);
				break;
			case 1:
				temp += Vec2f(8, 4);
				break;
			case 2:
				temp += Vec2f(0, 4);
				break;
			case 3:
				temp += Vec2f(4, 8);
				break;
		}
		Vec2f vel = getRandomVelocity( 0.6f, 1.2f, 180.0f);
		vel.y = -Maths::Abs(vel.y)+Maths::Abs(vel.x)/4.0f-float(XORRandom(100))/100.0f;
		ParticlePixel(temp, vel, colors[XORRandom(3)], false);
		makeGibParticle("SnowParts.png", temp, vel, 0, XORRandom(4)+1, Vec2f(4.0f, 4.0f), 2.0f, 1, "bone_fall2.ogg");
	}
}

u8 snow_GetMask(CMap@ map, Vec2f pos)
{
	u8 mask = 0;

	for (u8 i = 0; i < 4; i++)
	{
		if (isSnowTile(map, pos + directions[i])) mask |= 1 << i;
	}

	return mask;
}

void snow_SetTile(CMap@ map, Vec2f pos)
{
    map.SetTile(map.getTileOffset(pos), CMap::tile_snow + snow_GetMask(map, pos));

    for (u8 i = 0; i < 4; i++)
    {
        snow_Update(map, pos + directions[i]);
    }
}

void snow_Update(CMap@ map, Vec2f pos)
{
    u16 tile = map.getTile(pos).type;
    if (isSnowTile(map, pos))
		map.server_SetTile(pos,CMap::tile_snow + snow_GetMask(map,pos));
}

void OnGrassTileHit(CMap@ map, u32 index, u32 type)
{
	if (getNet().isClient())
	{
		Vec2f pos = map.getTileWorldPosition(index);
		grassparts(pos, 2 + XORRandom(3), type);	
		Sound::Play("cut_grass"+(XORRandom(2)+1)+".ogg", pos, 1.0f, 1.0f);
	}
}

void grassparts(Vec2f at, int amount, u32 type)
{
	SColor[] colors = {	SColor(255, 107, 41, 82),
						SColor(255, 54, 21, 42),
						SColor(255, 104, 56, 109),
						SColor(255, 79, 75, 13),
						SColor(255, 205, 198, 75),
						SColor(255, 224, 216, 99),
						SColor(255, 59, 20, 6),
						SColor(255, 159, 52, 52),
						SColor(255, 185, 80, 63)};
	for (int i = 0; i < amount; i++)
	{
		Vec2f temp = at;
		switch(XORRandom(4))
		{
			case 0:
				temp += Vec2f(4, 0);
				break;
			case 1:
				temp += Vec2f(8, 4);
				break;
			case 2:
				temp += Vec2f(0, 4);
				break;
			case 3:
				temp += Vec2f(4, 8);
				break;
		}
		Vec2f vel = getRandomVelocity( 1.5f, 2.0f, 180.0f);
		vel.y = -Maths::Abs(vel.y)+Maths::Abs(vel.x)/4.0f-float(XORRandom(100))/100.0f;
		ParticlePixel(temp, vel, colors[XORRandom(3)+(type*3)], false);
		makeGibParticle("grassparts"+type+".png", temp, vel, 0, XORRandom(4)+1, Vec2f(4.0f, 4.0f), 5.0f, 0, "");
	}
}