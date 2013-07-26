require "coffee-script"
require "coffee-script-mapped"
require "salad"

{spawn} = require "child_process"

Table = require "cli-table"
async = require "async"

initialized = false

init = (cb) =>
  return cb() if initialized

  initialized = true
  env = process.env.NODE_ENV || "production"

  Salad.Bootstrap.instance().init
    env: env

  App.sequelize.options.logging = false
  cb()

# task 'db:clear', 'Clear the database', ->
#   init =>
#     sync = App.sequelize.sync(force: true)

#     sync.on "success", =>
#         console.log "Done synchronizing"
#         # process.exit()

#     sync.on "error", (err) =>
#         App.Logger.error err if err
#         App.Logger.error "Could not clear database. An error happened!"
#         # process.exit()


option "-t", "--title [title]", "Migration title. Usage: cake -t foo db:migrations:create"
task 'db:migrations:create', 'Create a new migration', (options) ->
  name = options.title or "unnamed"
  migrate = spawn "./node_modules/salad/node_modules/.bin/sequelize", ["-c", name]

  migrate.stdout.on "data", (data) =>
    console.log data.toString().replace(/\n$/m, '')

  migrate.stderr.on "data", (data) =>
    console.log data.toString().replace(/\n$/m, '')

  migrate.on "close", =>
    console.log "Done"

task 'db:migrations:migrate', 'Migrate the database schema', ->
  migrate = spawn "./node_modules/salad/node_modules/.bin/sequelize", ["-m"]

  migrate.stdout.on "data", (data) =>
    console.log data.toString().replace(/\n$/m, '')

  migrate.stderr.on "data", (data) =>
    console.log data.toString().replace(/\n$/m, '')

  migrate.on "close", =>
    console.log "Done"

task 'db:drop', 'Drop the database schema', ->
  init =>
    tables = [
      "SequelizeMeta"
    ]

    async.eachSeries tables,
      (table, cb) =>
        App.sequelize.query("DROP TABLE IF EXISTS \"#{table}\"").success =>
            cb()
          .error =>
            console.error arguments
            cb "fail"

      (err) =>
        console.log "done!"


task 'db:statistics', "Shows statistics for the database", ->
  init =>
    models = [
    ]

    data = {}

    async.eachSeries models,
      iterator = (model, cb) =>
        model.count (err, count) =>
          data[model.name] = count

          cb()

      done = (err) =>
        table = new Table
          head: ["Object", "Amount"]


        for key, val of data
          table.push [key, val]

        App.Logger.log "Object counts:\n" + table.toString()
