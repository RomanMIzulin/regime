import gleam/int
import gleam/list
import gleam/string

import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

import days.{type Day, type Week, Week}
import habits.{type Habit}
import msg.{type Msg}
import ui

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
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
      ModalAddHabit(days.Monday, False),
    )
  #(initial_model, effect.none())
}

// ---- UPDATE ----

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    msg.AddHabit(day, habit) -> {
      let day_list = days.week_day(day, model.week)
      let week =
        days.update_weekday(day, model.week, list.append([habit], day_list))
      #(Model(week, model.modal), effect.none())
    }
    msg.RemoveHabit(habit_id) -> {
      todo as "write map id -> Habit to make delition"
    }
    msg.ShowModalAddHabit(day) -> {
      #(Model(model.week, ModalAddHabit(day, True)), effect.none())
    }
    msg.CloseModalAddHabit -> {
      #(Model(model.week, ModalAddHabit(model.modal.day, False)), effect.none())
    }
  }
}

// ---- VIEW ----

fn show_modal_button(day: Day) -> Element(Msg) {
  html.button([event.on_click(msg.ShowModalAddHabit(day))], [
    html.text("Add habit"),
  ])
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
      [ui.add_new_habit_dialog(model.modal.day, model.modal.is_show)],
      list.map(days.get_week_days(model.week), fn(v) {
        // v.0 - day, v.1 - habits
        html.div([attribute.style([])], [
          html.text(string.inspect(v.0)),
          ui.habits_column(
            list.concat([[habits.new_habit("sport", "any sport")], v.1]),
          ),
          show_modal_button(v.0),
        ])
      }),
    ),
  )
}
