import days.{type Day}
import habits.{type Habit}

pub type Msg {
  // should this event trigger modal closing?
  AddHabit(day: Day, habit: Habit)
  RemoveHabit(habit_id: Int)
  ShowModalAddHabit(day: Day)
  CloseModalAddHabit
}
