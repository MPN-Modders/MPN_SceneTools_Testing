Shader "Madness/Mask" {
 
	SubShader {
		// Render the mask after regular geometry, but before masked geometry and
		// transparent things.
 
		Tags {"Queue" = "Geometry+59"} // aka 2060. Walls set to 2060, but adjusted to 2059 for transparency (walls
 
		// Don't draw in the RGBA channels; just the depth buffer
 
		ColorMask 0
		ZWrite On
 
		// Do nothing specific in the pass:
 
		Pass { }

	}
}