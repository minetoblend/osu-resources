#ifndef TEXTURE_FS
#define TEXTURE_FS

#include "sh_Utils.h"
#include "sh_Masking.h"

layout (std140, set = 0, binding = 0) uniform m_CardEffectParameters
{
    highp vec4 g_NormalVector;
    highp mat4 g_CombinedMatrix;
    highp mat4 g_ModelViewMatrix;
    highp vec2 g_Centre;
    highp float g_Distance;
};

layout (set = 1, binding = 0) uniform lowp texture2D m_Texture;
layout (set = 1, binding = 1) uniform lowp sampler m_Sampler;

layout (location = 2) in highp vec3 v_TexCoord;
layout (location = 5) in highp vec3 v_WorldPosition;

layout (location = 0) out vec4 o_Colour;


void main(void)
{
    vec3 cameraPos = vec3(0.0, 0.0, g_Distance);
    vec3 lightPos = vec3(-g_Distance * 2.0, -g_Distance, g_Distance * 1.5);

    vec3 normal = normalize(g_NormalVector.xyz);

    vec3 surfaceToLightDirection = normalize(lightPos - v_WorldPosition);
    vec3 surfaceToViewDirection = normalize(cameraPos - v_WorldPosition);
    vec3 halfVector = normalize(surfaceToLightDirection + surfaceToViewDirection);
    float light = dot(normal, surfaceToLightDirection);
    float specular = 0.0;

    if (light > 0.0) {
        specular = pow(max(0.0, dot(normal, halfVector)), 50.0);
    }


    vec2 texCoord = v_TexCoord.xy / v_TexCoord.z;
    vec4 colour = getRoundedColor(texture(sampler2D(m_Texture, m_Sampler), texCoord), texCoord);

    float mask = pow((colour.r + colour.g + colour.b) / 3.0, 2.0);
    
    if (colour.a < 1)
        mask = 0;

    colour.rgb += vec3(specular * mask);

    o_Colour = colour;
}

#endif