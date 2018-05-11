Shader "Kumu/PostProcessing/Photoshop/LightenBlending"
{
	Properties
	{
		[HideInInspector]
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_BlendTex("Blend Texture", 2D) = "black"{}
		[KeywordEnum(None, Lighten, Screen, ColorDodge, LinearDodge, LightenColor, Test7,Test8, Test9, Test10, Test11, Test12, Test13, Test14, Test 15, Test16, Test 17, Test18, Test19, Test20, Test21, Test22, Test23, Test24, Test25, Test26, Test27)] _BlendMode("Blend Mode", Float) = 0
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
			#pragma shader_feature _BLENDMODE_LIGHTEN _BLENDMODE_SCREEN, _BLENDMODE_COLORDODGE
			#pragma shader_feature _BLENDMODE_LINEARDODGE, _BLENDMODE_LIGHTENCOLOR

			#include "UnityCG.cginc"
			#include "PSBlend.cginc"

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex,i.uv);
				fixed4 blend = tex2D(_BlendTex, i.uv);
				
				#if _BLENDMODE_LIGHTEN
					col = blendLighten(col, blend, _Intensity);
				#elif _BLENDMODE_SCREEN
					col = blendScreen(col, blend, _Intensity);
				#elif _BLENDMODE_COLORDODGE
					col = blendColorDodge(col, blend, _Intensity);
				#elif _BLENDMODE_LINEARDODGE
					col = blendLinearDodge(col, blend, _Intensity);
				#elif _BLENDMODE_LIGHTENCOLOR
					col = blendLightenColor(col, blend, blend.a * _Color.a);
				#endif
				
				return col;
			}
			ENDCG

		}

	}
	Fallback "Diffuse"
}
