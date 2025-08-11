components {
  id: "cohere"
  component: "/lessons/lesson 5 - Autonomous Agents/go/cohere/cohere.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"playerShip2_orange\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/graphics/atlas/assets.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 0.3
    y: 0.3
    z: 0.3
  }
}
