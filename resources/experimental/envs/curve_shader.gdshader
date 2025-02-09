shader_type spatial;

// Força da curvatura (ajuste conforme necessário)
uniform float curvature_strength = 0.15;

void vertex() {
    // Curva ao longo do eixo X (para curva em Y, troque VERTEX.x por VERTEX.y)
    float curve = curvature_strength * pow(VERTEX.x, 2.0);
    VERTEX.z += curve;
}
