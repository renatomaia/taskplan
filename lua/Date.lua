local _G = require "_G"
local assert = _G.assert
local type = _G.type

local string = require "string"
local format = string.format

local math = require "math"
local ceil = math.ceil
local floor = math.floor

local oo = require "loop.base"
local class = oo.class
local rawnew = oo.rawnew

local Year = 365
local FourYears = 4*Year + 1 -- leap day
local Century = 36524 -- 365*100 + 24 leap days
local FourCenturies = 4*Century + 1 -- leap day

local function div(number, divisor)
	return floor(number/divisor), number%divisor
end

local function search(list, day)
	local low, up = 1, #list
	while low < up do
		local mid = floor((low+up)/2)
		local value = list[mid]
		if day < value then
			up = mid
		elseif day > value then
			low = mid+1
		else -- day == value
			return mid+1
		end
	end
	return low
end

local MonthDays = {
	31, -- jan
	28, -- feb
	31, -- mar
	30, -- apr
	31, -- may
	30, -- jun
	31, -- jul
	31, -- aug
	30, -- sep
	31, -- oct
	30, -- nov
	31, -- dec
}
local MonthEnd = { MonthDays[1] }
for month = 2, 12 do
	MonthEnd[month] = MonthEnd[month-1] + MonthDays[month]
end

local Date = class{ days = 0 }

function Date:__new(day, month, year)
	if type(day) == "number" then
		self = rawnew(self)
		assert(year > 0, "invalid year")
		local fourYears, centuries, fourCenturies
		fourCenturies, year = div(year-1, 400)
		centuries    , year = div(year, 100)
		fourYears    , year = div(year, 4)
		local leap = (year == 3 and (fourYears < 24 or centuries == 3))
		local monthdays = MonthDays[month]
		if month == 2 and leap then
			monthdays = 29
		else
			monthdays = MonthDays[month]
		end
		assert(monthdays, "invalid month")
		assert(day > 0 and day <= monthdays, "invalid day")
		self.days = fourCenturies * FourCenturies +
		            centuries     * Century +
		            fourYears     * FourYears +
		            year          * Year +
		            (MonthEnd[month-1] or 0) +
		            ((leap and month > 2) and 1 or 0) +
		            day-1
	else
		self = rawnew(self, day)
		assert(self.days >= 0, "invalid day count")
	end
	return self
end

function Date:year()
	local days = self.days
	local fourCenturies, days = div(days, FourCenturies)
	local centuries    , days = div(days, Century)
	if centuries == 4 then centuries, days = 3, Century end
	local fourYears    , days = div(days, FourYears)
	local years        , days = div(days, Year)
	if years == 4 then years, days = 3, Year end
	local leap = (years == 3 and (fourYears < 24 or centuries == 3))
	local year = 400*fourCenturies + 100*centuries + 4*fourYears + years
	return year + 1, leap, days
end

function Date:month()
	local year, leap, days = self:year()
	if leap and days >= 59 then
		if days < 60 then
			return 2, year, true, days-31
		else
			days = days-1
		end
	end
	local month = search(MonthEnd, days)
	return month, year, leap, days - (MonthEnd[month-1] or 0)
end

function Date:day()
	local month, year, leap, days = self:month()
	return floor(days)+1, month, year, leap
end

function Date:weekday()
	return (floor(self.days)%7) + 1
end

function Date:isleapyear()
	local _, leap = self:year()
	return leap
end

function Date:shiftyears(years)
	local day, month, year = self:day()
	return Date(day, month, year+years)
end

function Date:shiftmonths(months)
	local day, month, year = self:day()
	local years
	years, month = div(month+months, 12)
	return Date(day, month, year+years)
end

function Date:tomorrow()
	local today = self.days
	local tomorrow = ceil(today)
	if tomorrow == today then tomorrow = tomorrow+1 end
	return Date{ days = tomorrow }
end

function Date:yesterday()
	local today = self.days
	local yesterday = floor(today)
	if yesterday == today then yesterday = yesterday-1 end
	return Date{ days = yesterday }
end

function Date.__add(one, other)
	if type(one) ~= "number" then
		one = one.days
	end
	if type(other) ~= "number" then
		other = other.days
	end
	return Date{ days = one + other }
end

function Date.__sub(one, other)
	if type(one) == "number" then       -- (number-date)
		return Date{ days = one - other.days }
	elseif type(other) == "number" then -- (date-number)
		return Date{ days = one.days - other }
	else                                -- (date-date)
		return one.days - other.days
	end
end

function Date.__lt(one, other)
	if type(one) ~= "number" then
		one = one.days
	end
	if type(other) ~= "number" then
		other = other.days
	end
	return one < other
end

function Date:__tostring()
	return format("%02d/%02d/%04d", self:day())
end

return Date
