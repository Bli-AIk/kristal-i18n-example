-- Static test bullet spawned at the centers of room1 and room3 battle areas.
local bullet, super = Class(WorldBullet, "test_static")

function bullet:init(x, y)
    super.init(self, x, y, "bullets/smallbullet")
    self.damage = 1
    self.inv_frames = 60
    self.destroy_on_hit = false
end

return bullet
