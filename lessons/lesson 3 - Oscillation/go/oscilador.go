components {
  id: "oscilador"
  component: "/prototipos/Lesson 3 - Oscillation/oscilador.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"ufoRed\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/graphics/atlas/assets.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 0.5
    y: 0.5
  }
}
