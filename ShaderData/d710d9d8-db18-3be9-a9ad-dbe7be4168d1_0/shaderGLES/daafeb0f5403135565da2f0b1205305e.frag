#version 300 es
precision highp float;
precision highp int;

uniform mediump sampler2D _AlbedoTexture;
uniform vec4 _AlbedoColor;
uniform mat4 u_VP;
uniform mediump sampler2D u_FBOTexture;

in vec2 g_vary_uv0;
in vec3 v_posWS;
layout(location = 0) out vec4 o_fragColor;

vec4 ApplyBlendMode(vec4 color, vec2 uv)
{
    vec4 ret = color;
    return ret;
}

void main()
{
    vec2 uv = g_vary_uv0;
    uv.y = 1.0 - uv.y;
    vec4 t_albedo = vec4(1.0);
    t_albedo = texture(_AlbedoTexture, uv);
    vec3 _49 = t_albedo.xyz / vec3(t_albedo.w);
    t_albedo = vec4(_49.x, _49.y, _49.z, t_albedo.w);
    vec4 final_color = t_albedo * _AlbedoColor;
    vec4 proj_pos = u_VP * vec4(v_posWS, 1.0);
    vec2 ndc_coord = proj_pos.xy / vec2(proj_pos.w);
    vec2 screen_coord = (ndc_coord * 0.5) + vec2(0.5);
    vec4 param = final_color;
    vec2 param_1 = screen_coord;
    o_fragColor = ApplyBlendMode(param, param_1);
}

