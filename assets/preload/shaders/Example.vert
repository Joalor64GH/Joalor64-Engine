uniform mat4 viewProjMat; /* 4x4 matrix for view + projection transforms */
uniform mat4 worldMat; /* 4x4 matrix for world transform */

attribute vec3 position;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec3 v_normal;
varying vec2 v_texCoord;

void
main()
{
    gl_Position = viewProjMat * worldMat * vec4(position, 1.0);
    v_normal = mat3(worldMat) * normal;
    v_texCoord = texCoord;
}