#pragma clang diagnostic ignored "-Wmissing-prototypes"
#pragma clang diagnostic ignored "-Wmissing-braces"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

template<typename T, size_t Num>
struct spvUnsafeArray
{
    T elements[Num ? Num : 1];
    
    thread T& operator [] (size_t pos) thread
    {
        return elements[pos];
    }
    constexpr const thread T& operator [] (size_t pos) const thread
    {
        return elements[pos];
    }
    
    device T& operator [] (size_t pos) device
    {
        return elements[pos];
    }
    constexpr const device T& operator [] (size_t pos) const device
    {
        return elements[pos];
    }
    
    constexpr const constant T& operator [] (size_t pos) const constant
    {
        return elements[pos];
    }
    
    threadgroup T& operator [] (size_t pos) threadgroup
    {
        return elements[pos];
    }
    constexpr const threadgroup T& operator [] (size_t pos) const threadgroup
    {
        return elements[pos];
    }
};

struct buffer_t
{
    spvUnsafeArray<float4x4, 50> u_Palatte;
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
    float4 attBoneIds [[attribute(2)]];
    float4 attWeights [[attribute(3)]];
};

vertex main0_out main0(main0_in in [[stage_in]], constant buffer_t& buffer)
{
    main0_out out = {};
    float4 homogeneous_pos = float4(in.attPosition, 1.0);
    out.g_vary_uv0 = in.attTexcoord0;
    float4x4 boneTransform = buffer.u_Palatte[int(in.attBoneIds.x)] * in.attWeights.x;
    float4x4 _56 = buffer.u_Palatte[int(in.attBoneIds.y)] * in.attWeights.y;
    boneTransform = float4x4(boneTransform[0] + _56[0], boneTransform[1] + _56[1], boneTransform[2] + _56[2], boneTransform[3] + _56[3]);
    float4x4 _79 = buffer.u_Palatte[int(in.attBoneIds.z)] * in.attWeights.z;
    boneTransform = float4x4(boneTransform[0] + _79[0], boneTransform[1] + _79[1], boneTransform[2] + _79[2], boneTransform[3] + _79[3]);
    float4x4 _102 = buffer.u_Palatte[int(in.attBoneIds.w)] * in.attWeights.w;
    boneTransform = float4x4(boneTransform[0] + _102[0], boneTransform[1] + _102[1], boneTransform[2] + _102[2], boneTransform[3] + _102[3]);
    out.gl_Position = (buffer.u_MVP * boneTransform) * float4(in.attPosition, 1.0);
    out.v_posWS = ((buffer.u_Model * boneTransform) * float4(in.attPosition, 1.0)).xyz;
    out.gl_Position.z = (out.gl_Position.z + out.gl_Position.w) * 0.5;       // Adjust clip-space for Metal
    return out;
}

