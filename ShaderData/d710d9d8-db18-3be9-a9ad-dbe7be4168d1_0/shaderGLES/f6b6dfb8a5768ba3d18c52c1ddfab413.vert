#version 300 es

uniform mat4 u_MVP;
uniform mat4 u_Model;

layout(location = 0) in vec3 attPosition;
out vec2 g_vary_uv0;
layout(location = 1) in vec2 attTexcoord0;
out vec3 v_posWS;

void main()
{
    vec4 homogeneous_pos = vec4(attPosition, 1.0);
    g_vary_uv0 = attTexcoord0;
    gl_Position = u_MVP * homogeneous_pos;
    v_posWS = (u_Model * vec4(attPosition, 1.0)).xyz;
}

