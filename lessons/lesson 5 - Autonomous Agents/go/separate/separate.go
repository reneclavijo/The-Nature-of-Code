components {
  id: "separate"
  component: "/prototipos/Lesson 5 - Autonomous Agents/separate/separate.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"playerShip2_blue\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
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
