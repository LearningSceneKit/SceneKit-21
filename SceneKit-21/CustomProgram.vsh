precision mediump float;
attribute vec4 a_srcPos;   // 几何的原来位置
attribute vec2 a_texcoord; // 几何的纹理坐标
uniform mat4 u_mv;    // ModelView 变换矩阵
uniform mat4 u_proj;  // Projection 变换矩阵
uniform float factor; // 渐变因子
varying vec2 v_uv;     // 两个着色器共享纹理坐标

void main()
{
 
    vec4 vsPos = u_mv * a_srcPos;
    vec2 nrm = vsPos.xz;
    float len = length(vsPos.xz) + 0.0001;
    nrm /= len;
    float a = len + 0.2 * sin(5.0 * vsPos.y + factor * 10.0);
    vsPos.xz = nrm * a;
    gl_Position = u_proj * vsPos  ;
    v_uv = a_texcoord ;
    
}
