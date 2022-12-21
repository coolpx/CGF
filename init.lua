local module = {}

for _, submodule in pairs(script:GetChildren()) do
    module[submodule.Name] = require(submodule)
end