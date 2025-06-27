// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Projector"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		_Hue("Hue", Color) = (0.2216981,1,0.9322789,0)
		_RotateScale("RotateScale", Range( 0 , 1)) = 1

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _Texture0;
			float4x4 unity_Projector;
			uniform float _RotateScale;
			uniform float4 _Hue;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1 = v.vertex;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float4 break3 = mul( unity_Projector, i.ase_texcoord1 );
				float4 appendResult7 = (float4(break3.x , break3.y , 0.0 , 0.0));
				float2 temp_cast_1 = (distance( i.ase_texcoord1.xyz , float3(0,0,0) )).xx;
				float mulTime15 = _Time.y * ( _RotateScale * 3.0 );
				float cos14 = cos( mulTime15 );
				float sin14 = sin( mulTime15 );
				float2 rotator14 = mul( ( appendResult7 / break3.w ).xy - temp_cast_1 , float2x2( cos14 , -sin14 , sin14 , cos14 )) + temp_cast_1;
				
				
				finalColor = ( tex2D( _Texture0, rotator14 ) + _Hue );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
232;73;1120;691;1626.192;684.5453;2.224959;True;True
Node;AmplifyShaderEditor.UnityProjectorMatrixNode;4;-999.9197,-23.22342;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.PosVertexDataNode;6;-991.9197,81.77658;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-747.9197,-20.22342;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-752.7523,572.3562;Inherit;False;Property;_RotateScale;RotateScale;2;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;3;-545.9197,-25.22342;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.Vector3Node;22;-522.6104,343.0896;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;7;-346.9197,-22.22342;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-438.1509,575.6835;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;20;-544.6104,173.0896;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;15;-299.7523,578.3562;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;8;-160.9197,95.7766;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DistanceOpNode;21;-259.6104,304.0896;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;10;-210.863,-223.7123;Inherit;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RotatorNode;14;-13.8685,228.1039;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;19;400.9856,272.0549;Inherit;False;Property;_Hue;Hue;1;0;Create;True;0;0;0;False;0;False;0.2216981,1,0.9322789,0;0.2216981,1,0.9322789,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;244.137,14.28772;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;683.4758,162.8889;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;13;877.9274,11.31454;Float;False;True;-1;2;ASEMaterialInspector;100;1;Projector;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;0;False;-1;True;0;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;5;0;4;0
WireConnection;5;1;6;0
WireConnection;3;0;5;0
WireConnection;7;0;3;0
WireConnection;7;1;3;1
WireConnection;17;0;16;0
WireConnection;15;0;17;0
WireConnection;8;0;7;0
WireConnection;8;1;3;3
WireConnection;21;0;20;0
WireConnection;21;1;22;0
WireConnection;14;0;8;0
WireConnection;14;1;21;0
WireConnection;14;2;15;0
WireConnection;9;0;10;0
WireConnection;9;1;14;0
WireConnection;24;0;9;0
WireConnection;24;1;19;0
WireConnection;13;0;24;0
ASEEND*/
//CHKSM=65464340BB955C73F4EECC0CAE269757B09C4A39