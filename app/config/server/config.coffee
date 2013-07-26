config = {}

config.database =
  production:
    username: "postgres"
    password: ""
    host: "localhost"
    database: ""
    port: 5432

  testing:
    username: "postgres"
    password: ""
    host: "localhost"
    database: ""
    port: 5432

  development:
    username: "postgres"
    password: ""
    host: "localhost"
    database: ""
    port: 5432

module.exports = config