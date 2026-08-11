--- A demo of a "legend" cutscene: a full-screen storybook sequence with slides,
--- plain text and music, independent from the world/battle cutscene systems.
---
--- Files in `scripts/legends/` are registered automatically and can be played
--- from the debug menu: Debug -> Play Legend -> example.

---@param cutscene LegendCutscene
return function(cutscene)
    -- The default "cover" hides the slide area, so reveal it first.
    cutscene:hideCover()

    -- Start the music ourselves so the demo also works from Debug -> Play Legend,
    -- which starts legends without extra options.
    Game.legend.music:play("lantern")

    -- The PNG frames in assets/sprites/legends/ralsei_*.png are auto-detected
    -- as a single animation by Kristal ("legends/ralsei").
    local slide = cutscene:slide("legends/ralsei")
    slide:setScale(8)
    slide.x = (SCREEN_WIDTH - slide.width * slide.scale_x) / 2
    slide.y = 40
    -- The source GIF only has four unique frames; repeat each one four times
    -- to keep the original animation timing.
    slide:setAnimation({ "legends/ralsei", 0.03, true, frames = { "1*4", "2*4", "3*4", "4*4" } })

    cutscene:setSpeed(1)
    cutscene:text("{legend_example_demo}", "middle_bottom")
    cutscene:wait(3)
    cutscene:removeText()

    cutscene:text("{legend_example_ralsei}", "middle_bottom")
    cutscene:musicWait(6)
    cutscene:wait(2)
    cutscene:removeText()

    -- Fade the picture out and cover the stage before the cutscene ends.
    cutscene:removeSlides()
    cutscene:wait(1)
    cutscene:showCover()
end
