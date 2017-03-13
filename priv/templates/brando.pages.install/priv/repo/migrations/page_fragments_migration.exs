defmodule <%= application_module %>.Repo.Migrations.CreatePageFragments do
  use Ecto.Migration
  use Brando.Villain, :migration

  def up do
    create table(:pages_pagefragments) do
      add :key,               :text
      add :language,          :text, null: false
      villain()
      add :creator_id,        references(:users)
      timestamps()
    end
    create index(:pages_pagefragments, [:language])
    create index(:pages_pagefragments, [:key])
  end

  def down do
    drop table(:pages_pagefragments)
    drop index(:pages_pagefragments, [:language])
    drop index(:pages_pagefragments, [:key])
  end
end
