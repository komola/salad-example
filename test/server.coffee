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
  Salad.initialize done

after (done) ->
  Salad.destroy done
