// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LocalMeshDeformationShader2"
{
	Properties
	{
		_Frequency1("Frequency", Float) = 1
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 24.5
		_CollisionWaves1("CollisionWaves", Vector) = (0,0,0,0)
		_Height1("Height", Float) = 0
		_DeformationVector1("DeformationVector", Vector) = (0,5,0,0)
		_Speed("Speed", Float) = 1
		_TimeScale("Time Scale", Float) = 1
		_Weight("Weight", Float) = 0.14
		_Color0("Color 0", Color) = (0.4862745,0.6816209,1,0)
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

		uniform float3 _CollisionWaves1;
		uniform float _Frequency1;
		uniform float3 _DeformationVector1;
		uniform float _Height1;
		uniform float4 _Color0;
		uniform float _TimeScale;
		uniform float _Speed;
		uniform float _Weight;
		uniform float _EdgeLength;


		float2 voronoihash22( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi22( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash22( n + g );
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
			float3 Ripple49 = ( (0.0 + (sin( ( ( distance( ase_worldPos , _CollisionWaves1 ) + _Time.y ) * _Frequency1 ) ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) * _DeformationVector1 * _Height1 );
			v.vertex.xyz += Ripple49;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time22 = _Time.y;
			float2 temp_cast_1 = (_Speed).xx;
			float2 temp_cast_2 = (_Time.y).xx;
			float2 uv_TexCoord11 = i.uv_texcoord + temp_cast_2;
			float2 panner19 = ( ( float2( 1,1 ) * _TimeScale ).x * temp_cast_1 + uv_TexCoord11);
			float2 coords22 = panner19 * 2.65;
			float2 id22 = 0;
			float2 uv22 = 0;
			float fade22 = 0.5;
			float voroi22 = 0;
			float rest22 = 0;
			for( int it22 = 0; it22 <7; it22++ ){
			voroi22 += fade22 * voronoi22( coords22, time22, id22, uv22, 0 );
			rest22 += fade22;
			coords22 *= 2;
			fade22 *= 0.5;
			}//Voronoi22
			voroi22 /= rest22;
			float clampResult24 = clamp( voroi22 , _Weight , 1.0 );
			float4 temp_cast_3 = (clampResult24).xxxx;
			float4 Albedo33 = ( _Color0 + CalculateContrast(1.74,temp_cast_3) );
			o.Albedo = Albedo33.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
233.6;73.6;663.6;574.2;-702.2598;-162.3905;1.3;False;False
Node;AmplifyShaderEditor.CommentaryNode;4;-1589.075,-900.901;Inherit;False;2151.383;790.7847;Albedo;15;33;32;29;28;24;22;21;19;18;12;11;10;9;8;7;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;41;-651.6857,617.988;Inherit;False;Property;_CollisionWaves1;CollisionWaves;6;0;Create;True;0;0;0;False;0;False;0,0,0;10,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;7;-1403.88,-269.3134;Inherit;False;Property;_TimeScale;Time Scale;10;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;40;-651.2276,460.1476;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;9;-1400.567,-415.6915;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;8;-1502.835,-649.275;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1290.543,-519.1261;Inherit;False;Property;_Speed;Speed;9;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1312.351,-705.286;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.3,-0.27;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1206.567,-383.6915;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;43;-419.501,688.1484;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;42;-373.9438,548.6926;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;18;-960.8232,-748.9301;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;19;-993.3513,-469.2863;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-207.5497,678.3276;Inherit;False;Property;_Frequency1;Frequency;0;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-208.9535,542.8003;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;22;-725.4223,-739.8311;Inherit;True;1;0;1;0;7;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;9.83;False;2;FLOAT;2.65;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;21;-731.9742,-302.8523;Inherit;False;Property;_Weight;Weight;11;0;Create;True;0;0;0;False;0;False;0.14;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;22.32636,572.9589;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;24;-490.9913,-621.6731;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;45;177.3469,572.4315;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;29;-233.5023,-591.822;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.74;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;46;328.3511,726.0383;Inherit;False;Property;_DeformationVector1;DeformationVector;8;0;Create;True;0;0;0;False;0;False;0,5,0;0,5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;28;-207.9913,-791.8411;Inherit;False;Property;_Color0;Color 0;12;0;Create;True;0;0;0;False;0;False;0.4862745,0.6816209,1,0;0.4862745,0.6816209,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;48;367.9592,482.9005;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;365.5437,887.2071;Inherit;False;Property;_Height1;Height;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;692.4633,592.3349;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;46.83661,-643.3671;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;361.5641,-610.5917;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;873.3708,585.6317;Inherit;False;Ripple;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;1015.538,361.5575;Inherit;False;49;Ripple;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;984.7236,105.9212;Inherit;False;33;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1284.751,80.29689;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;LocalMeshDeformationShader2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;24.5;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;1;8;0
WireConnection;12;0;9;0
WireConnection;12;1;7;0
WireConnection;42;0;40;0
WireConnection;42;1;41;0
WireConnection;19;0;11;0
WireConnection;19;2;10;0
WireConnection;19;1;12;0
WireConnection;38;0;42;0
WireConnection;38;1;43;0
WireConnection;22;0;19;0
WireConnection;22;1;18;0
WireConnection;44;0;38;0
WireConnection;44;1;39;0
WireConnection;24;0;22;0
WireConnection;24;1;21;0
WireConnection;45;0;44;0
WireConnection;29;1;24;0
WireConnection;48;0;45;0
WireConnection;37;0;48;0
WireConnection;37;1;46;0
WireConnection;37;2;47;0
WireConnection;32;0;28;0
WireConnection;32;1;29;0
WireConnection;33;0;32;0
WireConnection;49;0;37;0
WireConnection;0;0;35;0
WireConnection;0;11;36;0
ASEEND*/
//CHKSM=EBAA364DED8D2AE873F6DE6E4DFA0F1BCC56C9BA