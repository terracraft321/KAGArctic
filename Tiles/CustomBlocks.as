// tile flags
/*
	SPARE_0			= 1
	SOLID			= 4
	BACKGROUND		= 2
	LADDER			= 8
	LIGHT_PASSES	= 16
	WATER_PASSES	= 32
	FLAMMABLE		= 64
	PLATFORM		= 128
	LIGHT_SOURCE	= 256
	MIRROR			= 512
	FLIP			= 1024
	ROTATE			= 2048
	COLLISION		= 4096
	SPARE_2			= 8192
	SPARE_3			= 16384
	SPARE_4			= 32768
*/
// tile flags end

namespace CMap
{
	enum CustomTiles
	{
		tile_ice = 262,
		tile_ice_v0,
		tile_ice_v1,
		tile_ice_v2,
		tile_snow = 266,
		tile_snow_v0,
		tile_snow_v1,
		tile_snow_v2,
		tile_snow_v3,
		tile_snow_v4,
		tile_snow_v5,
		tile_snow_v6,
		tile_snow_v7,
		tile_snow_v8,
		tile_snow_v9,
		tile_snow_v10,
		tile_snow_v11,
		tile_snow_v12,
		tile_snow_v13,
		tile_snow_v14,
		tile_snow_d0,
		tile_snow_d1,
		tile_snow_brick = 284,
		tile_snow_brick_d0,
		tile_snow_brick_d1,
		tile_snow_brick_d2,
		tile_snow_brick_d3,
		tile_snow_brick_d4,
		tile_snow_pile = 290,
		tile_snow_pile_v0,
		tile_snow_pile_v1,
		tile_snow_pile_v2,
		tile_snow_pile_v3,
		tile_grass_purple = 295,
		tile_grass_purple_d0,
		tile_grass_purple_d1,
		tile_grass_purple_d2,
		tile_grass_yellow = 299,
		tile_grass_yellow_d0,
		tile_grass_yellow_d1,
		tile_grass_yellow_d2,
		tile_grass_red = 303,
		tile_grass_red_d0,
		tile_grass_red_d1,
		tile_grass_red_d2,
		tile_ice_spike = 307,
		tile_ice_spike_v0,
		tile_purple_grass_dirt = 309,
		tile_yellow_grass_dirt,
		tile_red_grass_dirt,
		tile_snow_brick_back,
		tile_snow_brick_back_d0,
		tile_snow_brick_back_d1,
		tile_snow_brick_back_d2,
		tile_snow_brick_back_d3,
		tile_snow_brick_back_d4,
		tile_keep_this_always_last,
	};
};

const SColor color_ice(255, 124, 189, 200);
const SColor color_snow(255, 239, 239, 239);
const SColor color_snow_brick(255, 206, 206, 206);
const SColor color_snow_brick_back(255, 175, 175, 175);
const SColor color_snow_pile(255, 226, 226, 226);
const SColor color_grass_purple(255, 155, 13, 131);
const SColor color_grass_yellow(255, 185, 197, 51);
const SColor color_grass_red(255, 214, 68, 62);
const SColor color_ice_spike(255, 103, 177, 188);

