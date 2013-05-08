describe "Controller", ->
  describe "Resources", ->
    describe "#index", ->
      it "should return JSON", (done) ->
        agent.get("http://localhost:3001/locations.json")
          .end (res) ->
            res.ok.should.equal(true)
            res.type.should.equal("application/json")

            done()

    describe "#create", ->
      it "should return the newly created resource", (done) ->
        agent.post("http://localhost:3001/locations.json")
          .send(location: {name: "Foo", description: "Bar"})
          .end (res) ->
            res.ok.should.equal(true)
            res.body.id.should.equal 1

            done()