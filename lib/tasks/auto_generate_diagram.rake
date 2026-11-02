# rails-erd is a development tool; don't load its tasks elsewhere.
if Rails.env.development?
  RailsERD.load_tasks
end
