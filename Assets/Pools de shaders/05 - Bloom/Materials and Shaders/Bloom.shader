// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Bloom"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		[HDR]_MainTexture("MainTexture", 2D) = "white" {}
		_BloomThresholdMin("Bloom Threshold Min", Range( 0 , 1)) = 0.2764706
		_BloomThresholdMax("Bloom Threshold Max", Range( 0 , 1)) = 0.5705882
		_Intensity("Intensity", Range( 0 , 4)) = 0
		_Hue("Hue", Color) = (1,0.7984268,0.4575472,0)
		_OffsetMain("Offset Main", Range( 1 , 10)) = 0.005
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _MainTexture;
			uniform float4 _MainTexture_ST;
			uniform float _OffsetMain;
			uniform float _BloomThresholdMin;
			uniform float _BloomThresholdMax;
			uniform float4 _Hue;
			uniform float _Intensity;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTexture = i.uv.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
				float4 tex2DNode17 = tex2D( _MainTexture, uv_MainTexture );
				float2 TextCoordUVs39 = uv_MainTexture;
				float OffsetMain156 = ( _OffsetMain / 1000.0 );
				float dotResult18 = dot( tex2DNode17 , float4( float3(0.2,0.7,0.07) , 0.0 ) );
				float smoothstepResult94 = smoothstep( _BloomThresholdMin , _BloomThresholdMax , dotResult18);
				float Mask38 = smoothstepResult94;
				float4 OffsetSetA104 = ( ( tex2D( _MainTexture, ( TextCoordUVs39 + ( OffsetMain156 * float2( 1,0 ) ) ) ) * Mask38 ) + ( tex2D( _MainTexture, ( TextCoordUVs39 + ( OffsetMain156 * float2( -1,0 ) ) ) ) * Mask38 ) + ( tex2D( _MainTexture, ( TextCoordUVs39 + ( OffsetMain156 * float2( 0,1 ) ) ) ) * Mask38 ) + ( tex2D( _MainTexture, ( TextCoordUVs39 + ( OffsetMain156 * float2( 0,-1 ) ) ) ) * Mask38 ) );
				float4 OffsetSetB136 = ( ( tex2D( _MainTexture, ( TextCoordUVs39 + ( OffsetMain156 * float2( 1,-1 ) ) ) ) * Mask38 ) + ( tex2D( _MainTexture, ( TextCoordUVs39 + ( OffsetMain156 * float2( -1,1 ) ) ) ) * Mask38 ) + ( tex2D( _MainTexture, ( TextCoordUVs39 + ( OffsetMain156 * float2( 1,1 ) ) ) ) * Mask38 ) + ( tex2D( _MainTexture, ( TextCoordUVs39 + ( OffsetMain156 * float2( 0,0 ) ) ) ) * Mask38 ) );
				float4 temp_output_140_0 = ( OffsetSetA104 + OffsetSetB136 );
				float4 Bloom50 = temp_output_140_0;
				

				finalColor = ( tex2DNode17 + ( Bloom50 * _Hue * _Intensity ) );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
