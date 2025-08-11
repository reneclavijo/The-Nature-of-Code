components {
  id: "evade"
  component: "/lessons/lesson 5 - Autonomous Agents/go/pursue & evade/evade.script"
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
    x: 0.5
    y: 0.5
    z: 0.5
  }
}
