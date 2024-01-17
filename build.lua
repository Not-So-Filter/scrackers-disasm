#!/usr/bin/env lua

local common = require "build_tools.lua.common"

local message, abort = common.build_rom("sonic", "scbuilt", "", "-p=FF -z=0," .. "uncompressed" .. ",Size_of_DAC_driver_guess,after", false, "https://github.com/sonicretro/skdisasm")

if message then
	exit_code = false
end

if abort then
	os.exit(exit_code, true)
end

os.exit(exit_code, false)
