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
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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
                float3 viewDirWS = IN.viewDir;

                return float4(viewDirWS, 0);
            }
            ENDCG
        }
    }
}
