local Date = require "Date"
local Calendar = require "Calendar"

local function calcfinish(calendar, start, required)
	local finish = start + required
	local workdays = calendar:workdays(start, finish)
	while workdays < required do
		finish = finish + math.ceil(required - workdays)
		workdays = calendar:workdays(start, finish)
	end
	return finish
end

local Configs = {
	ShowGantGraph = false,
	WorkBeginTime = 8, -- at 8:00
	WorkFirstHours = 4, -- hours
	WorkBreakHours = 2, -- hours
}
local LoadEnv = {
	Date = Date,
	WorkHoursDaily = 8,
	WorkDaysWeekly = 5,
	WorkDaysMonthly = 22,
}

local DaysCalculator = {
	days = function (v) return v end,
	hours = function (v) return v/LoadEnv.WorkHoursDaily end,
	weeks = function (v) return v*LoadEnv.WorkDaysWeekly end,
	months = function (v) return v*LoadEnv.WorkDaysMonthly end,
}
local function calcdays(task)
	local days
	for field, calculate in pairs(DaysCalculator) do
		local value = task[field]
		if value ~= nil then
			days = (days or 0)+calculate(value)
		end
	end
	return days
end

local Workers = {}
function LoadEnv.Worker(worker)
	Workers[#Workers+1] = worker
	local calendar = Calendar()
	local freedays = 0
	local vacations = worker.vacations
	if vacations ~= nil then
		for _, period in ipairs(worker.vacations) do
			freedays = freedays + calendar:addvacation(period.start, period.finish)
		end
	end
	worker.calendar = calendar
	worker.freedays = freedays
	if worker.workrate == nil then
		worker.workrate = 1
	else
		assert(worker.workrate > 0, "illegal work rate")
	end
	return worker
end
local TaskCount = 0
function LoadEnv.Task(task)
	if task.ID == nil then
		TaskCount = TaskCount+1
		task.ID = string.format("TSK-%03d", TaskCount)
	end
	local worker = task.worker
	local calendar = worker.calendar
	local current = calendar:nextworkday(worker.start)
	task.start = current
	task.days = calcdays(task)
	if task.days == nil then
		local days = 0
		for index, subtask in ipairs(task) do
			subtask.days = assert(calcdays(subtask), "subtask days not defined")
			subtask.start = current
			current = calcfinish(calendar, current, subtask.days/worker.workrate)
			subtask.finish = current
			days = days + subtask.days
			current = calendar:nextworkday(current)
		end
		task.finish = task[#task].finish
		task.days = days
	elseif #task == 0 then
		current = calcfinish(calendar, current, task.days/worker.workrate)
		task.finish = current
	else
		error("AVISO: tarefa "..task.ID.." define tempo total e sub-tarefas.")
	end
	worker[#worker+1] = task
	worker.start = calendar:nextworkday(current)
end

local input = assert(loadfile((...), nil, LoadEnv))
input(select(2, ...))

for name, default in pairs(Configs) do
	local value = LoadEnv[name]
	if type(value) == type(default) then
		Configs[name] = value
	end
end
assert(Configs.WorkFirstHours <= LoadEnv.WorkHoursDaily, "first work period is too long")

local LetterEquivalence = {
	a = {"á","à","â","ã"},
	A = {"Á","À","Â","Ã"},
	c = {"ç"},
	C = {"Ç"},
	e = {"é","è","ê"},
	E = {"É","È","Ê"},
	i = {"í","ì","î"},
	I = {"Í","Ì","Î"},
	n = {"ñ"},
	N = {"Ñ"},
	o = {"ó","ò","ô","õ"},
	O = {"Ó","Ò","Ô","Õ"},
	u = {"ú","ù","û"},
	U = {"Ú","Ù","Û"},
}
function string:normal()
	for normalized, letters in pairs(LetterEquivalence) do
		for _, letter in ipairs(letters) do
			self = self:gsub(letter, normalized)
		end
	end
	return self
end

local function div(number, divisor)
	return math.floor(number/divisor), number%divisor
end

local WorkBreakTime = Configs.WorkBeginTime
                    + Configs.WorkFirstHours
local WorkEndTime = Configs.WorkBeginTime
                  + LoadEnv.WorkHoursDaily
                  + Configs.WorkBreakHours
local function showtime(date, finish)
	local h = date.days%1
	local m = 0
	if h == 0 and finish then
		h = WorkEndTime
		date = date-1 -- show as the end of previous day
	else
		h, m = div(LoadEnv.WorkHoursDaily*h, 1)
		h = h+Configs.WorkBeginTime
		m = div(60*m, 1)
		if h > WorkBreakTime or (h == WorkBreakTime and (m > 0 or not finish)) then
			h = h+Configs.WorkBreakHours
		end
	end
	return string.format("%s-%02d:%02d", tostring(date), h,m)
end

local FinishFmt = {
	default = "%s - %s ",
	milestone = "%s -[%s]",
}
local function timerange(start, finish, milestone)
	local format = FinishFmt[milestone or "default"]
	return format:format(showtime(start), showtime(finish, "finish"))
end

local WeekDayName = {"seg", "ter", "qua", "qui", "sex", "sab", "dom"}

local ScreenWidth = 110
local RowFormat = "%s %-50.50s  %s %4.0f %4.0f %4.0f %4.0f   "

local begining = math.huge
local widthfactor
do
	local finish = 0
	for _, worker in ipairs(Workers) do
		begining = math.min(begining, worker[1].start)
		finish = math.max(finish, worker[#worker].finish)
	end
	widthfactor = ScreenWidth/(finish-begining)
end

for _, worker in ipairs(Workers) do
	print(string.rep("_", ScreenWidth))
	print(string.format("%s (%.1f dias por semana)", worker.name, worker.workrate*LoadEnv.WorkDaysWeekly))
	print("   JIRA   Tarefa                                      "
	    .."     Inicio      -     Termino       Requ Work Free Days\n")
	local calendar = worker.calendar
	local days = 0
	local start = worker[1].start
	local finish
	for _, task in ipairs(worker) do
		if worker.finish and task.finish > worker.finish then break end
		local start = task.start
		finish = task.finish
		days  = days + task.days
		local duration = finish-start
		local milestone = task.milestone and "milestone"
		io.write(RowFormat:format(milestone and "*" or " ",
		                          string.format("%-7s %s", task.ID, task.name:normal()),
		                          timerange(start, finish, milestone),
		                          task.days,
		                          calendar:workdays(start, finish),
		                          calendar:freedays(start, finish),
		                          duration))
		if Configs.ShowGantGraph then
			io.write(string.rep(" ", math.ceil((start-begining)*widthfactor)),
			         string.rep("=", math.ceil(duration*widthfactor)),
			         milestone and "|" or "")
		end
		print()
	end
	local holidays = {}
	for _, holiday in ipairs(calendar.holidaysinfo) do
		local date = holiday.date
		if date >= start and date <= finish then
			holidays[#holidays+1] = string.format("%s (%s) - %s", tostring(date), WeekDayName[date:weekday()], holiday.name)
		end
	end
	print()
	print(RowFormat:format(" ", 
	                       "TOTAIS",
	                       timerange(start, finish),
	                       days,
	                       calendar:workdays(start, finish),
	                       calendar:freedays(start, finish),
	                       finish-start))
	print()
	print("  Férias: "..worker.freedays.." dias")
	print("  Feriados: "..#holidays.." dias")
	print("    "..table.concat(holidays, "\n    "))
	print()
end
