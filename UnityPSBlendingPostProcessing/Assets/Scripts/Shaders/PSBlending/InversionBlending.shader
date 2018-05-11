Shader "Kumu/PostProcessing/Photoshop/InversionBlending"
{
Properties
	{
		[HideInInspector]
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_BlendTex("Blend Texture", 2D) = "black"{}
		[KeywordEnum(None, Difference, Exclusion, Subtract, Divide)] _BlendMode("Blend Mode", Float) = 0
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
			#pragma shader_feature _BLENDMODE_DIFFERENCE _BLENDMODE_EXCLUSION, _BLENDMODE_SUBTRACT, _BLENDMODE_DIVIDE

			#include "UnityCG.cginc"
			#include "PSBlend.cginc"

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex,i.uv);
				fixed4 blend = tex2D(_BlendTex, i.uv);
				
				#if _BLENDMODE_DARKEN
					col = blendDarken(col, blend, blend.a * _Color.a);
				#elif _BLENDMODE_MULTIPLY
					col = blendMultiply(col, blend, blend.a * _Color.a);
				#elif _BLENDMODE_COLORBURN
					col = blendColorBurn(col, blend, blend.a * _Color.a);
				#elif _BLENDMODE_LINEARBURN
					col = blendLinearBurn(col, blend, blend.a * _Color.a);
				#elif _BLENDMODE_DARKENCOLOR
					col = blendDarkenColor(col, blend, blend.a * _Color.a);
				#endif
				
				return col;
			}
			ENDCG

		}

	}
	Fallback "Diffuse"
}
