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

const days = [
  "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday",
]

type Model {
  WeekHabits(week_habits: List(DayHabits))
}

type DayHabits {
  DayHabits(day: String, habits: List(Habit))
}

type Habit {
  Habit(name: String, descriptioin: String)
}

fn init(_) -> #(Model, Effect(Msg)) {
  let initial_model = WeekHabits(week_habits: [])
  #(initial_model, effect.none())
}

type Msg

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  todo
}

fn view(model: Model) -> Element(Msg) {
  html.div(
    [
      attribute.style([
        #("display", "grid"),
        #("grid-template-columns", "repeat(7, 1fr)"),
        #("grid-gap", "10px"),
      ]),
    ],
    // headers
    list.map(list.index_map(days, fn(x, i) { #(i + 1, x) }), fn(v) {
      html.div(
        [
          attribute.style([
            #("border-style", "solid"),
            #("grid-column", int.to_string(v.0)),
          ]),
        ],
        [
          html.div([attribute.style([#("text-align", "center")])], [
            html.text(v.1),
          ]),
        ],
        // here add day items
      )
    }),
  )
}
