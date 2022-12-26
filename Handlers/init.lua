local handlers = {}

local function scanFolder(folder)
	local result = {}
	for _, subject in pairs(folder:GetChildren()) do
		if subject:IsA("ModuleScript") then
			result[subject.Name] = require(subject)
		elseif subject:IsA("Folder") then
			result[subject.Name] = scanFolder(subject)
		end
	end
	return result
end

handlers = scanFolder(script)

return handlers