import gleam/dict.{type Dict}
import gleam/dynamic
import gleam/int
import gleam/list
import gleam/result
import gleam/set

import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

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

type Model {
  Model(
    monday: DayHabits,
    tuesday: DayHabits,
    wednesday: DayHabits,
    thursday: DayHabits,
    friday: DayHabits,
    saturday: DayHabits,
    sunday: DayHabits,
  )
}

type DayHabits =
  List(Habit)

type Habit {
  Habit(name: String, descriptioin: String)
}

fn init(_) -> #(Model, Effect(Msg)) {
  let initial_model =
    Model(
      monday: [],
      tuesday: [],
      wednesday: [],
      thursday: [],
      friday: [],
      saturday: [],
      sunday: [],
    )
  #(initial_model, effect.none())
}

type Msg {
  AddHabit(day: Int, habit: Habit)
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    AddHabit(day, habit) -> {
      case day {
        0 -> {
          list.append(model.monday, [habit])
          #(model, effect.none())
        }
        _ -> {
          #(model, effect.none())
        }
      }
    }
  }
}

// ---- VIEW ----
fn habit_element(habit: Habit) -> Element(Msg) {
  html.li(
    [
      attribute.style([
        #("border-style", "solid"),
        #("min-width", "5vw"),
        #("min-height", "5vh"),
      ]),
    ],
    [html.text(habit.name)],
  )
}

fn render_day_habits(day: List(Habit)) {
  html.ol(
    [attribute.style([#("border-style", "solid")])],
    list.map(day, habit_element),
  )
}

fn add_button(day: Int) {
  html.button(
    [event.on_click(AddHabit(0, Habit("kekname", "kekdescription")))],
    [html.text("Add habit")],
  )
}

fn render_column(index: Int, day_habits: List(Habit)) {
  html.div(
    [
      attribute.style([
        #("border-style", "solid"),
        #("grid-column", int.to_string(index)),
      ]),
    ],
    [
      html.div([attribute.style([#("text-align", "center")])], [
        html.text("mda"),
      ]),
      render_day_habits(day_habits),
    ],
  )
}

// need to decompose this into smaller functions
fn view(model: Model) -> Element(Msg) {
  html.div(
    [
      attribute.style([
        #("display", "grid"),
        #("grid-template-columns", "repeat(7, minmax(30vw,40vw))"),
        #("grid-gap", "10px"),
        #("overflow", "auto"),
        #("height", "90vh"),
        #("padding-bottom", "10px"),
      ]),
    ],
    [],
  )
}
