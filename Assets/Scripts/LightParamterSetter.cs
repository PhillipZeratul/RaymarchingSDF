using UnityEngine;

[RequireComponent(typeof(Light))]
public class LightParamterSetter : MonoBehaviour
{
    private Light theLight;

    private int lightPosId = Shader.PropertyToID("_LightPos");
    private int lightColorId = Shader.PropertyToID("_LightColor");

    private void Start()
    {
        theLight = GetComponent<Light>();
    }

    private void Update()
    {
        Color color = theLight.color;
        Vector3 lightColor = new Vector3(color.r, color.g, color.b) * theLight.intensity;
        Shader.SetGlobalVector(lightPosId, transform.position);
        Shader.SetGlobalVector(lightColorId, lightColor);
    }
}