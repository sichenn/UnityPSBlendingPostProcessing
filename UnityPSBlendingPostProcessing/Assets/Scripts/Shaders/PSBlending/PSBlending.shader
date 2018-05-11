Shader "Kumu/PostProcessing/Photoshop/LightenBlending"
{
	Properties
	{
		[HideInInspector]
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_BlendTex("Blend Texture", 2D) = "black"{}
	}
	
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex BlendVert
			#pragma fragment frag
			#pragma multi_compile BLENDMODE_NORMAL BLENDMODE_DISSOLVE BLENDMODE_DARKEN BLENDMODE_MULTIPLY BLENDMODE_COLORBURN BLENDMODE_LINEARBURN BLENDMODE_DARKERCOLOR BLENDMODE_LIGHTEN BLENDMODE_SCREEN BLENDMODE_COLORDODGE BLENDMODE_LINEARDODGE BLENDMODE_LIGHTERCOLOR BLENDMODE_OVRELAY BLENDMODE_SOFTLIGHT BLENDMODE_HARDLIGHT BLENDMODE_VIVIDLIGHT BLENDMODE_LINEARLIGHT BLENDMODE_PINLIGHT BLENDMODE_HARDMIX BLENDMODE_DIFFERENCE BLENDMODE_EXCLUSION BLENDMODE_SUBTRACT BLENDMODE_DIVIDE BLENDMODE_HUE BLENDMODE_SATURATION BLENDMODE_COLOR BLENDMODE_LUMINOSITY 
			#include "UnityCG.cginc"
			#include "PSBlend.cginc"

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex,i.uv);
				fixed4 blend = tex2D(_BlendTex, i.uv);
				
				#if BLENDMODE_NORMAL
					col = blendNormal(col, blend, _Intensity);
					col = fixed4(1, 1, 1, 1);
				#endif
				//dissolve is not supported
				#if BLENDMODE_DARKEN
					col = blendDarken(col, blend, _Intensity);
				#endif
				#if BLENDMODE_MULTIPLY
					col = blendMultiply(col, blend, _Intensity);
				#endif
				#if BLENDMODE_COLORBURN
					col = blendColorBurn(col, blend, _Intensity);
				#endif
				#if BLENDMODE_LINEARBURN
					col = blendLinearBurn(col, blend, _Intensity);
				#endif
				#if BLENDMODE_DARKERCOLOR
					col = blendDarkerColor(col, blend, _Intensity);
				#endif
				#if BLENDMODE_LIGHTEN

					col = blendLighten(col, blend, _Intensity);
				#endif
				#if BLENDMODE_COLORDODGE
					col = blendColorDodge(col, blend, _Intensity);
				#endif
				#if BLENDMODE_LINEARDODGE
					col = blendLinearDodge(col, blend, _Intensity);
				#endif
				#if BLENDMODE_LIGHTERCOLOR

					col = blendLighterColor(col, blend, _Intensity);
				#endif
				#if BLENDMODE_OVRELAY

					col = blendOverlay(col, blend, _Intensity);
				#endif
				#if BLENDMODE_SOFTLIGHT

					col = blendSoftLight(col, blend, _Intensity);
				#endif
				#if BLENDMODE_HARDLIGHT
					col = blendHardLight(col, blend, _Intensity);
				#endif
				#if BLENDMODE_VIVIDLIGHT
					col = blendVividLight(col, blend, _Intensity);
				#endif
				#if BLENDMODE_LINEARLIGHT
					col = blendLinearLight(col, blend, _Intensity);
				#endif
				#if BLENDMODE_PINLIGHT
					col = blendPinLight(col, blend, _Intensity);
				#endif
				#if BLENDMODE_HARDMIX
					return fixed4(0, 1, 0, 1);

					col = blendHardMix(col, blend, _Intensity);
				#endif
				#if BLENDMODE_DIFFERENCE
					col = blendDifference(col, blend, _Intensity);
				#endif
				#if BLENDMODE_EXCLUSION
					col = blendExclusion(col, blend, _Intensity);
				#endif
				#if BLENDMODE_SUBTRACT
					col = blendSubtract(col, blend, _Intensity);
				#endif
				#if BLENDMODE_DIVIDE
					col = blendDivide(col, blend, _Intensity);
				#endif
				#if BLENDMODE_HUE
					col = blendHue(col, blend, _Intensity);
				#endif
				#if BLENDMODE_SATURATION
					col = blendSaturation(col, blend, _Intensity);
				#endif
				#if BLENDMODE_COLOR
					col = blendColor(col, blend, _Intensity);
				#endif
				#if BLENDMODE_LUMINOSITY
					col = blendLuminosity(col, blend, _Intensity);
				#endif
				
				return col;
			}
			ENDCG

		}

	}
	Fallback "Diffuse"
}
