local _G = require "_G"
local ipairs = _G.ipairs
local select = _G.select

local array = require "table"
local insert = array.insert
local sort = array.sort

local math = require "math"
local floor = math.floor

local oo = require "loop.base"
local class = oo.class
local rawnew = oo.rawnew

local Date = require "Date"

local function div(number, divisor)
	return floor(number/divisor), number%divisor
end

local function search(list, day)
	local low, up = 1, #list
	while low <= up do
		local mid = floor((low+up)/2)
		local value = list[mid]
		if day < value then
			up = mid-1
		elseif day > value then
			low = mid+1
		else -- day == value
			return mid
		end
	end
	return nil, low
end

-- Knuth, The Art of Computer Programming,
-- vol. 1 (Fundamental Algorithms), 3rd ed,
-- 1.3.2 ex 14 is the Easter Sunday problem.
local function CalcEaster(year)
	local g = year%19 + 1              -- Golden
	local c = floor(year/100) + 1      -- Century
	local x = floor(3*c/4) - 12        -- Solar
	local z = floor((8*c+5)/25) - 5    -- Lunar
	local d = floor(5*year/4) - x - 10 -- Letter ?
	local e = (11*g + 20 + z - x) % 30 -- Epact
	if (e<0) then e = e+30 end         -- Fix 9006 problem
	if ( ( (e==25) and (g>11) ) or (e==24) ) then
		e = e+1
	end
	local n = 44 - e
	if (n<21) then n = n+30 end        -- PFM
	local s = n + 7 - ((d+n)%7)        -- Following Sunday
	return Date(1, 3, year) + (s-1)
end

local function addfreeday(calendar, date)
	if date:weekday() < 6 then
		local day = floor(date.days)
		local freedayslist = calendar.freedayslist
		local pos, nxt = search(freedayslist, day)
		if pos == nil then
			insert(freedayslist, nxt, day)
			return true
		end
	end
end

local function expandcalendar(calendar, date)
	local year = date:year()
	local finish, start = calendar.firstyear, calendar.lastyear
	if finish == nil or finish < year then finish = year end
	if start == nil or start > year then start = year end
	local holidays = calendar.holidaysinfo
	for year = start, finish do
		for _, info in ipairs(calendar.holidays) do
			local date = Date(info.day, info.month, year)
			if addfreeday(calendar, date) then
				holidays[#holidays+1] = {date=date,name=info.name}
			end
		end
		local easter = CalcEaster(year)
		for _, info in ipairs(calendar.easterdays) do
			local date = easter+info.shift
			if addfreeday(calendar, date) then
				holidays[#holidays+1] = {date=date,name=info.name}
			end
		end
	end
	sort(holidays, function (one, other) return one.date < other.date end)
end

local Calendar = class{
	holidays = {},
	easterdays = {},
}

function Calendar:__new(...)
	self = rawnew(self, ...)
	if self.freedayslist == nil then self.freedayslist = {} end
	if self.holidaysinfo == nil then self.holidaysinfo = {} end
	return self
end

function Calendar:addholiday(...)
	if select("#", ...) == 3 then
		local days, month, name = ...
		self.holidays[#self.holidays+1] = {name=name,day=days,month=month}
	else
		local days, name = ...
		self.easterdays[#self.easterdays+1] = {name=name,shift=days}
	end
end

function Calendar:addvacation(start, finish)
	expandcalendar(self, start)
	expandcalendar(self, finish)
	start = floor(start.days)
	finish = floor(finish.days)
	local count = 0
	for day = start, finish do
		if addfreeday(self, Date{days=day}, true) then
			count = count+1
		end
	end
	return count
end

function Calendar:isfreeday(date)
	if date:weekday() < 6 then
		expandcalendar(self, date)
		local days = floor(date.days)
		local freedayslist = self.freedayslist
		return search(freedayslist, days) ~= nil
	end
	return false
end

function Calendar:nextworkday(date)
	while date:weekday() > 5 or self:isfreeday(date) do
		date = date:tomorrow()
	end
	return date
end


function Calendar:freedays(start, finish)
	expandcalendar(self, start)
	expandcalendar(self, finish)
	local freedayslist = self.freedayslist
	local pos,nxt = search(freedayslist, floor(start.days))
	local first = pos or nxt
	pos,nxt = search(freedayslist, floor(finish.days))
	local last = pos or nxt
	return last-first
end

local WorkDays = {
	{ 1,2,3,4,5,5,5 }, -- monday
	{ 1,2,3,4,4,4,5 }, -- tuesday
	{ 1,2,3,3,3,4,5 }, -- wednesday
	{ 1,2,2,2,3,4,5 }, -- thursday
	{ 1,1,1,2,3,4,5 }, -- friday
	{ 0,0,1,2,3,4,5 }, -- saturday
	{ 0,1,2,3,4,5,5 }, -- sunday
}
function Calendar:workdays(start, finish)
	local sweekday = start:weekday()
	local sdays, defict = div(start.days, 1)
	local fdays, extra = div(finish.days, 1)
	if defict > 0 and (sweekday > 5 or self:isfreeday(start)) then
		defict = 0
	end
	if extra > 0 and (finish:weekday() > 5 or self:isfreeday(finish)) then
		extra = 0
	end
	local days = fdays - sdays
	local weeks, time
	weeks, days = div(days, 7)
	return weeks*5
	     + (WorkDays[sweekday][days] or 0)
	     - self:freedays(start, finish)
	     - defict
	     + extra
end

return Calendar
