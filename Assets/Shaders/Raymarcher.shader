Shader "Zeratul/Raymarcher"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Cull Off
        ZWrite Off
        ZTest Always

        Pass
        {
            HLSLPROGRAM
            #pragma enable_d3d11_debug_symbols

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "SdfFunctions.cginc"
            #include "LightingFunctions.cginc"

            struct appdata
            {
                uint id : SV_VertexID;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
            };

            SamplerState sampler_bilinear_clamp;
            Texture2D<float4> _MainTex;
            float4 _ScreenTriangleCorners[3];
            float _MaxDistance;
            float _MaxSteps;
            float3 _LightPos;
            float3 _LightColor;

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f, o);

                o.uv.x = (v.id == 2) ? 2.0 : 0.0;
                o.uv.y = (v.id == 1) ? 2.0 : 0.0;

                o.position = float4(o.uv * float2(2.0, -2.0) + float2(-1.0, 1.0), 1.0, 1.0);

                #if UNITY_UV_STARTS_AT_TOP
                    o.uv = o.uv * float2(1.0, -1.0) + float2(0.0, 1.0);
                #endif

                o.viewDir = _ScreenTriangleCorners[v.id].xyz;
                return o;
            }

            float4 frag (v2f IN) : SV_Target
            {
                float3 viewDirWS = normalize(IN.viewDir);

                float3 curPos = _WorldSpaceCameraPos.xyz;
                float distance = 0;
                float4 color = 0;

                float3 diffuse = float3(0.7, 0.2, 0.2);
                float3 specular = float3(1.0, 1.0, 1.0);
                float shininess = 10.0;



                for (int i = 0; (i < _MaxSteps) && (distance < _MaxDistance); i++)
                {
                    float stepDistance = SceneSDF(curPos);
                    if (stepDistance < EPSILON)
                    {
                        float3 normal = EstimateNormal(curPos);
                        color.rgb = PhongLighting(diffuse, specular, shininess, curPos, normal, 
                                                  _WorldSpaceCameraPos.xyz, _LightPos, _LightColor);
                        color.a = 1;
                        break;
                    }
                    distance += stepDistance;
                    curPos = _WorldSpaceCameraPos.xyz + viewDirWS * distance;
                }

                float4 mainTex = _MainTex.Sample(sampler_bilinear_clamp, IN.uv);
                return lerp(mainTex, color, color.a);
            }
            ENDHLSL
        }
    }
}
