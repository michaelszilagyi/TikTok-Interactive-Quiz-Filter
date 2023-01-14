#version 300 es

uniform vec2 u_scale;
uniform int u_ctrl_count;
uniform vec4 u_ctrl_vec[128];
uniform float u_ratio;
uniform vec2 u_scale_inv;

layout(location = 1) in vec2 attTexcoord0;
layout(location = 0) in vec3 attPosition;
out vec2 textureCoordinate;

vec2 calc_mls()
{
    vec2 fv = attTexcoord0 * u_scale;
    float sum_weights = 0.0;
    vec4 p_q_star = vec4(0.0);
    for (int i = 0; i < u_ctrl_count; i++)
    {
        vec4 p_q = u_ctrl_vec[i];
        vec2 q_v = p_q.zw - fv;
        q_v *= q_v;
        float w = 1.0 / ((((q_v.x + q_v.y) * 0.25) + (500.0 * u_ratio)) + 9.9999997473787516355514526367188e-06);
        sum_weights += w;
        p_q_star += (p_q * w);
    }
    p_q_star /= vec4(sum_weights);
    vec2 fv_hat = fv - p_q_star.zw;
    vec2 vr = vec2(0.0);
    float ms = 0.0;
    for (int i_1 = 0; i_1 < u_ctrl_count; i_1++)
    {
        vec4 p_q_1 = u_ctrl_vec[i_1];
        vec4 p_q_hat = p_q_1 - p_q_star;
        vec2 q_v_1 = p_q_1.zw - fv;
        q_v_1 *= q_v_1;
        float w_1 = 1.0 / ((((q_v_1.x + q_v_1.y) * 0.25) + (500.0 * u_ratio)) + 9.9999997473787516355514526367188e-06);
        vec2 q_hat_rev = vec2(p_q_hat.w, p_q_hat.z);
        vec2 p_hat_q_hat = p_q_hat.xy * p_q_hat.zw;
        vec2 p_hat_q_hat_rev = p_q_hat.xy * q_hat_rev;
        float pxqx_pyqy = p_hat_q_hat.x + p_hat_q_hat.y;
        float pxqy_pyqx = p_hat_q_hat_rev.x - p_hat_q_hat_rev.y;
        vec2 w_fv_hat = fv_hat * w_1;
        vec2 w_fv_hat_rev = vec2(w_fv_hat.y, w_fv_hat.x);
        vec2 pqxy = vec2(pxqy_pyqx, -pxqy_pyqx);
        w_fv_hat *= pxqx_pyqy;
        w_fv_hat_rev *= pqxy;
        vr += (w_fv_hat + w_fv_hat_rev);
        vec2 q_hat = p_q_hat.zw;
        q_hat *= q_hat;
        ms += (w_1 * (q_hat.x + q_hat.y));
    }
    vec2 v = (vr / vec2(ms)) + p_q_star.xy;
    return v;
}

void main()
{
    gl_Position = vec4(attPosition, 1.0);
    if (u_ctrl_count > 0)
    {
        vec2 v = calc_mls();
        v *= u_scale_inv;
        textureCoordinate = clamp(v, vec2(0.0), vec2(1.0));
    }
    else
    {
        textureCoordinate = clamp(attTexcoord0, vec2(0.0), vec2(1.0));
    }
}

