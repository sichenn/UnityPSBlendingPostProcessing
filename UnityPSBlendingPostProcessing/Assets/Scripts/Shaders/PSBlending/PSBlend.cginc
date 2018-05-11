// ------------------------------------------------------------
// Photoshop Color Blend
// Original author: irishoak
// https://gist.github.com/hiroakioishi/c4eda57c29ae7b2912c4809087d5ffd0
//
// Author: Sichen Liu. 2018
// For more info on Photoshop Blend Mode, visit:
// https://photoshoptrainingchannel.com/blending-modes-explained/
//
// Note:
// Naming conflict with Photoshop:
// Photoshop: DarkerColor, LighterColor; PSBlend: DarkenColor, LightenColor
// ------------------------------------------------------------

sampler2D _MainTex;
sampler2D _BlendTex;
float4 _MainTex_ST;
float _Intensity;

struct appdata
{
	float4 vertex : POSITION;
	float2 uv : TEXCOORD0;
};

struct v2f
{
	float2 uv : TEXCOORD0;
	float4 vertex : SV_POSITION;
};

v2f BlendVert(appdata v)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(v.vertex);
	o.uv = v.uv;
	return o;
}

// Branchless RGB2HSL implementation from : https://www.shadertoy.com/view/MsKGRW
float3 rgb2hsl(float3 c){
    float epsilon = 0.00000001;
    float cmin = min( c.r, min( c.g, c.b ) );
    float cmax = max( c.r, max( c.g, c.b ) );
	float cd   = cmax - cmin;
    float3 hsl = float3(0.0, 0.0, 0.0);
    hsl.z = (cmax + cmin) / 2.0;
    hsl.y = lerp(cd / (cmax + cmin + epsilon), cd / (epsilon + 2.0 - (cmax + cmin)), step(0.5, hsl.z));

    float3 a = float3(1.0 - step(epsilon, abs(cmax - c)));
    a = lerp(float3(a.x, 0.0, a.z), a, step(0.5, 2.0 - a.x - a.y));
    a = lerp(float3(a.x, a.y, 0.0), a, step(0.5, 2.0 - a.x - a.z));
    a = lerp(float3(a.x, a.y, 0.0), a, step(0.5, 2.0 - a.y - a.z));

    hsl.x = dot( float3(0.0, 2.0, 4.0) + ((c.gbr - c.brg) / (epsilon + cd)), a );
    hsl.x = (hsl.x + (1.0 - step(0.0, hsl.x) ) * 6.0 ) / 6.0;
    return hsl;
}

