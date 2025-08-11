components {
  id: "particle"
  component: "/prototipos/Lesson 4 - Particles/particula.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"ufoBlue\"\n"
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
