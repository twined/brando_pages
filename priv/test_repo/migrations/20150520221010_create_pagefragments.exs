defmodule BrandoPages.Repo.Migrations.CreatePageFragments do
  use Ecto.Migration
  use Brando.Villain, :migration

  def up do
    create table(:pagefragments) do
      add :key,               :text, null: false
      add :language,          :text, null: false
      villain
      add :creator_id,        references(:users)
      timestamps
    end
    create index(:pagefragments, [:language])
    create index(:pagefragments, [:key])
  end

  def down do
    drop table(:pagefragments)
    drop index(:pagefragments, [:language])
    drop index(:pagefragments, [:key])
  end
end