void HandleCustomTile(CMap@ map, int offset, SColor pixel)
{
	Vec2f pos = map.getTileWorldPosition(offset);
	if (pixel == color_ice){
		map.server_SetTile(pos, CMap::tile_ice);
		map.AddTileFlag(offset, Tile::LIGHT_PASSES | Tile::SOLID | Tile::COLLISION | Tile::WATER_PASSES);
		map.RemoveTileFlag(offset, Tile::LIGHT_SOURCE);}

	if (pixel == color_snow){
		map.server_SetTile(pos, CMap::tile_snow);
		map.AddTileFlag(offset, Tile::LIGHT_PASSES | Tile::SOLID | Tile::COLLISION);
		map.RemoveTileFlag(offset, Tile::LIGHT_SOURCE);}

	if (pixel == color_snow_brick){
		map.server_SetTile(pos, CMap::tile_snow_brick);
		map.AddTileFlag(offset, Tile::SOLID | Tile::COLLISION);
		map.RemoveTileFlag(offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);}
	
	if (pixel == color_snow_brick_back){
		map.server_SetTile(pos, CMap::tile_snow_brick_back);
		map.AddTileFlag(offset, Tile::BACKGROUND | Tile::LIGHT_PASSES);
		map.RemoveTileFlag(offset, Tile::LIGHT_SOURCE | Tile::COLLISION | Tile::SOLID);}

	if (pixel == color_snow_pile){
		map.server_SetTile(pos, CMap::tile_snow_pile+XORRandom(5));
		if(XORRandom(2) == 1)
			map.AddTileFlag(offset, Tile::MIRROR);
		map.AddTileFlag(offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.RemoveTileFlag(offset, Tile::SOLID | Tile::COLLISION);}

	if (pixel == color_grass_purple){
		map.server_SetTile(pos, CMap::tile_grass_purple+XORRandom(4));
		if(XORRandom(2) == 1)
			map.AddTileFlag(offset, Tile::MIRROR);
		map.AddTileFlag(offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.RemoveTileFlag(offset, Tile::SOLID | Tile::COLLISION);}

	if (pixel == color_grass_yellow){
		map.server_SetTile(pos, CMap::tile_grass_yellow+XORRandom(4));
		if(XORRandom(2) == 1)
			map.AddTileFlag(offset, Tile::MIRROR);
		map.AddTileFlag(offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.RemoveTileFlag(offset, Tile::SOLID | Tile::COLLISION);}

	if (pixel == color_grass_red){
		map.server_SetTile(pos, CMap::tile_grass_red+XORRandom(4));
		if(XORRandom(2) == 1)
			map.AddTileFlag(offset, Tile::MIRROR);
		map.AddTileFlag(offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.RemoveTileFlag(offset, Tile::SOLID | Tile::COLLISION);}

	if (pixel == color_ice_spike){
		map.server_SetTile(pos, CMap::tile_ice_spike+XORRandom(2));
		if(XORRandom(2) == 1)
			map.AddTileFlag(offset, Tile::MIRROR);
		map.AddTileFlag(offset, Tile::LIGHT_SOURCE | Tile::LIGHT_PASSES);
		map.RemoveTileFlag(offset, Tile::SOLID | Tile::COLLISION);}
}

bool isTileCustomSolid(u16 tile)
{
    return  (tile >= CMap::tile_ice && tile <= CMap::tile_snow_brick_d4) || 
			(tile >= CMap::tile_purple_grass_dirt && tile <= CMap::tile_red_grass_dirt);
}

bool isGrassTile(u16 tile)
{
    return  (tile >= 25 && tile <= 28) || 
			(tile >= CMap::tile_snow_pile && tile <= CMap::tile_ice_spike_v0);
}

bool isPurpleGrassTile(u16 tile)
{
    return  tile >= CMap::tile_grass_purple && tile <= CMap::tile_grass_purple_d2;
}

bool isYellowGrassTile(u16 tile)
{
    return  tile >= CMap::tile_grass_yellow && tile <= CMap::tile_grass_yellow_d2;
}

bool isRedGrassTile(u16 tile)
{
    return  tile >= CMap::tile_grass_red && tile <= CMap::tile_grass_red_d2;
}

bool isTileIce(u16 tile)
{
    return tile >= CMap::tile_ice && tile <= CMap::tile_ice_v2;
}

bool isTileSnow(u16 tile)
{
    return tile >= CMap::tile_snow && tile <= CMap::tile_snow_d1;
}

bool isTileSnowBrick(u16 tile)
{
    return tile >= CMap::tile_snow_brick && tile <= CMap::tile_snow_brick_d4;
}

bool isTileSnowBrickBackground(u16 tile)
{
    return tile >= CMap::tile_snow_brick_back && tile <= CMap::tile_snow_brick_back_d4;
}

bool isTileSnowPile(u16 tile)
{
    return tile >= CMap::tile_snow_pile && tile <= CMap::tile_snow_pile_v3;
}

bool isSnowTile(CMap@ map, Vec2f pos)
{
    u16 tile = map.getTile(pos).type;
    return tile >= CMap::tile_snow && tile <= CMap::tile_snow_v14;
}

const Vec2f[] directions = {	Vec2f(0, -8),
								Vec2f(0, 8),
								Vec2f(8, 0),
								Vec2f(-8, 0)};

/*

:**`**: :kag_252525::kag_252525::kag_252525: :**`**:

*/