-- Check all chunks to find maximum amount of pollution and update map settings
local function update_expected_max_per_chunk(max_factor, min_factor)
  -- Start with vanilla default value of 150 for maximum
  -- https://lua-api.factorio.com/latest/Concepts.html#PollutionMapSettings
  local max = 150

  for _, surface in pairs(game.surfaces) do
    for chunk in surface.get_chunks() do
      local poll = surface.get_pollution({ chunk.x, chunk.y })
      if poll > max then
        max = poll
      end
    end
  end

  game.map_settings.pollution.expected_max_per_chunk = max * max_factor;
  game.map_settings.pollution.min_to_show_per_chunk = max * min_factor;
end

-- Get mod settings and setup interval handler
local function setup_interval()
  -- Get settings
  -- Default interval is every 10 seconds
  local interval_secs = settings.global["pollution-scaling-interval-secs"].value
  -- Default of 100% to set maximum to maximum amount out of all chunks
  local max_percent = settings.global["pollution-scaling-max-percent"].value
  -- Default of 33% to mimic default of 50, 1/3 of max value
  local min_percent = settings.global["pollution-scaling-min-percent"].value

  -- Calculate internal values
  local interval_ticks = interval_secs * 60;
  local max_factor = max_percent / 100
  local min_factor = min_percent / 100

  -- Update once before setting up interval
  update_expected_max_per_chunk(max_factor, min_factor)

  -- Setup (or override existing) on_nth_tick handler
  script.on_nth_tick(interval_ticks, function()
    update_expected_max_per_chunk(max_factor, min_factor)
  end)
end

-- Setup interval whenever mod settings are changed
script.on_event(defines.events.on_runtime_mod_setting_changed, function()
  setup_interval()
end)

-- Setup interval on script load
setup_interval()
