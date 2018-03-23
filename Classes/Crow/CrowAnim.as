// Character animations

#include "RunnerAnimCommon.as";
#include "RunnerCommon.as";
//#include "PixelOffsets.as"
//#include "RunnerTextures.as"

void onInit(CSprite@ this)
{
	//addRunnerTextures(this, "crow", "Crow");

	this.getCurrentScript().runFlags |= Script::tick_not_infire;
}


void onTick(CSprite@ this)
{
	// store some vars for ease and speed
	CBlob@ blob = this.getBlob(); //^What that guy said

	const bool left = blob.isKeyPressed(key_left); //All these check for if we are pressing movment keys.
	const bool right = blob.isKeyPressed(key_right);
	const bool up = blob.isKeyPressed(key_up);
	const bool inair = !blob.isOnGround(); //Are we in the air?
	Vec2f pos = blob.getPosition(); //Let's get our position

	if (inair)
	{
		if (left || right || up)
			this.SetAnimation("fly");
		else
			this.SetAnimation("glide");
	}
	else
		this.SetAnimation("default");
}

void DrawCursorAt(Vec2f position, string& in filename) //Draw the cursor. Exactly what it says on the tin.
{
	position = getMap().getAlignedWorldPos(position);
	if (position == Vec2f_zero) return;
	position = getDriver().getScreenPosFromWorldPos(position - Vec2f(1, 1));
	GUI::DrawIcon(filename, position, getCamera().targetDistance * getDriver().getResolutionScaleFactor());
}
