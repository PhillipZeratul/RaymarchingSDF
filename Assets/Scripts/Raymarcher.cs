using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class Raymarcher : MonoBehaviour
{
    public Shader shader;

    private Camera mainCamera;
    private Material material;

    private Vector3[] frustumCorners = new Vector3[4];
    private Vector4[] screenTriangleCorners = new Vector4[3];

    private int screenTriangleCornersId = Shader.PropertyToID("_ScreenTriangleCorners");

    private void Start()
    {
        mainCamera = GetComponent<Camera>();
        material = new Material(shader);
    }

    private void OnDestroy()
    {
        Destroy(material);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        mainCamera.CalculateFrustumCorners(new Rect(0, 0, 1, 1), mainCamera.farClipPlane, mainCamera.stereoActiveEye, frustumCorners);

        screenTriangleCorners[0] = new Vector4(frustumCorners[1].x, frustumCorners[1].y, mainCamera.farClipPlane, 0);
        screenTriangleCorners[1] = new Vector4(frustumCorners[0].x, -3.0f * frustumCorners[1].y, mainCamera.farClipPlane, 0);
        screenTriangleCorners[2] = new Vector4(3.0f * frustumCorners[2].x, frustumCorners[1].y, mainCamera.farClipPlane, 0);

        screenTriangleCorners[0] = mainCamera.transform.TransformVector(screenTriangleCorners[0]) / mainCamera.farClipPlane;
        screenTriangleCorners[1] = mainCamera.transform.TransformVector(screenTriangleCorners[1]) / mainCamera.farClipPlane;
        screenTriangleCorners[2] = mainCamera.transform.TransformVector(screenTriangleCorners[2]) / mainCamera.farClipPlane;

        material.SetVectorArray(screenTriangleCornersId, screenTriangleCorners);

        Graphics.Blit(source, destination, material);
    }
}
