Shader "Toon"
{
	Properties
	{
		_Color("Color", Color) = (0.5, 0.65, 1, 1)
		_MainTex("Main Texture", 2D) = "white" {}
		
		[HDR]
		_AmbientColor("Ambient Color", Color) = (0.4, 0.4, 0.4, 1)
		_SpecularColor("Specular Color", Color) = (0.9, 0.9, 0.9, 1)
		_Glossiness("Glossiness", Float) = 32
		_RimColor("Rim Color", Color) = (1, 1, 1, 1)
		_RimAmount("Rim Amount", Range(0, 1)) = 0.716
		_RimThreshold("Rim Threshold", Range(0, 1)) = 0.1
	}
	SubShader
	{
		Pass
		{
			Tags
			{
				"LightMode" = "ForwardBase"
				"PassFlags" = "OnlyDirectional"
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;				
				float4 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 worldNormal : NORMAL;
				float3 viewDir : TEXCOORD1;
				float2 uv : TEXCOORD0;
				SHADOW_COORDS(2)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = WorldSpaceViewDir(v.vertex);
				TRANSFER_SHADOW(o)
				return o;
			}
			
			float4 _Color;
			float4 _AmbientColor;
			float4 _SpecularColor;
			float  _Glossiness;
			float4 _RimColor;
			float  _RimAmount;
			float  _RimThreshold;

			float4 frag (v2f i) : SV_Target
			{
				float3 viewDir = normalize(i.viewDir);				//normalize the view direction vector in world space
				float4 sample = tex2D(_MainTex, i.uv);				//sample the main texture
				float3 normal = normalize(i.worldNormal);			//normalize the model's normals (in world space)
				float NdotL = dot(_WorldSpaceLightPos0, normal);	//find the dot product between the main directional light and the model's normals
				float shadow = SHADOW_ATTENUATION(i);
				float lightIntensity = smoothstep(0, 0.01, NdotL * shadow);							//will be used to create distinct bands of lighting with shadows applied
																										//keeps NdotL in the 0-1 range, while smoothing the transition from 0-0.01

				float3 halfVector = normalize(_WorldSpaceLightPos0 + viewDir);						//sum the light vector and view direction vectors, then normalize them
				float NdotH = dot(normal, halfVector);												//fint the dot product between model normals and the half vector
				float specularIntensity = pow(NdotH * lightIntensity, _Glossiness * _Glossiness);	//multiply N/H dot product with light intensity so reflection only drawn on lit surface
																										//raise to glossiness squared so smaller values in editer have a larger effect
				float specularIntensitySmooth = smoothstep(0.005, 0.01, specularIntensity);			//toonify specular by making anything above 0.01 be treated as 1, smooth the transition
				float4 specular = specularIntensitySmooth * _SpecularColor;							//account for the specular color

				float4 rimDot = 1 - dot(viewDir, normal);
				float rimIntensity = rimDot * pow(NdotL, _RimThreshold);
				rimIntensity = smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, rimIntensity);
				float rim = rimIntensity * _RimColor;

				float4 light = lightIntensity * _LightColor0;		//account for the color of the main directional light

				return _Color * sample * (_AmbientColor + light + specular + rim);
			}
			ENDCG
		}

		UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
	}
}