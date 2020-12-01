#ifndef SDF_FUNCTIONS
#define SDF_FUNCTIONS

#define EPSILON 0.0001

float SphereSDF(float3 pos, float3 center, float radius)
{
    return length(pos - center) - radius;
}

float SceneSDF(float3 pos)
{
    float sphereSDF = SphereSDF(pos, float3(0, 0, 0), 1.0);
    return sphereSDF;
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