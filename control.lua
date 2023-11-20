-- Script settings
local interval_ticks, max_factor, min_factor

-- Values for current update
local max, chunks_per_tick, chunks_count
local surface_iter, surface_ind, surface, chunk_iter

-- Set total number of chunks for initial state
local function set_chunks_count()
  chunks_count = 0
  for _, surface in pairs(game.surfaces) do
    for chunk in surface.get_chunks() do
      chunks_count = chunks_count + 1
    end
  end
end

-- Set up all values to start iterating chunks
local function reset_values()
  chunks_per_tick = math.ceil(chunks_count / interval_ticks)
  max = 150 -- Init max to minimum value
  chunks_count = 0 -- Reset number of chunks to recount
  surface_iter, _, surface_ind = pairs(game.surfaces)
  surface_ind, surface = surface_iter(surface_ind)
  chunk_iter = surface.get_chunks()
end

-- Update map settings and reset values when done iterating chunks
local function finalize_update()
  -- Update map settings
  game.map_settings.pollution.expected_max_per_chunk = max * max_factor;
  game.map_settings.pollution.min_to_show_per_chunk = max * min_factor;

  -- Reset values for next pass
  reset_values()
end

-- Every tick, iterate a number of chunks to check for maximum pollution value
local function check_chunk_batch()
  if not chunk_iter.valid then
    set_chunks_count() -- Reset chunk count since we quit early
    reset_values() -- Set up for a new pass
    -- Skip finalize_update since data is incomplete
    return
  end
    
  for i=1,chunks_per_tick do
    local chunk = chunk_iter()
    if chunk then
      -- Run calculations for current chunk
      chunks_count = chunks_count + 1
      local poll = surface.get_pollution({chunk.x, chunk.y})
      if poll > max then
        max = poll
      end
    else
      -- Done with this surface, go to next surface
      surface_ind, surface = surface_iter(surface_ind)
      if surface then
        -- Continue with chunks in next surface
        chunk_iter = surface.get_chunks()
      else
        -- Done with all surfaces
        finalize_update()
        break
      end
    end
  end
end

-- Run on initial load and any time settings change
local function start_update()
  set_chunks_count()
  reset_values()

  script.on_event(defines.events.on_tick, function()
    check_chunk_batch()
  end)
end

-- Get mod settings and set up initial event to wait till game is loaded
local function setup_interval()
  -- Get settings
  -- Default interval is every 60 seconds
  local interval_secs = settings.global["pollution-scaling-interval-secs"].value
  -- Default of 100% to set maximum to maximum amount out of all chunks
  local max_percent = settings.global["pollution-scaling-max-percent"].value
  -- Default of 33% to mimic default of 50, 1/3 of max value
  local min_percent = settings.global["pollution-scaling-min-percent"].value

  -- Calculate internal values
  interval_ticks = interval_secs * 60;
  max_factor = max_percent / 100
  min_factor = min_percent / 100

  -- Wait for next tick to ensure game is loaded
  script.on_event(defines.events.on_tick, function()
    start_update()
  end)
end

-- Rerun setup whenever mod settings are changed
script.on_event(defines.events.on_runtime_mod_setting_changed, function()
  setup_interval()
end)

-- Setup interval on script load
setup_interval()
