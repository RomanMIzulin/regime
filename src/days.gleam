import habits.{type Habit}

const days = #(
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
)

pub type Day {
  Monday
  Tuesday
  Wednesday
  Thursday
  Friday
  Saturday
  Sunday
}

pub fn get_index_of_day(day: Day) -> Int {
  case day {
    Monday -> 0
    Tuesday -> 1
    Wednesday -> 2
    Thursday -> 3
    Friday -> 4
    Saturday -> 5
    Sunday -> 6
  }
}

pub type Week {
  Week(
    monday: List(Habit),
    tuesday: List(Habit),
    wednesday: List(Habit),
    thursday: List(Habit),
    friday: List(Habit),
    saturday: List(Habit),
    sunday: List(Habit),
  )
}

pub fn get_week_days(week: Week) -> List(#(Day, List(Habit))) {
  [
    #(Monday, week.monday),
    #(Tuesday, week.tuesday),
    #(Wednesday, week.wednesday),
    #(Thursday, week.thursday),
    #(Friday, week.friday),
    #(Saturday, week.saturday),
    #(Sunday, week.sunday),
  ]
}

pub fn week_day(day: Day, week: Week) {
  case day {
    Monday -> week.monday
    Tuesday -> week.tuesday
    Wednesday -> week.wednesday
    Thursday -> week.thursday
    Friday -> week.friday
    Saturday -> week.saturday
    Sunday -> week.sunday
  }
}

pub fn update_weekday(day: Day, week: Week, habits: List(Habit)) {
  case day {
    Monday -> Week(..week, monday: habits)
    Tuesday -> Week(..week, tuesday: habits)
    Wednesday -> Week(..week, wednesday: habits)
    Thursday -> Week(..week, thursday: habits)
    Friday -> Week(..week, friday: habits)
    Saturday -> Week(..week, saturday: habits)
    Sunday -> Week(..week, sunday: habits)
  }
}
