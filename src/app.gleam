import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/string
import lustre/ui/alert

import lustre
import lustre/attribute.{style}
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

import days.{type Day, type Week, Week}
import habits.{type AddingHabit, type Habit, AddingHabit}
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
  Model(week: Week, modal: ModalAddHabit, adding_habit: AddingHabit)
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
      AddingHabit(option.None, option.None),
    )
  #(initial_model, effect.none())
}

// ---- UPDATE ----

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    msg.AddHabit(day) -> {
      let day_list = days.week_day(day, model.week)
      case model.adding_habit.name, model.adding_habit.description {
        option.Some(name), option.Some(description) -> {
          let habit = habits.new_habit(name, description)
          let week =
            days.update_weekday(day, model.week, list.append([habit], day_list))
          #(
            Model(
              week: week,
              modal: ModalAddHabit(days.Monday, False),
              adding_habit: AddingHabit(option.None, option.None),
            ),
            effect.none(),
          )
        }
        _, _ -> {
          alert.alert([], [
            html.text("Name and description are required when creating a habit"),
          ])
          #(model, effect.none())
        }
      }
    }
    msg.RemoveHabit(habit_id) -> {
      todo as "write map id -> Habit to make delition"
    }
    msg.ShowModalAddHabit(day) -> {
      #(Model(..model, modal: ModalAddHabit(day, True)), effect.none())
    }
    msg.CloseModalAddHabit -> {
      #(
        Model(
          ..model,
          modal: ModalAddHabit(model.modal.day, False),
          adding_habit: AddingHabit(option.None, option.None),
        ),
        effect.none(),
      )
    }
    msg.EditHabitMsg(field) -> {
      case field {
        msg.AddName(name) -> {
          #(
            Model(
              ..model,
              adding_habit: AddingHabit(
                option.Some(name),
                model.adding_habit.description,
              ),
            ),
            effect.none(),
          )
        }
        msg.AddDescription(description) -> {
          #(
            Model(
              ..model,
              adding_habit: AddingHabit(
                model.adding_habit.name,
                option.Some(description),
              ),
            ),
            effect.none(),
          )
        }
      }
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
        html.div(
          [
            attribute.style([
              #("opacity", case model.modal.is_show {
                True -> "0.5"
                False -> "1"
              }),
            ]),
          ],
          [
            html.text(string.inspect(v.0)),
            ui.habits_column(
              list.concat([
                [
                  habits.new_habit("sport", "any sport"),
                  habits.new_habit(
                    "energy control",
                    "only one tea or coffee/breath technique",
                  ),
                ],
                v.1,
              ]),
            ),
            show_modal_button(v.0),
          ],
        )
      }),
    ),
  )
}
