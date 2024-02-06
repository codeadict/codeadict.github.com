defmodule Dairon.Page do
  @attts [
    :id,
    :type,
    :title,
    :body,
    :description,
    :date,
    :src_path,
    :html_path,
    :route,
    :keywords,
    :estimated_reading_time,
    :draft
  ]

  @enforce_keys [
    :id,
    :type,
    :title,
    :description,
    :body,
    :src_path,
    :html_path,
    :route
  ]

  defstruct @attts

  def parse(_path, contents) do
    ["---\n" <> yaml, body] = :binary.split(contents, ["\n---\n"])
    {:ok, attrs} = YamlElixir.read_from_string(yaml)

    attrs =
      attrs
      |> Enum.filter(fn {k, _v} -> String.to_atom(k) in @attts end)
      |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

    attrs =
      case :binary.split(body, ["\n<!-- excerpt -->\n"]) do
        [excerpt | [_ | _]] -> Map.put(attrs, :excerpt, String.trim(excerpt))
        _ -> attrs
      end

    attrs =
      Map.put(
        attrs,
        :estimated_reading_time,
        trunc(Float.ceil(count_words(body) / 180.0))
      )

    {attrs, body}
  end

  def build("content/posts/" <> filename, attrs, body) do
    [year, month, day, id] = String.split(Path.rootname(filename), "-", parts: 4)
    IO.inspect(id)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")
    html_path = Path.join(id, "index.html")
    src_path = "content/posts/#{filename}"
    route = Path.join("/", Path.dirname(html_path)) <> "/"

    # unless Map.has_key?(attrs, :keywords) do
    #  raise "#{src_path} no keywords defined"
    # end

    struct!(
      __MODULE__,
      [
        id: id,
        type: :post,
        date: date,
        body: body,
        src_path: src_path,
        html_path: html_path,
        route: route
      ] ++
        Map.to_list(attrs)
    )
  end

  def build(file_path, attrs, body) do
    id = Path.basename(Path.rootname(file_path))
    html_path = Path.join(id, "index.html")
    src_path = file_path
    route = Path.join("/", Path.dirname(html_path)) <> "/"

    struct!(
      __MODULE__,
      [
        id: id,
        type: :page,
        body: body,
        src_path: src_path,
        html_path: html_path,
        route: route,
        date: DateTime.utc_now()
      ] ++
        Map.to_list(attrs)
    )
  end

  defp count_words(text) do
    text
    |> String.split()
    |> Enum.count()
  end
end
