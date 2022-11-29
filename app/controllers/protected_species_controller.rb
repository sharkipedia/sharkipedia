class ProtectedSpeciesController < PreAuthController
  def index
    @species = policy_scope(Species).where.not(cms_status: 0).or(policy_scope(Species).where.not(cites_status: 0))
  end
end
