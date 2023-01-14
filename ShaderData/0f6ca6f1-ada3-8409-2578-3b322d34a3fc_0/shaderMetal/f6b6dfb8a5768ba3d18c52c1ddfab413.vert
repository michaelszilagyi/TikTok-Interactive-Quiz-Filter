#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct buffer_t
{
    float4x4 u_MVP;
    float4x4 u_Model;
};

struct main0_out
{
    float2 g_vary_uv0;
    float3 v_posWS;
    float4 gl_Position [[position]];
};

struct main0_in
{
    float3 attPosition [[attribute(0)]];
    float2 attTexcoord0 [[attribute(1)]];
};

vertex main0_out main0(main0_in in [[stage_in]], constant buffer_t& buffer)
{
    main0_out out = {};
    float4 homogeneous_pos = float4(in.attPosition, 1.0);
    out.g_vary_uv0 = in.attTexcoord0;
    out.gl_Position = buffer.u_MVP * homogeneous_pos;
    out.v_posWS = (buffer.u_Model * float4(in.attPosition, 1.0)).xyz;
    out.gl_Position.z = (out.gl_Position.z + out.gl_Position.w) * 0.5;       // Adjust clip-space for Metal
    return out;
}

