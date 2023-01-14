#version 300 es

uniform mat4 u_Palatte[50];
uniform mat4 u_MVP;
uniform mat4 u_Model;

layout(location = 0) in vec3 attPosition;
out vec2 g_vary_uv0;
layout(location = 1) in vec2 attTexcoord0;
layout(location = 2) in vec4 attBoneIds;
layout(location = 3) in vec4 attWeights;
out vec3 v_posWS;

void main()
{
    vec4 homogeneous_pos = vec4(attPosition, 1.0);
    g_vary_uv0 = attTexcoord0;
    mat4 boneTransform = u_Palatte[int(attBoneIds.x)] * attWeights.x;
    mat4 _56 = u_Palatte[int(attBoneIds.y)] * attWeights.y;
    boneTransform = mat4(boneTransform[0] + _56[0], boneTransform[1] + _56[1], boneTransform[2] + _56[2], boneTransform[3] + _56[3]);
    mat4 _79 = u_Palatte[int(attBoneIds.z)] * attWeights.z;
    boneTransform = mat4(boneTransform[0] + _79[0], boneTransform[1] + _79[1], boneTransform[2] + _79[2], boneTransform[3] + _79[3]);
    mat4 _102 = u_Palatte[int(attBoneIds.w)] * attWeights.w;
    boneTransform = mat4(boneTransform[0] + _102[0], boneTransform[1] + _102[1], boneTransform[2] + _102[2], boneTransform[3] + _102[3]);
    gl_Position = (u_MVP * boneTransform) * vec4(attPosition, 1.0);
    v_posWS = ((u_Model * boneTransform) * vec4(attPosition, 1.0)).xyz;
}

