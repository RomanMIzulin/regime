import gleam/function
import gleam/list
import gleam/result
import gleam/string

import days.{type Day}
import habits.{type Habit}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import msg.{type Msg}

/// UI elements
pub fn habit(habit_t: Habit) -> Element(Msg) {
  html.div([attribute.style([#("margin", "5px")])], [
    html.div([attribute.style([#("font-size", "20px")])], [
      html.text(habits.name(habit_t)),
    ]),
    html.br([]),
    html.div([attribute.style([#("font-size", "15px")])], [
      html.text(habits.description(habit_t)),
    ]),
  ])
}

fn habit_li(habit_t: Habit) -> Element(Msg) {
  html.li([attribute.style([#("min-width", "5vw"), #("min-height", "5vh")])], [
    habit(habit_t),
  ])
}

pub fn habits_column(day: List(Habit)) {
  html.ol([attribute.style([])], list.map(day, habit_li))
}

pub fn add_new_habit_dialog(day: Day, is_opened: Bool) -> Element(Msg) {
  let h_name = "habit_name"
  let h_desc = "habit_description"
  html.dialog(
    [
      attribute.open(is_opened),
      attribute.style([#("min-width", "5vw"), #("min-height", "5vh")]),
    ],
    [
      html.div(
        [
          attribute.style([
            #("display", "flex"),
            #("justify-content", "space-between"),
          ]),
        ],
        [
          html.p([], [html.text("Adding new habit")]),
          html.span([event.on_click(msg.CloseModalAddHabit)], [
            html.button([], [html.text("X")]),
          ]),
        ],
      ),
      html.div([], [
        html.input([
          event.on_input(fn(h_name) { msg.EditHabitMsg(msg.AddName(h_name)) }),
          attribute.name(h_name),
          attribute.type_("text"),
          attribute.placeholder("name of habbit"),
          attribute.required(True),
        ]),
        html.input([attribute.placeholder(string.inspect(day))]),
        html.input([
          event.on_input(fn(h_name) {
            msg.EditHabitMsg(msg.AddDescription(h_desc))
          }),
          attribute.name(h_desc),
          attribute.type_("text"),
          attribute.placeholder("description"),
          attribute.required(False),
        ]),
        html.input([
          event.on_click(msg.AddHabit(day)),
          attribute.type_("submit"),
        ]),
      ]),
    ],
  )
}
