#version 330 core
precision mediump float;

uniform mat4 model, view;

uniform float scene_fog;
uniform vec3 scene_color;

uniform vec3 light_pos;
uniform vec3 light_ambient, light_diffuse, light_specular;

uniform vec3 ka, kd, ks;
uniform float ns, tr;

uniform vec4 blend_color;
uniform vec4 blend_factor;

in vec3 fPos;
in vec3 fN, fE, fL;
in vec4 fColor;

void main() {
    vec3 N = normalize(fN);
    vec3 E = normalize(fE);
    vec3 L = normalize(fL);
    vec3 H = normalize(L + E);
 
    vec3 ambient = light_ambient * ka;

    vec3 diffuse = light_diffuse * kd * max(dot(L, N), 0);

    vec3 specular = light_specular * ks * pow(max(dot(N, H), 0), 0.01f * ns);

    vec3 afterLight = scene_color + ambient + diffuse + specular;

    vec3 afterFog = mix(afterLight, scene_color,
                        clamp(-scene_fog * fPos.z, 0, 1));

    gl_FragColor = vec4(afterFog, tr);
}