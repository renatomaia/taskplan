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

local WorkHoursDaily = 8
local WorkDaysWeekly = 5
local WorkDaysMonthly = 4*WorkDaysWeekly

local function calcdays(task)
	return task.days
	    or(task.hours and task.hours/WorkHoursDaily)
	    or(task.weeks and task.weeks*WorkDaysWeekly)
	    or(task.months and task.months*WorkDaysMonthly)
	    or task.effort
end

local Workers = {}
local LoadEnv = { Date = Date }
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
if _G._VERSION == "Lua 5.1" then setfenv(input, LoadEnv) end
input(select(2, ...))

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

local function showtime(date)
	local h,m
	h = date.days%1
	h, m = div(WorkHoursDaily*h, 1)
	m = div(60*m, 1)
	if h < 4 then
		h = h+8
	else
		h = h+10
	end
	return string.format("%s-%02d:%02d", tostring(date), h,m)
end

local function timerange(start, finish)
	if finish.days%1 == 0 then
		finish = tostring(finish-1).."-18:00"
	else
		finish = showtime(finish)
	end
	return showtime(start).." - "..finish
end

local WeekDayName = {"seq", "ter", "qua", "qui", "sex", "sab", "dom"}

local ScreenWidth = 100
local RowFormat = "  %-50.50s  %s  %3.0f  %3.0f  %3.0f  %3.0f   "

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
	print(string.format("%s (%.1f dias por semana)", worker.name, worker.workrate*WorkDaysWeekly))
	print("   JIRA   Tarefa                                        "
	      .."Inicio   -  Termino    Requ Work Free Days\n")
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
		io.write(RowFormat:format(string.format("%-7s %s", task.ID, task.name:normal()),
		                       timerange(start, finish),
		                       task.days,
		                       calendar:workdays(start, finish),
		                       calendar:freedays(start, finish),
		                       duration))
		io.write(string.rep(" ", math.ceil((start-begining)*widthfactor)),
		         string.rep("=", math.ceil(duration*widthfactor)))
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
	print(RowFormat:format("TOTAIS",
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
