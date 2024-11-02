import days.{type Day}
import habits.{type Habit}

pub type Msg {
  // should this event trigger modal closing?
  AddHabit(day: Day)
  RemoveHabit(habit_id: Int)
  ShowModalAddHabit(day: Day)
  CloseModalAddHabit
  EditHabitMsg(AddingHabitMsg)
}

pub type AddingHabitMsg {
  AddName(name: String)
  AddDescription(description: String)
}
