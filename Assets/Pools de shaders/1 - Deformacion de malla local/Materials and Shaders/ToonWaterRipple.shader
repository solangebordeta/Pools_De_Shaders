// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ToonWaterRipple"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 1
		_Speed("Speed", Float) = 1
		_TimeScale("Time Scale", Float) = 1
		_Weight("Weight", Float) = 0.14
		_Color0("Color 0", Color) = (0.4862745,0.6816209,1,0)
		_Frequency("Frequency", Float) = 1
		_DeformationVector("DeformationVector", Vector) = (0,5,0,0)
		_Height("Height", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Frequency;
		uniform float3 _DeformationVector;
		uniform float _Height;
		uniform float4 _Color0;
		uniform float _TimeScale;
		uniform float _Speed;
		uniform float _Weight;
		uniform float _TessValue;
		uniform float _TessPhongStrength;


		float2 voronoihash13( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi13( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash13( n + g );
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

		float4 tessFunction( )
		{
			return _TessValue;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_27_0 = distance( ase_vertex3Pos , float3(0,0,0) );
			float3 clampResult145 = clamp( ( (0.0 + (sin( ( ( temp_output_27_0 - _Time.y ) * _Frequency ) ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) * _DeformationVector * sin( ( _Height * (1.0 + (temp_output_27_0 - 0.0) * (0.0 - 1.0) / (3.0 - 0.0)) ) ) ) , float3( 0.1,0.1,0.1 ) , float3( 1,1,1 ) );
			float3 Ripple42 = clampResult145;
			float3 temp_output_43_0 = Ripple42;
			v.vertex.xyz += temp_output_43_0;
			v.vertex.w = 1;
			v.normal = temp_output_43_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time13 = _Time.y;
			float2 temp_cast_1 = (_Speed).xx;
			float2 temp_cast_2 = (_Time.y).xx;
			float2 uv_TexCoord8 = i.uv_texcoord + temp_cast_2;
			float2 panner7 = ( ( float2( 1,1 ) * _TimeScale ).x * temp_cast_1 + uv_TexCoord8);
			float2 coords13 = panner7 * 2.65;
			float2 id13 = 0;
			float2 uv13 = 0;
			float fade13 = 0.5;
			float voroi13 = 0;
			float rest13 = 0;
			for( int it13 = 0; it13 <7; it13++ ){
			voroi13 += fade13 * voronoi13( coords13, time13, id13, uv13, 0 );
			rest13 += fade13;
			coords13 *= 2;
			fade13 *= 0.5;
			}//Voronoi13
			voroi13 /= rest13;
			float clampResult16 = clamp( voroi13 , _Weight , 1.0 );
			float4 temp_cast_3 = (clampResult16).xxxx;
			float4 Albedo22 = ( _Color0 + CalculateContrast(1.74,temp_cast_3) );
			o.Albedo = Albedo22.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
239;73;759;348;5929.836;2902.81;15.01786;False;False
Node;AmplifyShaderEditor.CommentaryNode;147;-2555.85,305.1888;Inherit;False;2128.854;886.683;Ripple;19;146;140;42;145;36;143;33;35;142;32;34;31;30;92;141;27;28;126;26;Ripple;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;126;-2505.305,391.4459;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;26;-2485.634,533.0768;Inherit;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;23;-2587.446,-731.8687;Inherit;False;2151.383;790.7847;Albedo;15;22;19;18;17;16;13;14;20;7;8;11;1;12;10;2;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.DistanceOpNode;27;-2244.862,468.7526;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;10;-2398.938,-246.6592;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;141;-2102.037,831.6536;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-2501.206,-480.2428;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;28;-2039.322,687.3182;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-2402.251,-100.2811;Inherit;False;Property;_TimeScale;Time Scale;6;0;Create;True;0;0;0;False;0;False;1;1.62;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2204.938,-214.6592;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2310.722,-536.254;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.3,-0.27;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-1825.083,755.6539;Inherit;False;Property;_Frequency;Frequency;9;0;Create;True;0;0;0;False;0;False;1;7.76;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;146;-1709.839,866.2059;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;92;-1803.646,603.1082;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-2288.914,-350.0941;Inherit;False;Property;_Speed;Speed;5;0;Create;True;0;0;0;False;0;False;1;6.91;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;7;-1991.722,-300.254;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1628.891,581.4342;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1609.043,926.3676;Inherit;False;Property;_Height;Height;11;0;Create;True;0;0;0;False;0;False;1;1.91;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;20;-1959.194,-579.8975;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;140;-1624.261,1009.302;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;3;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;32;-1443.373,526.1685;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;13;-1723.793,-570.7988;Inherit;True;1;0;1;0;7;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;9.83;False;2;FLOAT;2.65;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-1401.235,986.3116;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1730.345,-133.82;Inherit;False;Property;_Weight;Weight;7;0;Create;True;0;0;0;False;0;False;0.14;-3.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;33;-1314.732,534.672;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;143;-1242.834,934.4166;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;16;-1489.362,-452.6404;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;35;-1616.332,764.7721;Inherit;False;Property;_DeformationVector;DeformationVector;10;0;Create;True;0;0;0;False;0;False;0,5,0;0,0.51,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1085.672,614.5394;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;17;-1231.873,-422.7901;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.74;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;18;-1206.362,-622.8092;Inherit;False;Property;_Color0;Color 0;8;0;Create;True;0;0;0;False;0;False;0.4862745,0.6816209,1,0;0.4862745,0.6816209,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;145;-836.3904,663.0569;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0.1,0.1,0.1;False;2;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-951.5341,-474.3352;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-683.2108,-428.9034;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-662.1615,638.8323;Inherit;False;Ripple;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;59.06598,-674.5012;Inherit;False;22;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-163.4893,-399.2161;Inherit;False;42;Ripple;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;243.1402,-681.458;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;ToonWaterRipple;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;1;32;10;25;True;1;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;27;0;126;0
WireConnection;27;1;26;0
WireConnection;141;0;27;0
WireConnection;11;0;10;0
WireConnection;11;1;2;0
WireConnection;8;1;12;0
WireConnection;146;0;141;0
WireConnection;92;0;27;0
WireConnection;92;1;28;0
WireConnection;7;0;8;0
WireConnection;7;2;1;0
WireConnection;7;1;11;0
WireConnection;31;0;92;0
WireConnection;31;1;30;0
WireConnection;140;0;146;0
WireConnection;32;0;31;0
WireConnection;13;0;7;0
WireConnection;13;1;20;0
WireConnection;142;0;34;0
WireConnection;142;1;140;0
WireConnection;33;0;32;0
WireConnection;143;0;142;0
WireConnection;16;0;13;0
WireConnection;16;1;14;0
WireConnection;36;0;33;0
WireConnection;36;1;35;0
WireConnection;36;2;143;0
WireConnection;17;1;16;0
WireConnection;145;0;36;0
WireConnection;19;0;18;0
WireConnection;19;1;17;0
WireConnection;22;0;19;0
WireConnection;42;0;145;0
WireConnection;0;0;21;0
WireConnection;0;11;43;0
WireConnection;0;12;43;0
ASEEND*/
//CHKSM=9E30C559C416AABC8E1D89BDB7D254FCD74591F0