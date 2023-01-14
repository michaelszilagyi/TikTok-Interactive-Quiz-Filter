#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct main0_out
{
    float4 o_FragColor [[color(0)]];
};

struct main0_in
{
    float2 textureCoordinate;
};

fragment main0_out main0(main0_in in [[stage_in]], texture2d<float> u_FBOTexture [[texture(0)]], sampler u_FBOTextureSmplr [[sampler(0)]])
{
    main0_out out = {};
    out.o_FragColor = u_FBOTexture.sample(u_FBOTextureSmplr, in.textureCoordinate);
    return out;
}

