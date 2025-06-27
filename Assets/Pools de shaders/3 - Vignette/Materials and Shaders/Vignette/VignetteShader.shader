// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VignetteShader"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_VignetteMultiplier("Vignette Multiplier", Range( 0 , 10)) = 8.821598
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_eyeDrop("eyeDrop", Range( 0 , 1)) = 0
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
			
			uniform float _Smoothness;
			uniform sampler2D _Texture0;
			uniform float4 _Texture0_ST;
			uniform float _VignetteMultiplier;
			uniform float _eyeDrop;
					float2 voronoihash3( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi3( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash3( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						 		}
						 	}
						}
						return F1;
					}
			


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
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float time3 = 0.0;
				float2 uv_Texture0 = i.uv.xy * _Texture0_ST.xy + _Texture0_ST.zw;
				float2 coords3 = uv_Texture0 * 1.0;
				float2 id3 = 0;
				float2 uv3 = 0;
				float voroi3 = voronoi3( coords3, time3, id3, uv3, 0 );
				float smoothstepResult15 = smoothstep( 0.0 , _Smoothness , ( 1.0 - ( voroi3 * _VignetteMultiplier ) ));
				float4 lerpResult28 = lerp( ( tex2D( _MainTex, uv_MainTex ) * smoothstepResult15 ) , float4( 0,0,0,0 ) , _eyeDrop);
				

				finalColor = lerpResult28;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
239;73;759;411;-509.334;-62.11807;1.394529;False;False
Node;AmplifyShaderEditor.CommentaryNode;18;-1287.366,-279.843;Inherit;False;2459.16;1061.388;Vignette;16;3;12;15;17;10;8;9;4;19;20;26;27;28;29;44;45;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;19;-1225.152,-149.2557;Inherit;False;1191.728;320.1671;Texture;2;2;1;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1149.679,-58.84753;Inherit;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;0;False;0;False;169cd14363d7d87499d0941a1c116013;169cd14363d7d87499d0941a1c116013;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-874.0279,208.0308;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;3;-571.0919,203.884;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;9;-618.5024,478.1024;Inherit;False;Property;_VignetteMultiplier;Vignette Multiplier;1;0;Create;True;0;0;0;False;0;False;8.821598;6;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-288.1738,210.6064;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;6.28;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;10;-26.84894,214.2245;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;20;-1192.031,174.327;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-73.20064,443.5588;Inherit;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;15;283.0605,209.2758;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-398.3149,-52.84179;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;169cd14363d7d87499d0941a1c116013;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;586.4971,126.8438;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;455.2733,497.8695;Inherit;False;Property;_eyeDrop;eyeDrop;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;297.515,1071.226;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;28;932.7887,315.2068;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;39;117.1511,1390.446;Inherit;False;Property;_eyeblink;eyeblink;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;-610.7524,1127.493;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;27;-355.1154,626.1772;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;26;-699.3691,662.5057;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-403.5533,882.205;Inherit;False;Property;_Smoothness1;Smoothness;5;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;21;-57.07706,632.7162;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;38;656.5756,1015.093;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;545.6664,699.5957;Inherit;False;Property;_VignetteMultiplier1;Vignette Multiplier;2;0;Create;True;0;0;0;False;0;False;0;6;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;41;-1231.112,1145.924;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;23;-321.4564,756.5613;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;22.71935,1116.909;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-863.8262,1258.801;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;35;-358.6548,1084.828;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;36;-434.4766,1383.894;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;429.5773,604.7173;Inherit;False;Property;_tuki;tuki;3;0;Create;True;0;0;0;False;0;False;8.821598;6;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;42;-205.3193,1381.487;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1184.359,132.2748;Float;False;True;-1;2;ASEMaterialInspector;0;2;VignetteShader;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;4;2;1;0
WireConnection;3;0;4;0
WireConnection;8;0;3;0
WireConnection;8;1;9;0
WireConnection;10;0;8;0
WireConnection;15;0;10;0
WireConnection;15;2;17;0
WireConnection;2;0;20;0
WireConnection;12;0;2;0
WireConnection;12;1;15;0
WireConnection;40;0;43;0
WireConnection;28;0;12;0
WireConnection;28;2;29;0
WireConnection;33;0;41;2
WireConnection;33;1;34;0
WireConnection;21;2;24;0
WireConnection;21;3;23;0
WireConnection;43;0;35;0
WireConnection;43;1;42;0
WireConnection;35;0;33;0
WireConnection;36;0;39;0
WireConnection;42;0;36;0
WireConnection;0;0;28;0
ASEEND*/
//CHKSM=A6D40892ECD75DA35F69B8628A0B9B49BFB6E502