queries = [
  "INSERT INTO subway_branches (agency, id, name, line_id) VALUES ('mbta', 'green-b', 'Green-B', 'green')",
  "INSERT INTO subway_branches (agency, id, name, line_id) VALUES ('mbta', 'green-c', 'Green-C', 'green')",
  "INSERT INTO subway_branches (agency, id, name, line_id) VALUES ('mbta', 'green-d', 'Green-D', 'green')",
  "INSERT INTO subway_branches (agency, id, name, line_id) VALUES ('mbta', 'green-e', 'Green-E', 'green')",
  "INSERT INTO subway_branches (agency, id, name, line_id) VALUES ('mbta', 'mattapan', 'Mattapan', 'red')",
]

Enum.each(queries, fn qry ->
  Ecto.Adapters.SQL.query!(QuantumOfSolace.Repos.Writer, qry, [])
end)
