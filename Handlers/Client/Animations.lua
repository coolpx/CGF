return function()
	local rs = game:GetService("ReplicatedStorage")
	local ts = game:GetService("TweenService")
	local cgf = require(rs.CGF)

	local config = cgf.Config.Animation
	
	local mouseDataTypes
	
	local normalSize
	local normalPos
	
	local button
	local adornee
	
	local playingAnimations = {}
	
	local enabled = true
	
	local ti = TweenInfo.new(config.LENGTH)
	
	local function tweenSizePosition(dataTypeName: string)
		if not enabled then return end

		local data = mouseDataTypes[dataTypeName]
		local animations = {ts:Create(adornee, ti, {Size = data[1], Position = data[2]}), ts:Create(adornee.UICorner, ti, {CornerRadius = UDim.new(0, data[3])})}
		playingAnimations = animations
		for _, anim: Tween in pairs(animations) do
			anim:Play()
		end
		wait(config.LENGTH)
		if playingAnimations == animations then
			playingAnimations = {}
		end
	end
	
	return {
		Handler = function(newButton: GuiButton, newAdornee, customConfig: {SIZE_CHANGE: number, ROUNDING_CHANGE: number, LENGTH: number}?)
			local localConfig
			if customConfig then
				localConfig = customConfig
			else
				localConfig = config
			end
			button = newButton
			adornee = newAdornee

			local plr = game.Players.LocalPlayer

			local rounding = adornee.UICorner.CornerRadius.Offset

			normalSize = adornee.Size
			normalPos = adornee.Position
			
			local posMultipliers = Vector2.new(1 - adornee.AnchorPoint.X * 2, 1 - adornee.AnchorPoint.Y * 2)

			mouseDataTypes = {
				normal = {
					normalSize, -- size
					normalPos, -- position
					rounding -- rounding
				},
				mouseOver = {
					normalSize + UDim2.new(0, localConfig.SIZE_CHANGE, 0, localConfig.SIZE_CHANGE),
					normalPos - UDim2.new(0, localConfig.SIZE_CHANGE/2*posMultipliers.X, 0, localConfig.SIZE_CHANGE/2*posMultipliers.Y),
					rounding+localConfig.ROUNDING_CHANGE
				},
				mouseDown = {
					normalSize - UDim2.new(0, localConfig.SIZE_CHANGE, 0, localConfig.SIZE_CHANGE),
					normalPos + UDim2.new(0, localConfig.SIZE_CHANGE/2*posMultipliers.X, 0, localConfig.SIZE_CHANGE/2*posMultipliers.Y),
					rounding-localConfig.ROUNDING_CHANGE
				}
			}

			button.MouseEnter:Connect(function()
				tweenSizePosition("mouseOver")
			end)
			button.MouseLeave:Connect(function()
				tweenSizePosition("normal")
			end)
			button.MouseButton1Down:Connect(function()
				tweenSizePosition("mouseDown")
			end)
			button.MouseButton1Up:Connect(function()
				tweenSizePosition("normal")
			end)
		end,
		SetNormalSize = function(size: UDim2)
			normalSize = size
			
			local rounding = adornee.UICorner.CornerRadius.Offset
			local posMultipliers = Vector2.new(1 - adornee.AnchorPoint.X * 2, 1 - adornee.AnchorPoint.Y * 2)
			
			mouseDataTypes = {
				normal = {
					normalSize, -- size
					normalPos, -- position
					rounding -- rounding
				},
				mouseOver = {
					normalSize + UDim2.new(0, config.SIZE_CHANGE, 0, config.SIZE_CHANGE),
					normalPos - UDim2.new(0, config.SIZE_CHANGE/2*posMultipliers.X, 0, config.SIZE_CHANGE/2*posMultipliers.Y),
					rounding+config.ROUNDING_CHANGE
				},
				mouseDown = {
					normalSize - UDim2.new(0, config.SIZE_CHANGE, 0, config.SIZE_CHANGE),
					normalPos + UDim2.new(0, config.SIZE_CHANGE/2*posMultipliers.X, 0, config.SIZE_CHANGE/2*posMultipliers.Y),
					rounding-config.ROUNDING_CHANGE
				}
			}
		end,
		SetNormalPos = function(pos: UDim2)
			normalSize = pos
			
			local rounding = adornee.UICorner.CornerRadius.Offset
			local posMultipliers = Vector2.new(1 - adornee.AnchorPoint.X * 2, 1 - adornee.AnchorPoint.Y * 2)
			
			mouseDataTypes = {
				normal = {
					normalSize, -- size
					normalPos, -- position
					rounding -- rounding
				},
				mouseOver = {
					normalSize + UDim2.new(0, config.SIZE_CHANGE, 0, config.SIZE_CHANGE),
					normalPos - UDim2.new(0, config.SIZE_CHANGE/2*posMultipliers.X, 0, config.SIZE_CHANGE/2*posMultipliers.Y),
					rounding+config.ROUNDING_CHANGE
				},
				mouseDown = {
					normalSize - UDim2.new(0, config.SIZE_CHANGE, 0, config.SIZE_CHANGE),
					normalPos + UDim2.new(0, config.SIZE_CHANGE/2*posMultipliers.X, 0, config.SIZE_CHANGE/2*posMultipliers.Y),
					rounding-config.ROUNDING_CHANGE
				}
			}
		end,
		CancelAnimations = function()
			for _, anim: Tween in pairs(playingAnimations) do
				anim:Cancel()
			end
		end,
		SetEnabled = function(shouldEnable: boolean)
			enabled = shouldEnable
		end
	}
end