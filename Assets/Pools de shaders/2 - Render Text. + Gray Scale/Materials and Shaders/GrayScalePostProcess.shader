// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GrayScalePostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_GrayAmount("GrayAmount", Range( 0 , 1)) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Scale("Scale", Range( 0 , 1)) = 1
		_Center("Center", Vector) = (0.5,0.5,0,0)
		_Exponent("Exponent", Range( 0.5 , 2)) = 1.238915

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
			
			uniform sampler2D _TextureSample0;
			uniform float2 _Center;
			uniform float _Exponent;
			uniform float _Scale;
			uniform float _GrayAmount;


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
				float2 temp_output_22_0 = ( i.uv.xy - _Center );
				float2 normalizeResult28 = normalize( temp_output_22_0 );
				float dotResult27 = dot( pow( length( temp_output_22_0 ) , _Exponent ) , _Exponent );
				float4 tex2DNode1 = tex2D( _TextureSample0, ( ( normalizeResult28 * ( dotResult27 * _Scale ) ) + _Center ) );
				float grayscale2 = Luminance(tex2DNode1.rgb);
				float4 temp_cast_1 = (grayscale2).xxxx;
				float4 lerpResult5 = lerp( tex2DNode1 , temp_cast_1 , _GrayAmount);
				

				finalColor = lerpResult5;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
239;73;759;348;3469.91;513.0496;5.397206;False;False
Node;AmplifyShaderEditor.Vector2Node;21;-2916.226,280.6704;Inherit;False;Property;_Center;Center;3;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexCoordVertexDataNode;20;-2957.406,-57.00554;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;-2670.09,-62.68316;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2529.446,208.5495;Inherit;False;Property;_Exponent;Exponent;4;0;Create;True;0;0;0;False;0;False;1.238915;1;0.5;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;23;-2467.466,-72.29826;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;25;-2257.6,-87.29131;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;27;-2004.876,-45.72014;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-2162.296,165.9245;Inherit;False;Property;_Scale;Scale;2;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1868.919,-87.53575;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;28;-2479.2,-189.2259;Inherit;False;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1638.679,-112.4758;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-1588.894,177.2035;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-1029.682,-49.44411;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;43bf5b26ae2481642b9b66ade36d32f8;43bf5b26ae2481642b9b66ade36d32f8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;2;-688.0018,-47.69286;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-544.7222,365.5095;Inherit;False;Property;_GrayAmount;GrayAmount;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-314.5512,-30.6158;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;5;-130.6797,111.6731;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;605.9039,89.81944;Float;False;True;-1;2;ASEMaterialInspector;0;2;GrayScalePostProcess;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;23;0;22;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;27;0;25;0
WireConnection;27;1;24;0
WireConnection;29;0;27;0
WireConnection;29;1;26;0
WireConnection;28;0;22;0
WireConnection;18;0;28;0
WireConnection;18;1;29;0
WireConnection;19;0;18;0
WireConnection;19;1;21;0
WireConnection;1;1;19;0
WireConnection;2;0;1;0
WireConnection;5;0;1;0
WireConnection;5;1;2;0
WireConnection;5;2;4;0
WireConnection;0;0;5;0
ASEEND*/
//CHKSM=E96DC5CCA841903449344899619923F9356E66C7