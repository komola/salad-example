Salad.Router.register (router) ->
  router.match("/photo", "GET").to("photos.index")