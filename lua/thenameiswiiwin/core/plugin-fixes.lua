-- lua/core/plugin-fixes.lua

local M = {}

-- Initialize plugin fixes and workarounds
M.setup = function()
	-- Fix nvim-notify's use of deprecated vim.validate
	if vim.validate ~= nil then
		local original_validate = vim.validate
		vim.validate = function(...)
			local args = { ... }
			if #args == 3 then
				local name, value, validators = unpack(args)
				if type(validators) == "string" or type(validators) == "function" then
					-- Old style validation, pass through
					return original_validate(...)
				elseif type(validators) == "table" then
					-- New style might be used with old parameters
					for _, v in pairs(validators) do
						if type(v) == "string" or type(v) == "function" then
							-- This is old style, just pass through
							return original_validate(...)
						end
					end
					-- This is new style with table structure
					for param_name, vspec in pairs(validators) do
						if type(vspec) == "table" and #vspec >= 1 then
							local val_type, optional = vspec[1], vspec[2]
							if
								(value == nil and not optional)
								or (value ~= nil and type(value) ~= val_type and type(val_type) == "string")
								or (type(val_type) == "function" and not val_type(value))
							then
								local msg = vspec[3] or ("expected %s, got %s"):format(val_type, type(value))
								error(msg)
							end
						end
					end
					return
				end
			end
			return original_validate(...)
		end
	end
end

return M
