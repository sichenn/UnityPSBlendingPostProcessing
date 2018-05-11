//Author: 
//Sichen Liu. 2018
//Usage:
//Use the Photoshop's Normal Blending mode to implement Stylized Post Processing effects

Shader "Kumu/PostProcessing/Photoshop/NormalBlending"
{
	Properties
	{
		[HideInInspector]
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_BlendTex("Blend Texture", 2D) = "black"{}
		[KeywordEnum(None, Normal, Dissolve)] _BlendMode("Blend Mode", Float) = 0
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

		#include "UnityCG.cginc"
		#include "PSBlend.cginc"

			fixed4 frag(v2f i) : SV_Target
		{
			// sample the texture
			fixed4 col = tex2D(_MainTex,i.uv);
			//fixed4 col = tex2D(_MainTex, i.uv * _MainTexUVSet.xy + _MainTexUVSet.zw) * _Color;
			fixed4 blend = tex2D(_BlendTex, i.uv);
			col = blendHardLight(col, blend, _Intensity);
			return col;
		}
			ENDCG

		}

	}
		Fallback "Diffuse"
}
