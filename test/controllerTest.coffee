describe "Controller", ->
  describe "Resources", ->
    describe "#index", ->
      it "should return JSON", (done) ->
        agent.get("http://localhost:3001/locations.json")
          .end (res) ->
            res.ok.should.equal(true)
            res.type.should.equal("application/json")

            done()