barista = require "barista"
express = require "express"
Sequelize = require("sequelize-sqlite").sequelize
sqlite = require("sequelize-sqlite").sqlite

router = new barista.Router

env = process.env.NODE_ENV || "production"

port = switch env
  when "production" then 80
  when "testing" then 3001
  else 3000

# app = Salad.Bootstrap

# app.run
#   environment: env
#   port: port

# Database
sequelize = new Sequelize "salad-example", "root", "",
  dialect: "sqlite"
  storage: "#{Salad.root}/db.sqlite"
  logging: env is "development"

Location = sequelize.define "Location",
  title: Sequelize.STRING
  description: Sequelize.TEXT
  messages: Sequelize.INTEGER

# Controllers
class PhotosController extends Salad.RestfulController
  @resourceName: "photos"

  index: ->
    @response.send "Hallo!"

class LocationsController extends Salad.RestfulController
  @resourceName: "location"

  constructor: ->
    @resource = Location

    super

  _index: (callback) ->
    @resource.findAll().success (resources) =>
      callback.apply @, [null, resources]

  findResource: (callback) ->
    query = @resource.find(@params.id)

    query.success (resource) =>
      callback.apply @, [resource]

  index: ->
    @_index (error, resources) =>
      @respond
        html: -> @response.send "Ich habe #{resources.length} Einträge"
        json: -> @response.send resources

  create: ->
    @_create (error, resource) =>
      @respond
        html: -> @response.send "Created!"
        json: -> @response.send resource

  _create: (callback) ->
    data = @params[@resourceName]

    @resource.create(data)
      .success (resource) =>
        callback.apply @, [null, resource]

      .error (error) =>
        callback.apply @, [error, null]

  show: ->
    @findResource (err, resource) =>
      unless resource
        return @respond
          html: -> @response.send "Not found"
          json: -> @response.send status: 404
      @respond
        html: -> @response.send "Name: #{resource.get("name")}"
        json: -> @response.send resource

class ErrorController extends Salad.Controller
  404: ->
    @response.send "404!"

#################################################################

# Routes
router.match("/photos", "GET").to("photos.index")
router.match("/locations/asdasd", "GET").to("locations.create")
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

Salad.initialize = (callback) =>
  syncSequelize = (cb) ->
    sequelize.sync(force: true).done cb

  listen = (cb) ->
    app.listen port
    cb()

  async.series [syncSequelize, listen], =>
    callback.apply @ if callback