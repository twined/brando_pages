defmodule Mix.Tasks.BrandoPages.Install do
  use Mix.Task
  import Mix.Generator

  @moduledoc """
  Install Brando.
  """

  @shortdoc "Generates files for Brando News."

  @new [
    # Migration files
    {:eex,  "templates/brando.pages.install/priv/repo/migrations/pages_migration.exs",
            "priv/repo/migrations/timestamp_create_pages.exs"},
    {:eex,  "templates/brando.pages.install/priv/repo/migrations/page_fragments_migration.exs",
            "priv/repo/migrations/timestamp_create_page_fragments.exs"},

    {:copy, "templates/brando.pages.install/web/static/css/includes/_pages.scss",
            "web/static/css/includes/_pages.scss"},
  ]

  @static []

  @root Path.expand("../../../priv", __DIR__)

  for {format, source, _} <- @new ++ @static do
    unless format in [:keep, :copy] do
      @external_resource Path.join(@root, source)
      def render(unquote(source)), do: unquote(File.read!(Path.join(@root, source)))
    end
  end

  def run(_) do
    app = Mix.Project.config()[:app]
    binding = [application_module: Phoenix.Naming.camelize(Atom.to_string(app)),
               application_name: Atom.to_string(app)]

    copy_from "./", binding, @new

    Mix.shell.info "\nBrando Pages finished installing."
  end

  defp copy_from(target_dir, binding, mapping) when is_list(mapping) do
    application_name = Keyword.fetch!(binding, :application_name)
    for {{format, source, target_path}, counter} <- Enum.with_index(mapping) do
      target_path =
        target_path
        |> String.replace("application_name", application_name)

      target_path = if String.contains?(target_path, "timestamp") do
        :timer.sleep(10)
        String.replace(target_path, "timestamp", timestamp(counter))
      else
        target_path
      end

      target = Path.join(target_dir, target_path)

      case format do
        :eex  -> contents = EEx.eval_string(render(source), binding, file: source)
                 create_file(target, contents)
        :copy -> File.mkdir_p!(Path.dirname(target))
                 File.copy!(Path.join(@root, source), target)
      end
    end
  end

  defp timestamp(offset) do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    {mm, ss} = if ss + offset < 60 do
      {mm, ss + offset}
    else
      {mm + 1, offset - (60 - ss)}
    end
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: << ?0, ?0 + i >>
  defp pad(i), do: to_string(i)
end
