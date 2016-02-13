defmodule BrandoPages.Factory do
  use ExMachina.Ecto, repo: Brando.repo

  alias Brando.User
  alias Brando.Page
  alias Brando.PageFragment

  def factory(:user) do
    %User{
      full_name: "James Williamson",
      email: "james@thestooges.com",
      password: "$2b$12$VD9opg289oNQAHii8VVpoOIOe.y4kx7.lGb9SYRwscByP.tRtJTsa",
      username: "jamesw",
      avatar: nil,
      role: [:admin, :superuser],
      language: "en"
    }
  end

  def factory(:page) do
    %Page{
      key: "key/path",
      language: "en",
      title: "Page title",
      slug: "page-title",
      data: ~s([{"type":"text","data":{"text":"Text in p.","type":"paragraph"}}]),
      html: ~s(<p>Text in p.</p>),
      status: :published,
      css_classes: "extra-class",
      creator: build(:user),
    }
  end

  def factory(:page_params) do
    %{
      key: "key/path",
      language: "en",
      title: "Page title",
      slug: "page-title",
      data: ~s([{"type":"text","data":{"text":"Text in p.","type":"paragraph"}}]),
      html: ~s(<p>Text in p.</p>),
      status: :published,
      css_classes: "extra-class",
      creator: build(:user),
    }
  end

  def factory(:page_fragment) do
    %PageFragment{
      key: "key/path",
      language: "en",
      data: ~s([{"type":"text","data":{"text":"Text in p.","type":"paragraph"}}]),
      html: ~s(<p>Text in p.</p>),
      creator: build(:user)
    }
  end

  def factory(:page_fragment_params) do
    %{
      key: "key/path",
      language: "en",
      data: ~s([{"type":"text","data":{"text":"Text in p.","type":"paragraph"}}]),
      html: ~s(<p>Text in p.</p>),
      creator: build(:user)
    }
  end
end