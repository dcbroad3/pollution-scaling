data:extend(
  {
    {
      type = "int-setting",
      name = "pollution-scaling-interval-secs",
      order = "a",
      setting_type = "runtime-global",
      default_value = 10,
      minimum_value = 1,
    },
    {
      type = "int-setting",
      name = "pollution-scaling-max-percent",
      order = "b",
      setting_type = "runtime-global",
      default_value = 100,
      minimum_value = 0,
      maximum_value = 100,
    },
    {
      type = "int-setting",
      name = "pollution-scaling-min-percent",
      order = "c",
      setting_type = "runtime-global",
      default_value = 33,
      minimum_value = 0,
      maximum_value = 100,
    }
  }
)
