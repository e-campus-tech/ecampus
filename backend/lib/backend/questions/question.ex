defmodule Backend.Questions.Question do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backend.Questions.Answer

  @derive {
    Flop.Schema,
    filterable: [:title, :subtitle, :type], sortable: [:title, :subtitle, :type]
  }

  schema "questions" do
    field(:type, Ecto.Enum, values: [:single, :multiple, :sequence])
    field(:title, :string)
    field(:subtitle, :string)
    field(:grade, :integer)
    has_many(:answers, Backend.Questions.Answer)

    many_to_many(:quizzes, Backend.Quizzes.Quiz,
      join_through: "quizzes_questions",
      join_keys: [quiz_id: :id, question_id: :id]
    )

    many_to_many(:answered_by, Backend.Accounts.Account,
      join_through: "answered_questions",
      join_keys: [student_id: :id, question_id: :id]
    )

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:title, :subtitle, :type, :grade])
    |> cast_assoc(:answers, with: &Answer.changeset/2)
    |> validate_required([:title, :type])
  end
end
