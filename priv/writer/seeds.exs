Application.get_env(:quantum_of_solace, QuantumOfSolace.Repos.Writer)
|> QuantumOfSolace.Repos.Writer.start_link()

queries = [
  "TRUNCATE subway_branches",
  "INSERT INTO subway_branches (agency, id, name, line_id) VALUES ('mbta', 'green_b', 'Green-B', 'green')",
  "INSERT INTO subway_branches (agency, id, name, line_id) VALUES ('mbta', 'green_c', 'Green-C', 'green')",
  "INSERT INTO subway_branches (agency, id, name, line_id) VALUES ('mbta', 'green_d', 'Green-D', 'green')",
  "INSERT INTO subway_branches (agency, id, name, line_id) VALUES ('mbta', 'green_e', 'Green-E', 'green')",
  "INSERT INTO subway_branches (agency, id, name, line_id) VALUES ('mbta', 'mattapan', 'Mattapan', 'red')",
]

Enum.each(queries, fn qry ->
  Ecto.Adapters.SQL.query!(QuantumOfSolace.Repos.Writer, qry, [])
end)
