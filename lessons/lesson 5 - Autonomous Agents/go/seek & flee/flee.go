components {
  id: "flee"
  component: "/prototipos/Lesson 5 - Autonomous Agents/seek & flee/flee.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"playerShip2_red\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/graphics/atlas/assets.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 0.5
    y: 0.5
    z: 0.5
  }
}
