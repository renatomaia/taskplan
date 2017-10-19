# Task Plan

Simple Lua script to calculate a plan for the tasks to be done in a project.

## Requirements

- [Lua 5.3](https://www.lua.org/versions.html#5.3)
- [LOOP 3.0](https://github.com/renatomaia/loop) (available in LuaRocks)
	- Actually, you only need file [`loop/base.lua`](https://github.com/renatomaia/loop/raw/master/lua/loop/base.lua) in your current directory, or more precisely in a directory listed in [`package.path`](https://www.lua.org/manual/5.3/manual.html#pdf-package.path). For more information on the format of this path check [this](https://www.lua.org/manual/5.3/manual.html#pdf-package.searchpath).

## Describe the Project

Tasks are specified in a ordinary Lua file, using the constructors described below.

### Dates

```lua
local firstday = Date(28, 2, 2018) -- day, month, year
local midterm = Date(1, 7, 2018) -- day, month, year
local deadline = Date(31, 12, 2018) -- day, month, year
```

### Workers

```lua
local worker1 = Worker{
	name = "Worker Name",
	start = firstday, -- worker's start moment
	finish = deadline, -- worker's deadline to have all tasks done
	workrate = percent, -- 0 < percent <= 1
	vacations = {
		{ start = midterm, finish = midterm+15 }, -- 15 days after mid-term
		{ start = deadline-15, finish = deadline }, -- 15 days before the end
	}
}
```

### Tasks

All definitions below are equivalent.

- Defining the number of work days required.

```lua
local task1 = Task{
	name = "The Task Description",
	worker = worker1,
	days = 33.5, -- 33 and a half of work days required
}
```

- Defining months, weeks, days or hours of work required.

```lua
local task1 = Task{
	name = "The Task Description",
	worker = worker1,
	hours = 4, -- half work day since 'WorkHoursDaily' is 8 by default.
	days = 3, -- 3 work days
	weeks = 2, -- 10 work days since 'WorkDaysWeekly' is 5 by default.
	months = 1, -- 20 work days since 'WorkDaysMonthly' is 20 by default.
}
```

- Defining sub-tasks.

```lua
local task1 = Task{
	name = "The Task Description",
	worker = worker1,
	{ name = "SubTask1", hours = 4 },
	{ name = "SubTask2", days = 3 },
	{ name = "SubTask3", weeks = 2 },
	{ name = "SubTask4", months = 1 },
}
```

### Custom Confgurations

- ShowGantGraph: print a Gant graph
- WorkHoursDaily: number of work hours in a work day (default is 8)
- WorkDaysWeekly: number of work days in a week (default is 5)
- WorkDaysMonthly: number of work days in a month (default is 20)
- WorkBeginTime: hour of the day the work begins (default is 8).
- WorkFirstHours: number of work hours before the break (default is 4)
- WorkBreakHours: number of hours for the break (default is 2)

## How to Use

To a checkout of the project and execute one of the following commands in directory containing all files in directory `lua`.

- Basic usage.

```
$ lua makecal.lua [file]
```

- Use Tecgraf official holydays.

```
$ lua makecal.lua -l tecgraf [file]
```

