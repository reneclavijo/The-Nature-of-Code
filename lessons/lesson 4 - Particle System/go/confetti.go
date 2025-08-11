components {
  id: "particle"
  component: "/lessons/lesson 4 - Particle System/go/particula.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"playerShip1_red\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ADD\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/graphics/atlas/assets.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 0.2
    y: 0.2
    z: 0.2
  }
}
