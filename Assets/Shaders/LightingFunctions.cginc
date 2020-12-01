#ifndef LIGHTING_FUNCTIONS
#define LIGHTING_FUNCTIONS

float3 PhongLighting(float3 diffuse, float3 specular, float shininess, float3 pos, float3 normal,
                     float3 cameraPos, float3 lightPos, float3 lightColor)
{
    float3 N = normal;
    float3 L = normalize(lightPos - pos);
    float3 V = normalize(cameraPos - pos);
    float3 R = normalize(reflect(-L, N));

    float dotLN = saturate(dot(L, N));
    float dotRV = dot(R, V);

    if (dotLN < 0.0)
    {
        // Light not visible from this point on the surface
        return float3(0.0, 0.0, 0.0);
    }

    if (dotRV < 0.0)
    {
        // Light reflection in opposite direction as viewer, apply only diffuse component
        return lightColor * (diffuse * dotLN);
    }
    return lightColor * (diffuse * dotLN + specular * pow(dotRV, shininess));
}

#endif //LIGHTING_FUNCTIONS