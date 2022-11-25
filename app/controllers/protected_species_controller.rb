class ProtectedSpeciesController < ApplicationController
  def index
    @species = policy_scope(Species).first(20)
  end
end
