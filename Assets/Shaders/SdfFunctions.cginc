#ifndef SDF_FUNCTIONS
#define SDF_FUNCTIONS

float SphereSDF(float3 pos, float3 center, float radius)
{
    return length(pos - center) - radius;
}

float SceneSDF(float3 pos)
{
    float sphereSDF = SphereSDF(pos, float3(0, 0, 0), 1.0);
    return sphereSDF;
}


#endif //SDF_FUNCTIONS