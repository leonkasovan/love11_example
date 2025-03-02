function love.load()
	-- Get the table of supported features
    print("Supported features:")
    local supported = love.graphics.getSupported()
    for feature, isSupported in pairs(supported) do
        print(feature, isSupported)
    end

    -- Get the table of supported canvas formats
    print("\nSupported canvas formats:")
    local formats = love.graphics.getCanvasFormats()
    for format, supported in pairs(formats) do
        print(format, supported)
    end

    -- Get the table of supported image formats
    print("\nSupported image formats:")
    local imageFormats = love.graphics.getImageFormats()
    for format, supported in pairs(imageFormats) do
        print(format, supported)
    end

    -- Get the table of supported renderers
    local rendererInfo = {}
    rendererInfo.name, rendererInfo.version, rendererInfo.vendor, rendererInfo.device = love.graphics.getRendererInfo()
    print("\nRenderer:", rendererInfo.name)
    print("Vendor:", rendererInfo.vendor)
    print("Version:", rendererInfo.version)
    print("Device:", rendererInfo.device)

    -- Get the table of supported texture types
    print("\nSupported texture types:")
    local textureTypes = love.graphics.getTextureTypes()
    for textureType, supported in pairs(textureTypes) do
        print(textureType, supported)
    end

    -- Get the table of system limits
    print("\nSystem limits:")
    local limits = love.graphics.getSystemLimits()
    for limit, value in pairs(limits) do
        print(limit, value)
    end

    -- Get the dimensions of the window
    local width, height = love.graphics.getDimensions()
    print("\nWindow dimensions:")
    print("Width:", width)
    print("Height:", height)

    -- Get the list of supported fullscreen modes
    print("\nSupported fullscreen modes:")
    local modes = love.window.getFullscreenModes()
    table.sort(modes, function(a, b) return a.width * a.height > b.width * b.height end)
    for i, mode in ipairs(modes) do
        print(string.format("%d: %dx%d", i, mode.width, mode.height))
    end
end
