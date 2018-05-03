defmodule Namely.Name do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Namely.{Action, Name, Repo}

  schema "names" do
    field(:name, :string)
    field(:description, :string)

    timestamps()
  end

  def changeset(record, params \\ :empty) do
    record
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
  end

  def create(name, description) do
    %Name{}
    |> Name.changeset(%{name: name, description: description})
    |> Repo.insert()
    |> log_action("create_name", %{name: name})
  end

  def all() do
    query = from(t in Name, select: t.description)
    Repo.all(query)
  end

  def summary(id) do
    query =
      from(
        t in Name,
        where: t.entity_id == ^id,
        select: t.name
      )

    Repo.all(query)
  end

  defp log_action({:ok, name}, action, data) do
    log_action(name, action, name.name, data)
  end

  defp log_action({:error, changeset} = answer, action, data) do
    log_action(
      answer,
      "#{action}_failed",
      changeset.changes[:name],
      data
    )

    # TODO: serialize changeset errors to readable actions
  end

  defp log_action(answer, action, entity_id, data) do
    %Action{}
    |> Action.changeset(%{name: action, entity_type: "Name", entity_id: entity_id, data: data})
    |> Repo.insert!()

    answer
  end
end
