local fx = require("fx/lib/fx")
local mod = require 'core/mods'

local FxDelay = fx:new{
    subpath = "/fx_delay"
}

function FxDelay:add_params()
    params:add_separator("fx_delay", "fx delay")
    FxDelay:add_slot("fx_delay_slot", "slot")
    FxDelay:add_taper("fx_delay_time", "time", "time", 0, 1, 0.5, 2, "s")
    FxDelay:add_taper("fx_delay_feedback", "feedback", "feedback", 0, 1, 0.8, 1, "")
    FxDelay:add_taper("fx_delay_lp", "lp", "lp", 50, 20000, 2000, 2, "hz")
    FxDelay:add_taper("fx_delay_hp", "hp", "hp", 50, 20000, 400, 2, "hz")
    FxDelay:add_control("fx_delay_pingpong", "pingpong", "pingpong", controlspec.UNIPOLAR)
end

mod.hook.register("script_pre_init", "delay mod pre init", function()
    FxDelay:install()
end)

mod.hook.register("script_post_cleanup", "delay mod post cleanup", function()
end)

return FxDelay