barista = require "barista"
express = require "express"
Sequelize = require("sequelize-sqlite").sequelize
sqlite = require("sequelize-sqlite").sqlite

router = new barista.Router

env = process.env.NODE_ENV || "production"

port = switch env
  when "production" then 80
  else 3000

# app = Salad.Bootstrap

# app.run
#   environment: env
#   port: port

# Database
sequelize = new Sequelize "salad-example", "root", "",
  dialect: "sqlite"
  storage: "#{Salad.root}/db.sqlite"

Location = sequelize.define "Location",
  title: Sequelize.STRING
  description: Sequelize.TEXT

sequelize.sync()

# Controllers
class PhotosController extends Salad.RestfulController
  @resourceName: "photos"

  index: ->
    @response.send "Hallo!"

class LocationsController extends Salad.RestfulController
  @resourceName: "locations"

  _index: (callback) ->
    items = [
      {id: 2, name: "Bob"}
      {id: 3, name: "Alice"}
      {id: 4, name: "Tim"}
    ]

    callback.apply @, [null, items]

  index: ->
    @_index (error, resources) =>
      @respond
        html: -> @response.send "Ich habe #{resources.length} Einträge"
        json: -> @response.send resources

  show: ->
    console.log @params
    @response.send "Locations GET #{@params.id}"

class ErrorController extends Salad.Controller
  404: ->
    @response.send "404!"

#################################################################

# Routes
router.match("/photos", "GET").to("photos.index")
router.resource("locations")

# App initialisation
app = express()

app.use express.static("#{Salad.root}/public")

app.all "*", (request, response) ->
  matching = router.first(request.path, request.method)

  # A registry of all available controllers
  controllerRegistry =
    ErrorController: ErrorController
    PhotosController: PhotosController
    LocationsController: LocationsController

  # No matching route found
  unless matching
    matching =
      controller: "error"
      action: 404
      method: request.method

  # Get the matching controller
  controllerName = _s.capitalize matching.controller
  controller = controllerRegistry["#{controllerName}Controller"]

  # Could not find associated controller
  unless controller
    controller = controllerRegistry["ErrorController"]

  controller = controller.instance()

  unless controller[matching.action]
    controller = controllerRegistry["ErrorController"].instance()
    matching.action = 404

  controller.response = response
  controller.params = _.extend request.query, request.body, matching

  # Call the controller action
  controller[matching.action]()

app.listen port