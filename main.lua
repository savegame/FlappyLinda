-- Levels
levels = {}
level = 0

-- Load error screen
require "engine/errorscr"

global = {}
if love.system.getOS() == "Android" or love.system.getOS() == "Ios" or love.system.getOS() == "SailfishOS" then
	love.window.setFullscreen(true)
	global.device = "phone"
elseif love.system.getOS() == "OS X" or love.system.getOS() == "Windows" or love.system.getOS() == "Linux" then
	imageData = love.image.newImageData( "icon.png" )
	 --icon = love.graphics.newImage("icon.png")
	 success = love.window.setIcon(imageData)
	love.window.setMode(480, 720, {resizable=true, fullscreen=false})
	global.device = "pc"
end
ratio = math.ceil(love.graphics.getWidth() / love.graphics.getHeight())

-- load engine
require "engine/engine"
require "engine/collision"
require "engine/sheet"
require "engine/class"
require "engine/easing"

-- load libs
lume = require "libs/lume"
audio = require "libs/wave"
--require "libs/simpleScale"

-- load res
--require "resource"

-- Load lvl
require "assets/lvl/lvl0"
require "assets/lvl/lvl1"

global.debug = true
global.width = 320

-- exec lvl
levels[level]()

