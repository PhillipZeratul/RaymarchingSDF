#ifndef SDF_FUNCTIONS
#define SDF_FUNCTIONS

#define EPSILON 0.001

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
    float boxDist = BoxSDF(pos, float3(2, 1, 0), float3(1, 2, 3));
    
    return UnionSDF(sphereDist, boxDist);
}

float3 EstimateNormal(float3 pos)
{
    float3 normal = float3(
        SceneSDF(float3(pos.x + EPSILON, pos.y, pos.z)) - SceneSDF(float3(pos.x - EPSILON, pos.y, pos.z)),
        SceneSDF(float3(pos.x, pos.y + EPSILON, pos.z)) - SceneSDF(float3(pos.x, pos.y - EPSILON, pos.z)),
        SceneSDF(float3(pos.x, pos.y, pos.z + EPSILON)) - SceneSDF(float3(pos.x, pos.y, pos.z - EPSILON)));
    return normalize(normal);
}

#endif //SDF_FUNCTIONS