import gleam/dict.{type Dict}
import gleam/dynamic
import gleam/int
import gleam/list
import gleam/result
import gleam/set
import gleam/string

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

// 2^32
const small_int = 4_294_967_296

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

fn get_index_of_day(day: Day) -> Int {
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

pub type Habit {
  Habit(id: Int, name: String, descriptioin: String)
}

fn new_habit(name: String, description: String) -> Habit {
  Habit(int.random(small_int), name, description)
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

fn get_week_days(week: Week) -> List(#(Day, List(Habit))) {
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

fn week_day(day: Day, week: Week) {
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

fn update_weekday(day: Day, week: Week, habits: List(Habit)) {
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

type ModalAddHabit {
  ModalAddHabit(day: Day, is_show: Bool)
}

type Model {
  Model(week: Week, modal: ModalAddHabit)
}

fn init(_) -> #(Model, Effect(Msg)) {
  let initial_model =
    Model(
      Week(
        monday: [],
        tuesday: [],
        wednesday: [],
        thursday: [],
        friday: [],
        saturday: [],
        sunday: [],
      ),
      ModalAddHabit(Monday, False),
    )
  #(initial_model, effect.none())
}

// ---- UPDATE ----
type Msg {
  AddHabit(day: Day, habit: Habit)
  RemoveHabit(habit_id: Int)
  ShowModalAddHabit(day: Day)
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    AddHabit(day, habit) -> {
      let day_list = week_day(day, model.week)
      let week = update_weekday(day, model.week, list.append([habit], day_list))
      #(Model(week, model.modal), effect.none())
    }
    RemoveHabit(habit_id) -> {
      todo as "write map id -> Habit to make delition"
    }
    ShowModalAddHabit(day) -> {
      #(Model(model.week, ModalAddHabit(day, True)), effect.none())
    }
  }
}

// ---- VIEW ----
fn habit_el(habit: Habit) -> Element(Msg) {
  html.li(
    [
      attribute.style([
        #("border-style", "solid"),
        #("min-width", "5vw"),
        #("min-height", "5vh"),
      ]),
    ],
    [
      html.div([attribute.style([#("font-size", "20px")])], [
        html.text(habit.name),
      ]),
      html.br([]),
      html.div([attribute.style([#("font-size", "15px")])], [
        html.text(habit.descriptioin),
      ]),
    ],
  )
}

fn render_day_habits(day: List(Habit)) {
  html.ol(
    [attribute.style([#("border-style", "solid")])],
    list.map(day, habit_el),
  )
}

fn add_new_habit_dialog(day: Day, is_opened: Bool) -> Element(Msg) {
  html.dialog(
    [
      attribute.open(is_opened),
      attribute.style([
        #("border-style", "solid"),
        #("min-width", "5vw"),
        #("min-height", "5vh"),
      ]),
    ],
    [
      html.p([], [html.text("Adding new habit")]),
      html.form([], [
        html.input([
          attribute.type_("text"),
          attribute.placeholder("name of habbit"),
          attribute.required(True),
        ]),
        html.input([attribute.placeholder(string.inspect(day))]),
        html.input([
          attribute.type_("text"),
          attribute.placeholder("description"),
          attribute.required(False),
        ]),
        html.input([attribute.type_("submit")]),
      ]),
    ],
  )
}

//old fn
fn add_button(day: Day, name: String, description: String) -> Element(Msg) {
  html.button([event.on_click(AddHabit(day, new_habit(name, description)))], [
    html.text("Add habit"),
  ])
}

fn show_modal_button(day: Day) -> Element(Msg) {
  html.button([event.on_click(ShowModalAddHabit(day))], [html.text("Add habit")])
}

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
    list.append(
      [add_new_habit_dialog(model.modal.day, model.modal.is_show)],
      list.map(get_week_days(model.week), fn(v) {
        // v.0 - day, v.1 - habits
        html.div([attribute.style([#("border-style", "solid")])], [
          html.text(string.inspect(v.0)),
          render_day_habits(
            list.concat([[Habit(1, "sport", "any sport")], v.1]),
          ),
          show_modal_button(v.0),
        ])
      }),
    ),
  )
}
