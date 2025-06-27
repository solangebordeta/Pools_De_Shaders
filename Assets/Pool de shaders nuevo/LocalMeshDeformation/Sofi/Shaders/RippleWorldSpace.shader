// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RippleWorldSpace"
{
	Properties
	{
		_Frequency("Frequency", Float) = 1
		_CollisionWaves("CollisionWaves", Vector) = (0,0,0,0)
		_Height("Height", Float) = 0
		_DeformationVector("DeformationVector", Vector) = (0,5,0,0)
		_Color1("Color 1", Color) = (1,0,0,0)
		_Color0("Color 0", Color) = (0.2287085,1,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
		};

		uniform float3 _CollisionWaves;
		uniform float _Frequency;
		uniform float3 _DeformationVector;
		uniform float _Height;
		uniform float4 _Color0;
		uniform float4 _Color1;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_9_0 = (0.0 + (sin( ( ( distance( ase_worldPos , _CollisionWaves ) + _Time.y ) * _Frequency ) ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0));
			v.vertex.xyz += ( temp_output_9_0 * _DeformationVector * _Height );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float temp_output_9_0 = (0.0 + (sin( ( ( distance( ase_worldPos , _CollisionWaves ) + _Time.y ) * _Frequency ) ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0));
			float4 lerpResult10 = lerp( _Color0 , _Color1 , temp_output_9_0);
			o.Albedo = lerpResult10.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
233.6;73.6;548.4;482.2;-503.0017;-9.85968;1.3;False;False
Node;AmplifyShaderEditor.WorldPosInputsNode;16;-758.1902,328.6769;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;2;-758.6483,486.5174;Inherit;False;Property;_CollisionWaves;CollisionWaves;1;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;3;-480.9065,417.222;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;5;-526.4636,556.6778;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-315.9162,411.3296;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-314.5124,546.857;Inherit;False;Property;_Frequency;Frequency;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-84.63631,441.4882;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;8;70.38425,440.9609;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;268.4447,-234.1008;Inherit;False;Property;_Color0;Color 0;5;0;Create;True;0;0;0;False;0;False;0.2287085,1,0,0;0.2287085,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;12;268.4445,-45.03782;Inherit;False;Property;_Color1;Color 1;4;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;14;221.3884,594.5677;Inherit;False;Property;_DeformationVector;DeformationVector;3;0;Create;True;0;0;0;False;0;False;0,5,0;0,5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;15;258.581,755.7363;Inherit;False;Property;_Height;Height;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;9;260.9965,351.4299;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;10;589.2319,32.447;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;738.0028,216.8609;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1029.713,-88.2606;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;RippleWorldSpace;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;16;0
WireConnection;3;1;2;0
WireConnection;4;0;3;0
WireConnection;4;1;5;0
WireConnection;6;0;4;0
WireConnection;6;1;7;0
WireConnection;8;0;6;0
WireConnection;9;0;8;0
WireConnection;10;0;11;0
WireConnection;10;1;12;0
WireConnection;10;2;9;0
WireConnection;13;0;9;0
WireConnection;13;1;14;0
WireConnection;13;2;15;0
WireConnection;0;0;10;0
WireConnection;0;11;13;0
ASEEND*/
//CHKSM=F54796629F316FC47F08BC389DBBE33B573E5817