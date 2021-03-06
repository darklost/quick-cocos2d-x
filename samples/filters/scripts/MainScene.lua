--- The Filters Sample
-- @author zrong(zengrong.net)
-- Creation 2014-04-09

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

MainScene._FILTERS = {
	-- colors
	{"GRAY",{0.2, 0.3, 0.5, 0.1}},
	{"RGB",{1, 0.5, 0.3}},
	{"HUE", {90}},
	{"BRIGHTNESS", {0.3}},
	{"SATURATION", {0}},
	{"CONTRAST", {2}},
	{"EXPOSURE", {2}},
	{"GAMMA", {2}},
	{"HAZE", {0.1, 0.2}},
	--{"SEPIA", {}},
	-- blurs
	{"GAUSSIAN_VBLUR", {7}},
	{"GAUSSIAN_HBLUR", {7}},
	{"ZOOM_BLUR", {4, 0.7, 0.7}},
	{"MOTION_BLUR", {5, 135}},
	-- others
	{"SHARPEN", {1, 1}},
	{{"GRAY", "GAUSSIAN_VBLUR", "GAUSSIAN_HBLUR"}, {nil, {10}, {10}}},
	{{"BRIGHTNESS", "CONTRAST"}, {{0.1}, {4}}},
	{{"HUE", "SATURATION", "BRIGHTNESS"}, {{240}, {1.5}, {-0.4}}},
}

function MainScene:ctor()
	self:_addUI()
	self:_createFilters()
	self:_showFilter()
end

function MainScene:_addUI()
	cc.ui.UIPushButton.new("close.png")
		:align(display.RIGHT_BOTTOM, display.width, display.bottom)
		:addTo(self, 0)
		:onButtonClicked(handler(self, self._onClose))
	
	self._prevBtn = cc.ui.UIPushButton.new({normal="b1.png",pressed="b2.png"})
		:align(display.BOTTOM_CENTER, display.cx-100, display.bottom)
		:addTo(self, 0)
		:onButtonClicked(handler(self, self._onPrev))
	self._resetBtn = cc.ui.UIPushButton.new({normal="r1.png",pressed="r2.png"})
		:align(display.BOTTOM_CENTER, display.cx, display.bottom)
		:addTo(self, 0)
		:onButtonClicked(handler(self, self._onReset))
	self._nextBtn = cc.ui.UIPushButton.new({normal="f1.png",pressed="f2.png"})
		:align(display.BOTTOM_CENTER, display.cx+100, display.bottom)
		:addTo(self, 0)
		:onButtonClicked(handler(self, self._onNext))

	self._title = ui.newTTFLabel({
		text="Filters test",
	})
		:align(display.CENTER, display.cx, display.top-80)
		:addTo(self, 10)
end

function MainScene:_createFilters()
	self._curFilter = 1
	self._filterCount = #self._FILTERS
end

function MainScene:_showFilter()
	if self._filterSprite then
		self._filterSprite:removeSelf()
		self._filterSprite = nil
	end
	local __curFilter = MainScene._FILTERS[self._curFilter]
	-- self._filterSprite = display.newFilteredSprite("helloworld.png", unpack(__curFilter))
	local __filters, __params = unpack(__curFilter)
	if __params and #__params == 0 then
		__params = nil
	end
	self._filterSprite = display.newFSprite("helloworld.png", __filters, __params)
		:align(display.CENTER, display.cx, display.cy)
		:addTo(self, 10)
        local __title = ""
        if type(__filters) == "table" then
			for i in ipairs(__filters) do
				__title = __title..__filters[i]
				local __param = __params[i]
				if __param then
					__title = __title.." (" .. table.concat(__param, ",")..")\n"
				else
					__title = __title.." (nil)\n"
				end
			end
        else
            __title = __filters
			if __params and type(__params) == "table" then
				__title = __title.. " (" .. table.concat(__params, ",")..")"
			end
        end
        self._title:setString(__title)
end

function MainScene:_onPrev()
	self._curFilter = self._curFilter - 1
	if self._curFilter <= 0 then
		self._curFilter = self._filterCount
	end
	self:_showFilter()
end

function MainScene:_onReset()
end

function MainScene:_onNext()
	self._curFilter = self._curFilter + 1
	if self._curFilter > self._filterCount then
		self._curFilter = 1
	end
	self:_showFilter()
end

function MainScene:_onClose()
	game.exit()
end

return MainScene
