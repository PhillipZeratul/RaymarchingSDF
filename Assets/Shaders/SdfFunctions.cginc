#ifndef SDF_FUNCTIONS
#define SDF_FUNCTIONS

#include "UnityCG.cginc"

#define EPSILON 0.0001
#define ZERO (min(_Time.x, 0))

float SphereSDF(float3 pos, float3 center, float radius)
{
    return length(pos - center) - radius;
}

float BoxSDF(float3 pos, float3 center, float3 halfSize)
{
    float3 p = center - pos;
    float3 q = abs(p) - halfSize;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

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

float SceneSDF(float3 pos)
{
    float sphereDist = SphereSDF(pos, float3(0, 0, 0), 1.0);
    float boxDist = BoxSDF(pos, float3(3, 1, 0), float3(1, 2, 3));
    
    return UnionSDF(sphereDist, boxDist);
}

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