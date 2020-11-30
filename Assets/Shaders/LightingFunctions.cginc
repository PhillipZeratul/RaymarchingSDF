#ifndef LIGHTING_FUNCTIONS
#define LIGHTING_FUNCTIONS

float PhongLighting(float3 pos, float3 center, float radius)
{
    return length(pos - center) - radius;
}

#endif //LIGHTING_FUNCTIONS