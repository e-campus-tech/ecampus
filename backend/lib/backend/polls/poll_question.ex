defmodule Backend.Polls.PollQuestion do
  alias Backend.Polls.PollAnswer
  use Ecto.Schema
  import Ecto.Changeset

  schema "poll_questions" do
    field :type, Ecto.Enum, values: [:single, :multiple, :open]
    field :title, :string
    field :subtitle, :string
    belongs_to :poll, Backend.Polls.Poll

    has_many :poll_answers, Backend.Polls.PollAnswer,
      on_replace: :delete_if_exists,
      on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(poll_question, attrs, required \\ true) do
    attrs =
      attrs
      |> Map.put("poll_answers", Map.get(attrs, "answers"))
      |> Map.delete("answers")

    poll_question
    |> cast(attrs, [:title, :subtitle, :type, :poll_id])
    |> maybe_cast_assoc_answers(attrs)
    |> maybe_validate_required(required)
    |> foreign_key_constraint(:poll_id)
  end

  defp maybe_cast_assoc_answers(changeset, attrs) do
    case Map.fetch(attrs, "poll_answers") do
      {:ok, poll_answers} when is_list(poll_answers) ->
        cast_assoc(changeset, :poll_answers, with: &PollAnswer.changeset/2)

      _ ->
        changeset
    end
  end

  defp maybe_validate_required(changeset, true) do
    changeset
    |> validate_required([:title, :type, :poll_id])
  end

  defp maybe_validate_required(changeset, false), do: changeset
end
