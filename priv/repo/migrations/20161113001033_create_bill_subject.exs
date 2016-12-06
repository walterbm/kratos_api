defmodule KratosApi.Repo.Migrations.CreateBillSubject do
  use Ecto.Migration

  def change do
    create table(:bill_subjects) do
      add :bill_id, references(:bills, on_delete: :nothing)
      add :subject_id, references(:subjects, on_delete: :nothing)

      timestamps()
    end
    create index(:bill_subjects, [:bill_id])
    create index(:bill_subjects, [:subject_id])

  end
end
