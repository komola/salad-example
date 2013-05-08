require "coffee-script"
require "coffee-script-mapped"
require "salad"

require "../app/config/server/bootstrap"

global.chai = require "chai"
global.expect = chai.expect
global.sinon = require "sinon"
global.async = require "async"
global.agent = require "superagent"

before (done) ->
  console.log "Loading!"
  Salad.initialize done

after (done) ->
  console.log "Dadada"

  done()