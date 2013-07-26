class App.IndexController extends Salad.Controller
  @layout "application"

  index: ->
    @render "index/index"