232;73;1120;691;590.4718;168.1394;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;153;-2434.733,576.2183;Inherit;False;Property;_OffsetMain;Offset Main;5;0;Create;True;0;0;0;False;0;False;0.005;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;187;-2341.73,725.97;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;1000;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;186;-2114.73,623.97;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;16;-890.6614,-140.9174;Inherit;True;Property;_MainTexture;MainTexture;0;1;[HDR];Create;True;0;0;0;False;0;False;2bcfac437fa04a143b77e34f70ca970b;4032ecbed9e1c88409d1a3ae5815543a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;17;-524.7485,-140.1869;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;19;-585.1047,158.65;Inherit;False;Constant;_Brightness;Brightness;1;0;Create;True;0;0;0;False;0;False;0.2,0.7,0.07;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-580.4915,-347.9803;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;156;-1875.732,645.2183;Inherit;False;OffsetMain;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-243.1632,232.9222;Inherit;False;Property;_BloomThresholdMin;Bloom Threshold Min;1;0;Create;True;0;0;0;False;0;False;0.2764706;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;-2207.783,1057.798;Inherit;False;156;OffsetMain;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-291.0314,324.9597;Inherit;False;Property;_BloomThresholdMax;Bloom Threshold Max;2;0;Create;True;0;0;0;False;0;False;0.5705882;0.214;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;181;-408.3969,2394.343;Inherit;False;Constant;_Vector6;Vector 6;13;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;163;-2297.569,2094.298;Inherit;False;156;OffsetMain;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;171;-322.367,1244.584;Inherit;False;156;OffsetMain;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;179;-421.0468,2301.868;Inherit;False;156;OffsetMain;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;18;-210.1047,-47.35001;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;167;-2277.476,2510.505;Inherit;False;156;OffsetMain;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;175;-417.5222,1806.707;Inherit;False;156;OffsetMain;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-338.1938,-340.2156;Inherit;False;TextCoordUVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;173;-309.7171,1337.059;Inherit;False;Constant;_Vector4;Vector 4;13;0;Create;True;0;0;0;False;0;False;1,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;165;-2284.919,2186.773;Inherit;False;Constant;_Vector2;Vector 2;13;0;Create;True;0;0;0;False;0;False;0,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;161;-2285.08,1676.984;Inherit;False;Constant;_Vector1;Vector 1;13;0;Create;True;0;0;0;False;0;False;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;183;-465.1006,2705.397;Inherit;False;156;OffsetMain;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;177;-404.8723,1899.182;Inherit;False;Constant;_Vector5;Vector 5;13;0;Create;True;0;0;0;False;0;False;-1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;155;-2195.133,1150.273;Inherit;False;Constant;_Vector0;Vector 0;13;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;159;-2297.73,1584.51;Inherit;False;156;OffsetMain;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;169;-2264.826,2602.98;Inherit;False;Constant;_Vector3;Vector 3;13;0;Create;True;0;0;0;False;0;False;0,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;185;-452.4507,2797.872;Inherit;False;Constant;_Vector7;Vector 7;13;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;40;-2218.022,938.6034;Inherit;False;39;TextCoordUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;-2090.138,2142.38;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;-213.6137,2349.95;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-2185.248,2422.344;Inherit;False;39;TextCoordUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;-2090.297,1632.592;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-2174.299,1471.688;Inherit;False;39;TextCoordUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-309.4077,2616.772;Inherit;False;39;TextCoordUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-257.6676,2753.479;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-549.5106,-223.1367;Inherit;False;Texture;-1;True;1;0;SAMPLER2D;0,0,0,0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;-2070.042,2558.587;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-2185.103,2013.61;Inherit;False;39;TextCoordUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-298.4588,1666.116;Inherit;False;39;TextCoordUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;94;67.44934,130.0323;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-309.2627,2208.038;Inherit;False;39;TextCoordUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;-114.9341,1292.667;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;-210.0892,1854.789;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-276.5347,1120.406;Inherit;False;39;TextCoordUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;-2015.348,1105.88;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-1951.954,2021.694;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;114;-43.96078,1748.073;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1951.681,1387.634;Inherit;False;24;Texture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-74.35177,1067.137;Inherit;False;24;Texture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;-102.2497,2026.214;Inherit;False;24;Texture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-1889.352,970.5787;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-1950.192,872.7092;Inherit;False;24;Texture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-114.3358,2524.629;Inherit;False;24;Texture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;110;-13.5118,1165.006;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1959.845,2460.455;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-76.11373,2216.122;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;-1990.176,2330.201;Inherit;False;24;Texture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-1978.09,1831.786;Inherit;False;24;Texture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-84.00472,2654.883;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;38;329.4742,327.6362;Inherit;False;Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-75.84078,1582.062;Inherit;False;24;Texture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1919.801,1553.645;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;57;-1777.946,1919.169;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;96;-1613.265,1184.914;Inherit;False;38;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;262.5753,1379.342;Inherit;False;38;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;122;97.89423,2113.597;Inherit;True;Property;_TextureSample6;Texture Sample 6;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;131;122.1602,2874.739;Inherit;False;38;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-1717.414,2196.742;Inherit;False;38;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;-1797.8,2425.352;Inherit;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;55;-1751.537,1475.017;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;123;124.3033,1669.445;Inherit;True;Property;_TextureSample7;Texture Sample 7;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;52;-1708.717,969.934;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;127;210.2373,1930.052;Inherit;False;38;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;124;126.13,1177.945;Inherit;True;Property;_TextureSample8;Texture Sample 8;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;98;-1665.603,1735.624;Inherit;False;38;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;121;78.04022,2619.78;Inherit;True;Property;_TextureSample5;Texture Sample 5;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;129;158.4264,2391.17;Inherit;False;38;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-1753.68,2680.311;Inherit;False;38;Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;445.1124,2204.512;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-1430.728,2010.085;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-1378.917,1548.968;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;549.2614,1192.686;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;408.8464,2688.083;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-1466.994,2493.655;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-1326.579,998.2579;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;496.9234,1743.396;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-1011.88,1712.239;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;135;847.6279,1764.066;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;104;-755.7051,1754.213;Inherit;False;OffsetSetA;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;1063.364,1803.548;Inherit;False;OffsetSetB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;1469.885,1806.687;Inherit;False;104;OffsetSetA;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;1488.055,1896.06;Inherit;False;136;OffsetSetB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;140;1726.073,1850.867;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;2117.874,1900.541;Inherit;True;Bloom;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;554.4567,-41.62212;Inherit;True;50;Bloom;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;69;569.7816,330.8892;Inherit;False;Property;_Intensity;Intensity;3;0;Create;True;0;0;0;False;0;False;0;0.07;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;144;523.9857,157.632;Inherit;False;Property;_Hue;Hue;4;0;Create;True;0;0;0;False;0;False;1,0.7984268,0.4575472,0;1,0.4487945,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;851.9857,33.63196;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;1261.699,-175.1994;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;141;1660.259,1975.273;Inherit;False;Constant;_DividePercent;Divide Percent;4;0;Create;True;0;0;0;False;0;False;0.125;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;1876.447,1913.76;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;150;1614.58,-158.9126;Float;False;True;-1;2;ASEMaterialInspector;0;2;Bloom;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;186;0;153;0
WireConnection;186;1;187;0
WireConnection;17;0;16;0
WireConnection;26;2;16;0
WireConnection;156;0;186;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;39;0;26;0
WireConnection;164;0;163;0
WireConnection;164;1;165;0
WireConnection;180;0;179;0
WireConnection;180;1;181;0
WireConnection;160;0;159;0
WireConnection;160;1;161;0
WireConnection;184;0;183;0
WireConnection;184;1;185;0
WireConnection;24;0;16;0
WireConnection;168;0;167;0
WireConnection;168;1;169;0
WireConnection;94;0;18;0
WireConnection;94;1;22;0
WireConnection;94;2;95;0
WireConnection;172;0;171;0
WireConnection;172;1;173;0
WireConnection;176;0;175;0
WireConnection;176;1;177;0
WireConnection;154;0;157;0
WireConnection;154;1;155;0
WireConnection;33;0;42;0
WireConnection;33;1;164;0
WireConnection;114;0;107;0
WireConnection;114;1;176;0
WireConnection;31;0;40;0
WireConnection;31;1;154;0
WireConnection;110;0;120;0
WireConnection;110;1;172;0
WireConnection;34;0;43;0
WireConnection;34;1;168;0
WireConnection;111;0;119;0
WireConnection;111;1;180;0
WireConnection;108;0;115;0
WireConnection;108;1;184;0
WireConnection;38;0;94;0
WireConnection;32;0;41;0
WireConnection;32;1;160;0
WireConnection;57;0;56;0
WireConnection;57;1;33;0
WireConnection;122;0;112;0
WireConnection;122;1;111;0
WireConnection;59;0;58;0
WireConnection;59;1;34;0
WireConnection;55;0;54;0
WireConnection;55;1;32;0
WireConnection;123;0;109;0
WireConnection;123;1;114;0
WireConnection;52;0;53;0
WireConnection;52;1;31;0
WireConnection;124;0;106;0
WireConnection;124;1;110;0
WireConnection;121;0;113;0
WireConnection;121;1;108;0
WireConnection;130;0;122;0
WireConnection;130;1;129;0
WireConnection;101;0;57;0
WireConnection;101;1;100;0
WireConnection;99;0;55;0
WireConnection;99;1;98;0
WireConnection;126;0;124;0
WireConnection;126;1;125;0
WireConnection;132;0;121;0
WireConnection;132;1;131;0
WireConnection;103;0;59;0
WireConnection;103;1;102;0
WireConnection;97;0;52;0
WireConnection;97;1;96;0
WireConnection;128;0;123;0
WireConnection;128;1;127;0
WireConnection;46;0;97;0
WireConnection;46;1;99;0
WireConnection;46;2;101;0
WireConnection;46;3;103;0
WireConnection;135;0;126;0
WireConnection;135;1;128;0
WireConnection;135;2;130;0
WireConnection;135;3;132;0
WireConnection;104;0;46;0
WireConnection;136;0;135;0
WireConnection;140;0;137;0
WireConnection;140;1;139;0
WireConnection;50;0;140;0
WireConnection;143;0;61;0
WireConnection;143;1;144;0
WireConnection;143;2;69;0
WireConnection;64;0;17;0
WireConnection;64;1;143;0
WireConnection;138;0;140;0
WireConnection;138;1;141;0
WireConnection;150;0;64;0
ASEEND*/
//CHKSM=D21E4EBD44671C00AE2EA807A08C66C19D772138