// HSL2RGB thanks to IQ : https://www.shadertoy.com/view/lsS3Wc
float3 hsl2rgb(float3 c){
    float3 rgb = clamp(abs(fmod(c.x * 6.0 + float3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
    return c.z + c.y * (rgb - 0.5) * (1.0 - abs(2.0 * c.z - 1.0));
}

// [NORMAL]
// ------------------------------------------------------------
// Normal 通常
// ------------------------------------------------------------
float4 blendNormal(float4 a, float4 b){
	return lerp(a, b, 0.5);
}

float4 blendNormal(float4 a, float4 b, float intensity) {
	return lerp(a, b, intensity);
}

// ------------------------------------------------------------
// Dissolve ディザ合成
// ------------------------------------------------------------


// [DARKEN]
// ------------------------------------------------------------
// Darken 比較(暗)
// ------------------------------------------------------------
float4 blendDarken(float4 a, float4 b){
	return float4(min(a.rgb, b.rgb), 1.0);
}

float4 blendDarken(float4 a, float4 b, float intensity){
	return lerp(a, float4(min(a.rgb, b.rgb), 1.0), intensity);
}

// ------------------------------------------------------------
// Multiply 乗算
// ------------------------------------------------------------
float4 blendMultiply(float4 a, float4 b){
	return a * b;
}

float4 blendMultiply(float4 a, float4 b, float intensity){
	return lerp(a, a * b, intensity);
}

// ------------------------------------------------------------
// ColorBurn 焼き込みカラー
// ------------------------------------------------------------
float4 blendColorBurn(float4 a, float4 b){
	return (1.0 - (1.0 - a) / b);
}

float4 blendColorBurn(float4 a, float4 b, float intensity){
	return lerp(a, (1.0 - (1.0 - a) / b), intensity);
}

// ------------------------------------------------------------
// LinearBurn 焼き込み(リニア)
// ------------------------------------------------------------
float4 blendLinearBurn(float4 a, float4 b){
	return (a + b - 1);
}

float4 blendLinearBurn(float4 a, float4 b, float intensity){
	return lerp(a, (a + b - 1), intensity);
}

// ------------------------------------------------------------
// DarkenColor カラー比較(暗)
// ------------------------------------------------------------
float4 blendDarkerColor (float4 a, float4 b) {
	return min(a, b);
}

float4 blendDarkerColor (float4 a, float4 b, float intensity) {
	return lerp(a, min(a, b), intensity);
}

// [LIGHTEN]
// ------------------------------------------------------------
// Lighten 比較(明)
// ------------------------------------------------------------
float4 blendLighten(float4 a, float4 b){
	return float4(max(a.rgb, b.rgb), 1.0);
}

float4 blendLighten(float4 a, float4 b, float intensity){
	return lerp(a, float4(max(a.rgb, b.rgb), 1.0), intensity);
}

// ------------------------------------------------------------
// Screen スクリーン
// ------------------------------------------------------------
float4 blendScreen(float4 a, float4 b){
	return (1.0 - (1.0 - a) * (1.0 - b));
}

float4 blendScreen(float4 a, float4 b, float intensity){
	return lerp(a, (1.0 - (1.0 - a) * (1.0 - b)), intensity);
}

// ------------------------------------------------------------
// ColorDodge 覆い焼きカラー
// ------------------------------------------------------------
float4 blendColorDodge(float4 a, float4 b){
	return (a / (1.0 - b));
}

float4 blendColorDodge(float4 a, float4 b, float intensity){
	return lerp(a, (a / (1.0 - b)), intensity);
}

// ------------------------------------------------------------
// LinearDodge 覆い焼きカラー(リニア) - 加算
// ------------------------------------------------------------
float4 blendLinearDodge(float4 a, float4 b){
	return (a + b);
}

float4 blendLinearDodge(float4 a, float4 b, float intensity){
	return lerp(a, (a + b), intensity);
}

// ------------------------------------------------------------
// LightenColor カラー比較(明)
// ------------------------------------------------------------
float4 blendLighterColor (float4 a, float4 b) {
	return max(a, b);
}

float4 blendLighterColor (float4 a, float4 b, float intensity) {
	return lerp(a, max(a, b), intensity);
}


// [CONSRAST]
// ------------------------------------------------------------
// Overlay オーバーレイ
// ------------------------------------------------------------
float4 blendOverlay(float4 a, float4 b) {
	float4 r = float4(0.0, 0.0, 0.0, 1.0);
    if (a.r > 0.5){
    	r.r = 1.0 - (1.0 - 2.0 * (a.r - 0.5)) * (1.0 - b.r);
    } else {
    	r.r = (2.0 * a.r) * b.r;
    }
    if (a.g > 0.5) {
    	r.g = 1.0 - (1.0 - 2.0 * (a.g - 0.5)) * (1.0 - b.g);
    } else {
    	r.g = (2.0 * a.g) * b.g;
    }
    if (a.b > 0.5){
    	r.b = 1.0 - (1.0 - 2.0 * (a.b - 0.5)) * (1.0 - b.b);
    } else {
    	r.b = (2.0 * a.b) * b.b;
    }
    return r;
}

float4 blendOverlay(float4 a, float4 b, float intensity) {
	float4 r = float4(0.0, 0.0, 0.0, 1.0);
    if (a.r > 0.5){
    	r.r = 1.0 - (1.0 - 2.0 * (a.r - 0.5)) * (1.0 - b.r);
    } else {
    	r.r = (2.0 * a.r) * b.r;
    }
    if (a.g > 0.5) {
    	r.g = 1.0 - (1.0 - 2.0 * (a.g - 0.5)) * (1.0 - b.g);
    } else {
    	r.g = (2.0 * a.g) * b.g;
    }
    if (a.b > 0.5){
    	r.b = 1.0 - (1.0 - 2.0 * (a.b - 0.5)) * (1.0 - b.b);
    } else {
    	r.b = (2.0 * a.b) * b.b;
    }
    return lerp(a, r, intensity);
}

float4 blendSoftLight(float4 a, float4 b)
{
    float4 result = float4(0.0, 0.0, 0.0, 1.0);
    if (a.r > 0.5)
    {
        result.r = (1 - (1 - a.r) * (1 - (b.r - 0.5)));
    }
    else
    {
        result.r = a.r * (b.r + 0.5);
    }
    if (a.g > 0.5)
    {
        result.g = (1 - (1 - a.g) * (1 - (b.g - 0.5)));
    }
    else
    {
        result.g = a.g * (b.g + 0.5);
    }
    if (a.b > 0.5)
    {
        result.b = (1 - (1 - a.b) * (1 - (b.b - 0.5)));
    }
    else
    {
        result.b = a.b * (b.b + 0.5);
    }
    return result;
}

float4 blendSoftLight(float4 a, float4 b, float intensity)
{
    return lerp(a, blendSoftLight(a,b), intensity);
}

// ------------------------------------------------------------
// HardLight ハードライト
// ------------------------------------------------------------
float4 blendHardLight (float4 a, float4 b) {
    float4 r = float4(0.0, 0.0, 0.0, 1.0);
    if (b.r > 0.5){
    	r.r = 1.0 - (1.0 - a.r) * (1.0 - 2.0 * (b.r));
    } else {
    	r.r = a.r * (2.0 * b.r);
    }
    if (b.g > 0.5){
    	r.g = 1.0 - (1.0 - a.g) * (1.0 - 2.0 * (b.g));
    } else {
    	r.g = a.g * (2.0 * b.g);
    }
    if (b.b > 0.5){
    	r.b = 1.0 - (1.0 - a.b) * (1.0 - 2.0 * (b.b));
    } else {
    	r.b = a.b * (2.0 * b.b);
    }
    return r;
}

float4 blendHardLight (float4 a, float4 b, float intensity) {
    float4 r = float4(0.0, 0.0, 0.0, 1.0);
    if (b.r > 0.5){
    	r.r = 1.0 - (1.0 - a.r) * (1.0 - 2.0 * (b.r));
    } else {
    	r.r = a.r * (2.0 * b.r);
    }
    if (b.g > 0.5){
    	r.g = 1.0 - (1.0 - a.g) * (1.0 - 2.0 * (b.g));
    } else {
    	r.g = a.g * (2.0 * b.g);
    }
    if (b.b > 0.5){
    	r.b = 1.0 - (1.0 - a.b) * (1.0 - 2.0 * (b.b));
    } else {
    	r.b = a.b * (2.0 * b.b);
    }
    return lerp(a, r, intensity);
}

// ------------------------------------------------------------
// VividLight ビビッドライト
// ------------------------------------------------------------
float4 blendVividLight (float4 a, float4 b) {
    float4 r = float4(0.0, 0.0, 0.0, 1.0);
    if (b.r > 0.5){
    	r.r = 1.0 - (1.0 - a.r) / (2.0 * (b.r - 0.5));
    } else {
    	r.r = a.r / (1.0 - 2.0 * b.r);
    }
    if (b.g > 0.5){
    	r.g = 1.0 - (1.0 - a.g) / (2.0 * (b.g - 0.5));
    } else {
    	r.g = a.g / (1.0 - 2.0 * b.g);
    }
    if (b.b > 0.5){
    	r.b = 1.0 - (1.0 - a.b) / (2.0 * (b.b - 0.5));
    } else {
    	r.b = a.b / (1.0 - 2.0 * b.b);
    }
    return r;
}

float4 blendVividLight (float4 a, float4 b, float intensity) {
    float4 r = float4(0.0, 0.0, 0.0, 1.0);
    if (b.r > 0.5){
    	r.r = 1.0 - (1.0 - a.r) / (2.0 * (b.r - 0.5));
    } else {
    	r.r = a.r / (1.0 - 2.0 * b.r);
    }
    if (b.g > 0.5){
    	r.g = 1.0 - (1.0 - a.g) / (2.0 * (b.g - 0.5));
    } else {
    	r.g = a.g / (1.0 - 2.0 * b.g);
    }
    if (b.b > 0.5){
    	r.b = 1.0 - (1.0 - a.b) / (2.0 * (b.b - 0.5));
    } else {
    	r.b = a.b / (1.0 - 2.0 * b.b);
    }
    return lerp(a, r, intensity);
}

// ------------------------------------------------------------
// LinearLight リニアライト
// ------------------------------------------------------------
float4 blendLinearLight (float4 a, float4 b) {
    float4 r = float4(0.0, 0.0, 0.0, 1.0);
    if (b.r > 0.5){
    	r.r = a.r + 2.0 * (b.r - 0.5);
    } else {
    	r.r = a.r + 2.0 * b.r - 1.0;
    }
    if (b.g > 0.5){
    	r.g = a.g + 2.0 * (b.g - 0.5);
    } else {
    	r.g = a.g + 2.0 * b.g - 1.0;
    }
    if (b.b > 0.5){
    	r.b = a.b + 2.0 * (b.b - 0.5);
    } else {
    	r.b = a.b + 2.0 * b.b - 1.0;
    }
    return r;
}

float4 blendLinearLight (float4 a, float4 b, float intensity) {
    float4 r = float4(0.0, 0.0, 0.0, 1.0);
    if (b.r > 0.5){
    	r.r = a.r + 2.0 * (b.r - 0.5);
    } else {
    	r.r = a.r + 2.0 * b.r - 1.0;
    }
    if (b.g > 0.5){
    	r.g = a.g + 2.0 * (b.g - 0.5);
    } else {
    	r.g = a.g + 2.0 * b.g - 1.0;
    }
    if (b.b > 0.5){
    	r.b = a.b + 2.0 * (b.b - 0.5);
    } else {
    	r.b = a.b + 2.0 * b.b - 1.0;
    }
    return lerp(a, r, intensity);
}
// ------------------------------------------------------------
// PinLight ピンライト
// ------------------------------------------------------------
float4 blendPinLight (float4 a, float4 b) {
    float4 r = float4(0.0, 0.0, 0.0, 1.0);
    if (b.r > 0.5){
    	r.r = max(a.r, 2.0 * (b.r - 0.5));
    } else {
    	r.r = min(a.r, 2.0 * b.r);
    }
    if (b.g > 0.5){
    	r.g = max(a.g, 2.0 * (b.g - 0.5));
    } else {
    	r.g = min(a.g, 2.0 * b.g);
    }
    if (b.b > 0.5){
    	r.b = max(a.b, 2.0 * (b.b - 0.5));
    } else {
    	r.b = min(a.b, 2.0 * b.b);
    }
    return r;
}

float4 blendPinLight (float4 a, float4 b, float intensity) {
    float4 r = float4(0.0, 0.0, 0.0, 1.0);
    if (b.r > 0.5){
    	r.r = max(a.r, 2.0 * (b.r - 0.5));
    } else {
    	r.r = min(a.r, 2.0 * b.r);
    }
    if (b.g > 0.5){
    	r.g = max(a.g, 2.0 * (b.g - 0.5));
    } else {
    	r.g = min(a.g, 2.0 * b.g);
    }
    if (b.b > 0.5){
    	r.b = max(a.b, 2.0 * (b.b - 0.5));
    } else {
    	r.b = min(a.b, 2.0 * b.b);
    }
    return lerp(a, r, intensity);
}

// ------------------------------------------------------------
// Hardlerp ハードミックス
// ------------------------------------------------------------
float4 blendHardMix (float4 a, float4 b) {
    return step(1.0, a + b);
}

float4 blendHardMix (float4 a, float4 b, float intensity) {
    return lerp(a, step(1.0, a + b), intensity);
}

// [INVERSION]
// ------------------------------------------------------------
// Difference 差の絶対値
// ------------------------------------------------------------
float4 blendDifference (float4 a, float4 b){
	return (abs(a - b));
}

float4 blendDifference (float4 a, float4 b, float intensity){
	return lerp(a, (abs(a - b)), intensity);
}

// ------------------------------------------------------------
// Exclusion 除外
// ------------------------------------------------------------
float4 blendExclusion (float4 a, float4 b){
	return (0.5 - 2.0 * (a - 0.5) * (b - 0.5));
}

float4 blendExclusion (float4 a, float4 b, float intensity){
	return lerp(a, (0.5 - 2.0 * (a - 0.5) * (b - 0.5)), intensity);
}


// [CANCELATION]
// ------------------------------------------------------------
// Subtract 減算
// ------------------------------------------------------------
float4 blendSubtract (float4 a, float4 b) {
	return b - a;
}

float4 blendSubtract (float4 a, float4 b, float intensity) {
	return lerp(a, b - a, intensity);
}

// ------------------------------------------------------------
// Divide 除算
// ------------------------------------------------------------
float4 blendDivide (float4 a, float4 b) {
	return b / a;
}

float4 blendDivide (float4 a, float4 b, float intensity) {
	return lerp(a, b / a, intensity);
}


// [COMPONENT]
// ------------------------------------------------------------
// Hue 色相
// ------------------------------------------------------------
float4 blendHue (float4 a, float4 b) {
	float3 dstHSL = rgb2hsl(b.rgb);
    float3 srcHSL = rgb2hsl(a.rgb);
    return float4(hsl2rgb(float3(srcHSL.r, dstHSL.gb)), lerp(a.a, b.a, 0.5));
}

float4 blendHue (float4 a, float4 b, float intensity) {
	float3 dstHSL = rgb2hsl(b.rgb);
    float3 srcHSL = rgb2hsl(a.rgb);
    return lerp(a, float4(hsl2rgb(float3(srcHSL.r, dstHSL.gb)), lerp(a.a, b.a, 0.5)), intensity);
}

// ------------------------------------------------------------
// Saturation 彩度
// ------------------------------------------------------------
float4 blendSaturation (float4 a, float4 b){
    float3 dstHSL = rgb2hsl(b.rgb);
    float3 srcHSL = rgb2hsl(a.rgb);
    return float4(hsl2rgb(float3(dstHSL.r, srcHSL.g, dstHSL.b)), lerp(a.a, b.a, 0.5));
}

float4 blendSaturation (float4 a, float4 b, float intensity){
    float3 dstHSL = rgb2hsl(b.rgb);
    float3 srcHSL = rgb2hsl(a.rgb);
    return lerp(a, float4(hsl2rgb(float3(dstHSL.r, srcHSL.g, dstHSL.b)), lerp(a.a, b.a, 0.5)), intensity);
}

// ------------------------------------------------------------
// Color カラー
// ------------------------------------------------------------
float4 blendColor (float4 a, float4 b) {
	float3 dstHSL = rgb2hsl(b.rgb);
	float3 srcHSL = rgb2hsl(a.rgb);
	return float4(hsl2rgb(float3(srcHSL.rg, dstHSL.b)), lerp(a.a, b.a, 0.5));
}

float4 blendColor (float4 a, float4 b, float intensity) {
	float3 dstHSL = rgb2hsl(b.rgb);
	float3 srcHSL = rgb2hsl(a.rgb);
	return lerp(a, float4(hsl2rgb(float3(srcHSL.rg, dstHSL.b)), lerp(a.a, b.a, 0.5)), intensity);
}

// ------------------------------------------------------------
// Luminosity 輝度
// ------------------------------------------------------------
float4 blendLuminosity (float4 a, float4 b) {
	float3 dstHSL = rgb2hsl(b.rgb);
	float3 srcHSL = rgb2hsl(a.rgb);
	return float4(hsl2rgb(float3(dstHSL.rg, srcHSL.b)), lerp(a.a, b.a, 0.5));
}

float4 blendLuminosity (float4 a, float4 b, float intensity) {
	float3 dstHSL = rgb2hsl(b.rgb);
	float3 srcHSL = rgb2hsl(a.rgb);
	return lerp(a, float4(hsl2rgb(float3(dstHSL.rg, srcHSL.b)), lerp(a.a, b.a, 0.5)), intensity);
}

// [OTHERS]
// ------------------------------------------------------------
// HalfDesaturation
// ------------------------------------------------------------

// ------------------------------------------------------------
// Desaturation
// ------------------------------------------------------------

// ------------------------------------------------------------
// Average
// ------------------------------------------------------------

// ------------------------------------------------------------
// Add
// ------------------------------------------------------------

// ------------------------------------------------------------
// Negation
// ------------------------------------------------------------

// ------------------------------------------------------------
// Reflect
// ------------------------------------------------------------

// ------------------------------------------------------------
// Glow
// ------------------------------------------------------------

// ------------------------------------------------------------
// Phoenix
// ------------------------------------------------------------
