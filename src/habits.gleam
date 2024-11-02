import gleam/int

// 2^32
const small_int = 4_294_967_296

pub opaque type Habit {
  Habit(id: Int, name: String, descriptioin: String)
}

pub fn new_habit(name: String, description: String) -> Habit {
  Habit(int.random(small_int), name, description)
}

pub fn name(habit: Habit) -> String {
  habit.name
}

pub fn description(habit: Habit) -> String {
  habit.descriptioin
}

pub fn id(habit: Habit) -> Int {
  habit.id
}
