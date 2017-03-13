defmodule BrandoPages.Repo.Migrations.CreatePages do
  use Ecto.Migration
  use Brando.Villain, :migration

  def up do
    create table(:pages_pages) do
      add :key,               :text, null: false
      add :language,          :text, null: false
      add :title,             :text, null: false
      add :slug,              :text, null: false
      villain()
      add :status,            :integer
      add :parent_id,         references(:pages_pages), default: nil
      add :creator_id,        references(:users)
      add :css_classes,       :text
      add :meta_description,  :text
      add :meta_keywords,     :text
      timestamps()
    end
    create index(:pages_pages, [:language])
    create index(:pages_pages, [:slug])
    create index(:pages_pages, [:key])
    create index(:pages_pages, [:parent_id])
    create index(:pages_pages, [:status])
  end

  def down do
    drop table(:pages_pages)
    drop index(:pages_pages, [:language])
    drop index(:pages_pages, [:slug])
    drop index(:pages_pages, [:key])
    drop index(:pages_pages, [:parent_id])
    drop index(:pages_pages, [:status])
  end
end
