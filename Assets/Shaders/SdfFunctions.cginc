#ifndef SDF_FUNCTIONS
#define SDF_FUNCTIONS

#include "UnityCG.cginc"

#define EPSILON 0.0001
#define ZERO (min(_Time.x, 0))

float SphereSDF(float3 pos, float radius)
{
    return length(pos) - radius;
}

float BoxSDF(float3 pos, float3 halfSize)
{
    float3 q = abs(pos) - halfSize;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

// Combinations
float IntersectSDF(float distA, float distB)
{
    return max(distA, distB);
}

float UnionSDF(float distA, float distB)
{
    return min(distA, distB);
}

float DifferenceSDF(float distA, float distB)
{
    return max(distA, -distB);
}

// Positioning
float3 TranslateSDF(float3 pos, float3 vec)
{
    return pos - vec;
}

float3 RotateXSDF(float3 pos, float theta)
{
    theta = -theta;
    float c = cos(theta);
    float s = sin(theta);
    float4x4 mat = float4x4(1.0, 0, 0, 0,
                            0, c, -s, 0,
                            0, s, c, 0,
                            0, 0, 0, 1.0);
    return mul(mat, float4(pos, 1.0));
}

float3 RotateYSDF(float3 pos, float theta)
{
    theta = -theta;
    float c = cos(theta);
    float s = sin(theta);
    float4x4 mat = float4x4(c, 0, s, 0,
                            0, 1.0, 0, 0,
                            -s, 0, c, 0,
                            0, 0, 0, 1.0);
    return mul(mat, float4(pos, 1.0));
}

float3 RotateZSDF(float3 pos, float theta)
{
    theta = -theta;
    float c = cos(theta);
    float s = sin(theta);
    float4x4 mat = float4x4(c, -s, 0, 0,
                            s, c, 0, 0,
                            0, 0, 1.0, 0,
                            0, 0, 0, 1.0);
    return mul(mat, float4(pos, 1.0));
}

float SceneSDF(float3 pos)
{
    float3 spherePos = TranslateSDF(pos, float3(-1, -1, 1));
    float sphereDist = SphereSDF(spherePos, 1.5);

    float3 boxPos = RotateXSDF(pos, 0.5);
    boxPos = RotateZSDF(boxPos, 0.5);
    boxPos = TranslateSDF(boxPos, float3(2, 2, -1));
    float boxDist = BoxSDF(boxPos, float3(1, 2, 3));

    return UnionSDF(sphereDist, boxDist);
}

// Normal
//https://iquilezles.org/www/articles/normalsSDF/normalsSDF.htm
float3 CalculateNormal(float3 pos, float h)
{
    float3 n = 0.0;
    for (int i = ZERO; i < 4; i++)
    {
        float3 e = 0.5773 * (2.0 * float3((((i + 3) >> 1) & 1), ((i >> 1) & 1), (i & 1)) - 1.0);
        n += e * SceneSDF(pos + h * e).x;
    }
    return normalize(n);
}

#endif //SDF_FUNCTIONS