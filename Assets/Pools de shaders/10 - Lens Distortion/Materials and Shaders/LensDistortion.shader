// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LensDistortion"
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
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Scale("Scale", Range( 0 , 1)) = 1
		_Center("Center", Vector) = (0.5,0.5,0,0)
		_Exponent("Exponent", Range( 0.5 , 2)) = 1

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
			uniform sampler2D _TextureSample1;
			uniform float2 _Center;
			uniform float _Exponent;
			uniform float _Scale;

			
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

				float2 temp_output_6_0 = ( IN.texcoord.xy - _Center );
				float2 normalizeResult24 = normalize( temp_output_6_0 );
				float dotResult49 = dot( pow( length( temp_output_6_0 ) , _Exponent ) , _Exponent );
				
				half4 color = tex2D( _TextureSample1, ( ( float4( normalizeResult24, 0.0 , 0.0 ) * ( dotResult49 * _Scale ) ) + float4( _Center, 0.0 , 0.0 ) ).xy );
				
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
795;684;480;270;6252.425;464.0294;1.385764;False;False
Node;AmplifyShaderEditor.TexCoordVertexDataNode;5;-5801.09,93.17308;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;4;-5759.91,430.8492;Inherit;True;Property;_Center;Center;2;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;6;-5513.774,87.49551;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;7;-5311.15,77.88036;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-5436.9,349.9326;Inherit;False;Property;_Exponent;Exponent;3;0;Create;True;0;0;0;False;0;False;1;2;0.5;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;31;-5101.284,62.88731;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-4999.118,332.1138;Inherit;False;Property;_Scale;Scale;1;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;49;-4848.56,104.4585;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;24;-5322.885,-39.04716;Inherit;False;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-4712.603,62.64286;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-4482.363,37.70287;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-4432.578,327.3822;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;21;-4131.716,301.2091;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-3747.286,310.714;Float;False;True;-1;2;ASEMaterialInspector;0;4;LensDistortion;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;6;0;5;0
WireConnection;6;1;4;0
WireConnection;7;0;6;0
WireConnection;31;0;7;0
WireConnection;31;1;23;0
WireConnection;49;0;31;0
WireConnection;49;1;23;0
WireConnection;24;0;6;0
WireConnection;9;0;49;0
WireConnection;9;1;10;0
WireConnection;29;0;24;0
WireConnection;29;1;9;0
WireConnection;11;0;29;0
WireConnection;11;1;4;0
WireConnection;21;1;11;0
WireConnection;0;0;21;0
ASEEND*/
//CHKSM=4CA2BBD5903CB2C85CF9150FD94457010981DA88