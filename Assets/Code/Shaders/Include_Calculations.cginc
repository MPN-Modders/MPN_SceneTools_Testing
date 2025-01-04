//	#include "Assets/Resources/Code/Shaders/Include_Calculations.cginc"
// 
// 	This is where functions will be stored that need to be recycled by 
//	Pass Storage shaders, to then be passed on to each of my shaders.





// Takes the blood texture, returns the actual alpha of the finished texture.

fixed ReturnTextureCutoutAlpha2(fixed3 inBloodTexture)
{
	// THIS FUNCTION HAS MOVED TO Include_Default
	return ceil((inBloodTexture.r + inBloodTexture.g + inBloodTexture.b) / 3.0);
}


fixed ReturnOverlayVal(fixed3 inTexture)
{
	return min(1, (inTexture.r + inTexture.g + inTexture.b) / 3);
}

fixed3 ColorizeTexture(fixed3 inTexture, fixed overlayValue, fixed map, fixed4 color1, fixed4 color2)
{
	// Taken from INCLUDE_CHARACTER!
	overlayValue = overlayValue > 0.5; // Sets this to 0 or 1, so we know whether or not to use MULTIPLY or SCREEN
	inTexture.rgb = lerp(inTexture.rgb, (overlayValue) * (1 - (1 - 2 * (inTexture.rgb - 0.5)) * (1 - color1.rgb)) + (1 - overlayValue) * ((2 * inTexture.rgb) * color1.rgb), color1.a  * round(0.6f - map));
	inTexture.rgb = lerp(inTexture.rgb, (overlayValue) * (1 - (1 - 2 * (inTexture.rgb - 0.5)) * (1 - color2.rgb)) + (1 - overlayValue) * ((2 * inTexture.rgb) * color2.rgb), color2.a * round(map - 0.2));

	return inTexture;
}

