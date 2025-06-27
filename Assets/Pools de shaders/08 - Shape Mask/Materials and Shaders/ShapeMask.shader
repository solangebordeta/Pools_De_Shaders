// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShapeMask"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_Texture("Texture", 2D) = "white" {}
		_VignetteMultiplier("Vignette Multiplier", Range( 0 , 10)) = 8.821598
		_Scale("Scale", Range( 0 , 1)) = 0
		_Size("Size", Range( 0 , 1)) = 1

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform sampler2D _Texture;
			uniform float4 _Texture_ST;
			uniform float _VignetteMultiplier;
			uniform float _Size;
			uniform float _Scale;
					float2 voronoihash40( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi40( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
						 		float2 o = voronoihash40( n + g );
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
			

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float time40 = 0.0;
				float2 uv_Texture = IN.texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;
				float2 coords40 = uv_Texture * 1.0;
				float2 id40 = 0;
				float2 uv40 = 0;
				float voroi40 = voronoi40( coords40, time40, id40, uv40, 0 );
				float2 texCoord21 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 _Vector0 = float2(0.5,0.5);
				
				half4 color = ( step( ( voroi40 * _VignetteMultiplier ) , _Size ) * tex2D( _Texture, ( ( ( texCoord21 - _Vector0 ) * ( 1.0 - _Scale ) ) + _Vector0 ) ) );
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;23;1920;996;1193.497;299.4038;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;36;-1890.974,328.277;Inherit;False;877.8033;653.2114;Zoom;7;9;22;21;30;33;35;34;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;37;-1029.062,-415.9437;Inherit;False;1108.572;684.1218;Mask & Texture;10;41;44;48;42;40;39;0;6;5;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;22;-1801.581,578.127;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;4;-977.6875,-362.5205;Inherit;True;Property;_Texture;Texture;0;0;Create;True;0;0;0;False;0;False;None;37d375eab2f2dca498286421c8760506;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1840.974,378.277;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-1811.929,723.3284;Inherit;True;Property;_Scale;Scale;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;30;-1516.893,453.049;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;33;-1518.487,774.7075;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-989.2592,-127.1627;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;40;-704.124,-108.2982;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;41;-760.6835,171.9748;Inherit;False;Property;_VignetteMultiplier;Vignette Multiplier;1;0;Create;True;0;0;0;False;0;False;8.821598;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1314.787,575.0646;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1165.761,460.5194;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-508.4841,-169.4234;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;6.28;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-387.028,139.3696;Inherit;False;Property;_Size;Size;3;0;Create;True;0;0;0;False;0;False;1;0.483;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-702.5229,-355.4179;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;48;-195.4875,-177.8909;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-281.1374,-321.1774;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-98.03866,-313.9736;Float;False;True;-1;2;ASEMaterialInspector;0;4;ShapeMask;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;30;0;21;0
WireConnection;30;1;22;0
WireConnection;33;0;9;0
WireConnection;39;2;4;0
WireConnection;40;0;39;0
WireConnection;35;0;30;0
WireConnection;35;1;33;0
WireConnection;34;0;35;0
WireConnection;34;1;22;0
WireConnection;42;0;40;0
WireConnection;42;1;41;0
WireConnection;5;0;4;0
WireConnection;5;1;34;0
WireConnection;48;0;42;0
WireConnection;48;1;44;0
WireConnection;6;0;48;0
WireConnection;6;1;5;0
WireConnection;0;0;6;0
ASEEND*/
//CHKSM=9047A2E6BB8E17D89C3BAB310BAEE3366B9B977D