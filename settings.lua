data:extend(
  {
    {
      type = "int-setting",
      name = "pollution-scaling-interval-secs",
      order = "a",
      setting_type = "runtime-global",
      default_value = 60,
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
    },
    {
      type = "color-setting",
      name = "pollution-scaling-chart-color",
      order = "d",
      setting_type = "startup",
      default_value = {r=140,g=0,b=0,a=149}
    }
  }
)
