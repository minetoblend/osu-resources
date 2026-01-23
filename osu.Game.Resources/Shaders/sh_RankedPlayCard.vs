#ifndef TEXTURE2D_VS
#define TEXTURE2D_VS

#include "sh_Utils.h"

layout(location = 0) in highp vec2 m_Position;
layout(location = 1) in lowp vec4 m_Colour;
layout(location = 2) in highp vec3 m_TexCoord;

layout (std140, set = 0, binding = 0) uniform m_CardEffectParameters
{
    highp vec4 g_NormalVector;
    highp mat4 g_CombinedMatrix;
    highp mat4 g_ModelViewMatrix;
    highp vec2 g_Centre;
    highp float g_Distance;
    highp float g_IridescenceIntensity;
    highp float g_ParallaxStrength;
    highp float g_SpectralIntensity;
    highp float g_GlowIntensity;
    highp float g_FoilEnabled;
};

layout(location = 0) out highp vec2 v_MaskingPosition;
layout(location = 1) out lowp vec4 v_Colour;
layout(location = 2) out highp vec3 v_TexCoord;
layout(location = 3) out highp vec4 v_TexRect;
layout(location = 4) out highp vec2 v_BlendRange;
layout(location = 5) out highp vec3 v_WorldPosition;

void main(void)
{
    // Transform from screen space to masking space.
    highp vec3 maskingPos = g_ToMaskingSpace * vec3(m_Position, 1.0);
    v_MaskingPosition = maskingPos.xy / maskingPos.z;

    v_Colour = m_Colour;
    v_TexCoord = m_TexCoord;
    v_TexRect = vec4(0.0, 0.0, 1.0, 1.0);
    v_BlendRange = vec2(0.0);

    highp vec4 worldPos = g_ModelViewMatrix * vec4(m_Position, 0.0, 1.0);
    v_WorldPosition = worldPos.xyz / worldPos.w;

    highp vec4 v4 = g_CombinedMatrix * vec4(m_Position, 0.0, 1.0);
    gl_Position = g_ProjMatrix * vec4(g_Centre + (v4.xy / v4.w) * g_Distance, 1.0, 1.0);
}

#endif