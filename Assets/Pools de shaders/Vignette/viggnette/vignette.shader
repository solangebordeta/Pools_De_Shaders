// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vignette"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Center("Center", Vector) = (0.5,0.5,0,0)
		_influence("influence", Range( 0 , 1)) = 0.6028774
		_Power("Power", Range( 0 , 10)) = 2.171314
		_Speed("Speed", Float) = 20
		_Scale("Scale", Float) = 600
		_center("center", Vector) = (0.5,0.5,0,0)
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
			#include "UnityShaderVariables.cginc"


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
			
			uniform float2 _Center;
			uniform float _Power;
			uniform float _influence;
			uniform float _Scale;
			uniform float _Speed;
			uniform float2 _center;
					float2 voronoihash33( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi33( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
						 		float2 o = voronoihash33( n + g );
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
						
			F1 = 8.0;
			for ( int j = -2; j <= 2; j++ )
			{
			for ( int i = -2; i <= 2; i++ )
			{
			float2 g = mg + float2( i, j );
			float2 o = voronoihash33( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
			float d = dot( 0.5 * ( r + mr ), normalize( r - mr ) );
			F1 = min( F1, d );
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
				float temp_output_8_0 = ( 1.0 - ( length( ( uv_MainTex - _Center ) ) * _Power ) );
				float lerpResult9 = lerp( temp_output_8_0 , ( 1.0 - step( temp_output_8_0 , 0.0 ) ) , ( _SinTime.z * _influence ));
				float viggnete40 = lerpResult9;
				float time33 = _Time.y;
				float2 temp_cast_0 = (6.95).xx;
				float2 temp_cast_1 = (( _Time.y * _Speed )).xx;
				float2 texCoord15 = i.uv.xy * temp_cast_0 + temp_cast_1;
				float2 coords33 = ( texCoord15 - _center ) * _Scale;
				float2 id33 = 0;
				float2 uv33 = 0;
				float voroi33 = voronoi33( coords33, time33, id33, uv33, 0 );
				float FilmNoise37 = (0.3 + (voroi33 - 0.0) * (1.0 - 0.3) / (1.0 - 0.0));
				

				finalColor = ( viggnete40 * tex2D( _MainTex, uv_MainTex ) * FilmNoise37 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
255;73;1215;586;584.4552;-62.30725;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;39;-1300.86,-447.8073;Inherit;False;2956.75;957.2675;Vignette;15;2;7;5;8;10;11;12;30;1;6;4;9;26;25;40;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;30;-1250.86,-397.8073;Inherit;True;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;4;-914.0904,-118.4014;Inherit;True;Property;_Center;Center;0;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-978.6416,-354.0625;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;36;1019.48,937.9708;Inherit;False;1337.135;816.5813;Film Noise;13;18;33;35;23;20;21;15;16;19;34;37;42;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2;-664.2213,-217.1372;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;18;1076.734,1038.715;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;5;-382.5988,-201.8332;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-449.7402,131.5305;Inherit;False;Property;_Power;Power;2;0;Create;True;0;0;0;False;0;False;2.171314;5.829937;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;1063.129,1163.659;Inherit;False;Property;_Speed;Speed;3;0;Create;True;0;0;0;False;0;False;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-117.1911,-21.36189;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;1246.2,1074.397;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;1180.929,1200.978;Inherit;True;Constant;_Angle;Angle;6;0;Create;True;0;0;0;False;0;False;6.95;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;21;1405.993,1260.176;Inherit;False;Property;_center;center;5;0;Create;True;0;0;0;False;0;False;0.5,0.5;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;8;194.0432,-32.0603;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;1402.586,1012.868;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;773.9482,376.6465;Inherit;False;Property;_influence;influence;1;0;Create;True;0;0;0;False;0;False;0.6028774;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;20;1626.578,986.0361;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;10;410.0067,80.40491;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;1644.044,1203.248;Inherit;False;Property;_Scale;Scale;4;0;Create;True;0;0;0;False;0;False;600;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;43;1639.11,1310.095;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;25;982.9946,227.7485;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;1774.891,1385.681;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;11;672.3254,166.9542;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;1168.388,255.4601;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;33;1850.076,1047.552;Inherit;False;0;0;1;4;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.LerpOp;9;1253.689,-17.63852;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;34;1899.066,1192.026;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;2176.058,1140.191;Inherit;False;FilmNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;27;1580.721,687.3625;Inherit;True;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;1458.67,280.222;Inherit;False;viggnete;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;1847.692,709.9846;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;38;2158.345,797.5234;Inherit;False;37;FilmNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;2175.909,655.2671;Inherit;False;40;viggnete;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;2393.626,694.1696;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2793.628,728.2834;Float;False;True;-1;2;ASEMaterialInspector;0;2;vignette;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;1;2;30;0
WireConnection;2;0;1;0
WireConnection;2;1;4;0
WireConnection;5;0;2;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;16;0;18;0
WireConnection;16;1;19;0
WireConnection;8;0;6;0
WireConnection;15;0;42;0
WireConnection;15;1;16;0
WireConnection;20;0;15;0
WireConnection;20;1;21;0
WireConnection;10;0;8;0
WireConnection;11;0;10;0
WireConnection;26;0;25;3
WireConnection;26;1;12;0
WireConnection;33;0;20;0
WireConnection;33;1;43;0
WireConnection;33;2;23;0
WireConnection;9;0;8;0
WireConnection;9;1;11;0
WireConnection;9;2;26;0
WireConnection;34;0;33;0
WireConnection;34;3;35;0
WireConnection;37;0;34;0
WireConnection;40;0;9;0
WireConnection;29;0;27;0
WireConnection;32;0;41;0
WireConnection;32;1;29;0
WireConnection;32;2;38;0
WireConnection;0;0;32;0
ASEEND*/
//CHKSM=BC0B8454DD981153451E16D507830404313234AD