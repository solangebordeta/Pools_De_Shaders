// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GrayScalePostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_GrayAmount("GrayAmount", Range( 0 , 1)) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Scale("Scale", Range( 0 , 1)) = 0.5739815
		_Center("Center", Vector) = (0.5,0.5,0,0)
		_Exponent("Exponent", Range( 0.5 , 2)) = 1.283719

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
				float2 temp_output_94_0 = ( i.uv.xy - _Center );
				float dotResult99 = dot( pow( length( temp_output_94_0 ) , _Exponent ) , _Exponent );
				float2 normalizeResult100 = normalize( temp_output_94_0 );
				float4 tex2DNode1 = tex2D( _TextureSample0, ( ( ( dotResult99 * _Scale ) * normalizeResult100 ) + _Center ) );
				float grayscale2 = Luminance(tex2DNode1.rgb);
				float4 temp_cast_1 = (grayscale2).xxxx;
				float4 lerpResult58 = lerp( tex2DNode1 , temp_cast_1 , _GrayAmount);
				

				finalColor = lerpResult58;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
382;81;730;424;3338.329;1266.719;5.105762;False;False
Node;AmplifyShaderEditor.CommentaryNode;107;-3035.412,-441.0897;Inherit;False;1867.932;760.4342;DISTORSION;12;103;102;100;101;99;98;97;96;95;94;92;93;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;93;-2878.792,-30.64668;Inherit;False;Property;_Center;Center;3;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexCoordVertexDataNode;92;-2907.734,-269.1978;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;94;-2617.445,-264.4628;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;95;-2330.032,-269.6154;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-2430.732,-6.509532;Inherit;False;Property;_Exponent;Exponent;4;0;Create;True;0;0;0;False;0;False;1.283719;2;0.5;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;97;-2120.166,-284.6085;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;99;-1867.442,-243.0373;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-2060.166,99.40207;Inherit;False;Property;_Scale;Scale;2;0;Create;True;0;0;0;False;0;False;0.5739815;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;100;-2341.767,-386.543;Inherit;False;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-1731.485,-284.8529;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-1501.245,-309.7929;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-1451.46,-20.11369;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;109;-1148.763,-109.5883;Inherit;False;367.7001;280;RENDER TEXTURE;1;1;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;108;-742.7311,-129.3155;Inherit;False;706.3284;468.5526;ESCALA DE GRIS;4;2;58;4;110;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;1;-1098.763,-59.58828;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;43bf5b26ae2481642b9b66ade36d32f8;43bf5b26ae2481642b9b66ade36d32f8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-653.9391,174.9017;Inherit;False;Property;_GrayAmount;GrayAmount;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;2;-635.8912,-34.66303;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;110;-640.741,72.92467;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;58;-341.5891,51.16892;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;10.98286,54.58273;Float;False;True;-1;2;ASEMaterialInspector;0;2;GrayScalePostProcess;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;94;0;92;0
WireConnection;94;1;93;0
WireConnection;95;0;94;0
WireConnection;97;0;95;0
WireConnection;97;1;96;0
WireConnection;99;0;97;0
WireConnection;99;1;96;0
WireConnection;100;0;94;0
WireConnection;101;0;99;0
WireConnection;101;1;98;0
WireConnection;102;0;101;0
WireConnection;102;1;100;0
WireConnection;103;0;102;0
WireConnection;103;1;93;0
WireConnection;1;1;103;0
WireConnection;2;0;1;0
WireConnection;110;0;1;0
WireConnection;58;0;110;0
WireConnection;58;1;2;0
WireConnection;58;2;4;0
WireConnection;0;0;58;0
ASEEND*/
//CHKSM=13D82941A6ECF8A1A32A42726254A1479ABDE9E0