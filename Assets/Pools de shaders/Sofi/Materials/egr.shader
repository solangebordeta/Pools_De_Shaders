// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "egr"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_Frequency2("Frequency2", Float) = 1
		_CollisionWaves2("CollisionWaves2", Vector) = (0,0,0,0)
		_Height2("Height2", Float) = 0
		_DeformationVector2("DeformationVector", Vector) = (0,5,0,0)
		_Color1("Color 0", Color) = (0.4862745,0.6816209,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float3 _CollisionWaves2;
		uniform float _Frequency2;
		uniform float3 _DeformationVector2;
		uniform float _Height2;
		uniform float4 _Color1;
		uniform float _EdgeLength;


		float2 voronoihash18( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi18( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -2; j <= 2; j++ )
			{
				for ( int i = -2; i <= 2; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash18( n + g );
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


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 Ripple29 = ( (0.0 + (sin( ( ( distance( ase_worldPos , _CollisionWaves2 ) + _Time.y ) * _Frequency2 ) ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) * _DeformationVector2 * _Height2 );
			v.vertex.xyz += Ripple29;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time18 = _Time.y;
			float2 temp_cast_1 = (1.0).xx;
			float2 temp_cast_2 = (_Time.y).xx;
			float2 uv_TexCoord7 = i.uv_texcoord + temp_cast_2;
			float2 panner13 = ( ( float2( 1,1 ) * 1.0 ).x * temp_cast_1 + uv_TexCoord7);
			float2 coords18 = panner13 * 2.65;
			float2 id18 = 0;
			float2 uv18 = 0;
			float fade18 = 0.5;
			float voroi18 = 0;
			float rest18 = 0;
			for( int it18 = 0; it18 <7; it18++ ){
			voroi18 += fade18 * voronoi18( coords18, time18, id18, uv18, 0 );
			rest18 += fade18;
			coords18 *= 2;
			fade18 *= 0.5;
			}//Voronoi18
			voroi18 /= rest18;
			float clampResult19 = clamp( voroi18 , 0.14 , 1.0 );
			float4 temp_cast_3 = (clampResult19).xxxx;
			float4 Albedo28 = ( _Color1 + CalculateContrast(1.74,temp_cast_3) );
			o.Albedo = Albedo28.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
249;73;1178;586;36.68866;-90.62317;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-2111.437,-763.4897;Inherit;False;2151.383;790.7847;Albedo;15;28;27;23;21;19;18;16;13;12;11;8;7;6;5;4;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1926.242,-131.9021;Inherit;False;Constant;_TimeScale1;Time Scale;10;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;5;-1922.929,-278.2802;Inherit;False;Constant;_Vector2;Vector 1;3;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector3Node;2;-1174.048,755.3993;Inherit;False;Property;_CollisionWaves2;CollisionWaves2;6;0;Create;True;0;0;0;False;0;False;0,0,0;-2.553201E-05,0.4824628,-4.344799E-07;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;3;-1173.59,597.5589;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;4;-2025.197,-511.8637;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1834.713,-567.8747;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.3,-0.27;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1728.929,-246.2802;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-941.863,825.5597;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;10;-896.3058,686.1039;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1812.905,-381.7148;Inherit;False;Constant;_Speed1;Speed;9;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-1483.185,-611.5188;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;13;-1515.713,-331.875;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-731.3156,680.2116;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-729.9117,815.7389;Inherit;False;Property;_Frequency2;Frequency2;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;18;-1247.784,-602.4198;Inherit;True;1;0;1;0;7;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;9.83;False;2;FLOAT;2.65;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;16;-1206.336,-165.441;Inherit;True;Constant;_Weight1;Weight;11;0;Create;True;0;0;0;False;0;False;0.14;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-500.0357,710.3702;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;19;-1013.353,-484.2618;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;20;-345.0152,709.8428;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;21;-755.8644,-454.4107;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.74;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;22;-194.011,863.4496;Inherit;False;Property;_DeformationVector2;DeformationVector;8;0;Create;True;0;0;0;False;0;False;0,5,0;0,5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;23;-730.3534,-654.4298;Inherit;False;Property;_Color1;Color 0;9;0;Create;True;0;0;0;False;0;False;0.4862745,0.6816209,1,0;0.4862745,0.6816209,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;24;-154.4029,620.3118;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-156.8184,1024.618;Inherit;False;Property;_Height2;Height2;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;170.1013,729.7462;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-475.5255,-505.9558;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-160.798,-473.1804;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;351.0087,723.043;Inherit;False;Ripple;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;462.3615,243.3325;Inherit;False;28;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;493.176,498.9688;Inherit;False;29;Ripple;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;947.0742,183.1201;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;egr;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;1;4;0
WireConnection;8;0;5;0
WireConnection;8;1;6;0
WireConnection;10;0;3;0
WireConnection;10;1;2;0
WireConnection;13;0;7;0
WireConnection;13;2;11;0
WireConnection;13;1;8;0
WireConnection;14;0;10;0
WireConnection;14;1;9;0
WireConnection;18;0;13;0
WireConnection;18;1;12;0
WireConnection;17;0;14;0
WireConnection;17;1;15;0
WireConnection;19;0;18;0
WireConnection;19;1;16;0
WireConnection;20;0;17;0
WireConnection;21;1;19;0
WireConnection;24;0;20;0
WireConnection;26;0;24;0
WireConnection;26;1;22;0
WireConnection;26;2;25;0
WireConnection;27;0;23;0
WireConnection;27;1;21;0
WireConnection;28;0;27;0
WireConnection;29;0;26;0
WireConnection;0;0;31;0
WireConnection;0;11;30;0
ASEEND*/
//CHKSM=A6B1F99C3651C3C4513C0670F94253946D19926B