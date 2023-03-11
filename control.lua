local freq_ticks = 60 * 10

local function update_expected_max_per_chunk()
  -- Start with vanilla default value of 150
  -- https://lua-api.factorio.com/latest/Concepts.html#PollutionMapSettings
  local max = 150
  for a, b in pairs(game.surfaces) do
    for chunk in b.get_chunks() do
      local poll = b.get_pollution({chunk.x, chunk.y})
      if poll > max then
        max = poll
      end
    end
  end

  game.map_settings.pollution.expected_max_per_chunk = max;
  -- Mimic vanilla default of 50, which is 1/3 of the expected max per chunk
  game.map_settings.pollution.min_to_show_per_chunk = max / 3;
end

script.on_event(defines.events.on_tick,
  function(e)
    -- Run every ten seconds
    if e.tick % freq_ticks == 0 then
      update_expected_max_per_chunk()
    end
  end
)