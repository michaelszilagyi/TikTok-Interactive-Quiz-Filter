#version 300 es
precision highp float;
precision highp int;

uniform mediump sampler2D u_FBOTexture;

layout(location = 0) out vec4 o_FragColor;
in vec2 textureCoordinate;

void main()
{
    o_FragColor = texture(u_FBOTexture, textureCoordinate);
}

