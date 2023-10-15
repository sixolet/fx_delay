local fx = require("fx/lib/fx")
local mod = require 'core/mods'
local hook = require 'core/hook'
local tab = require 'tabutil'
-- Begin post-init hack block
if hook.script_post_init == nil and mod.hook.patched == nil then
    mod.hook.patched = true
    local old_register = mod.hook.register
    local post_init_hooks = {}
    mod.hook.register = function(h, name, f)
        if h == "script_post_init" then
            post_init_hooks[name] = f
        else
            old_register(h, name, f)
        end
    end
    mod.hook.register('script_pre_init', '!replace init for fake post init', function()
        local old_init = init
        init = function()
            old_init()
            for i, k in ipairs(tab.sort(post_init_hooks)) do
                local cb = post_init_hooks[k]
                print('calling: ', k)
                local ok, error = pcall(cb)
                if not ok then
                    print('hook: ' .. k .. ' failed, error: ' .. error)
                end
            end
        end
    end)
end
-- end post-init hack block


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

mod.hook.register("script_post_init", "fx delay mod post init", function()
    FxDelay:add_params()
end)

mod.hook.register("script_post_cleanup", "delay mod post cleanup", function()
end)

return FxDelay