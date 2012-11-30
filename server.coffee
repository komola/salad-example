require "salad"

env = process.env.NODE_ENV || "production"
port = switch env
  when "production" then 80
  else 3000

app = Salad.Bootstrap

app.run
  environment: env
  port: port