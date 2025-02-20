# QuantumOfSolace

The first time you run the application:

```
%> docker run -e POSTGRES_DB=postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres --name postgres -p 5432:5432 -d postgres
%> mix deps.get
%> mix ecto.create
%> mix ecto.migrate
```

You can then import GTFS data with:

```
%> iex -S mix
iex> mbta()
```

To import subway branches:

```
%> mix run priv/writer/seed.exs
```