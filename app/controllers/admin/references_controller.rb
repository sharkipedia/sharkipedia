module Admin
  class ReferencesController < Admin::ApplicationController
    before_action :process_author_input, only: [:update]

    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Reference.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    def find_resource(slug)
      Reference.friendly.find(slug)
    end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
    private

    def process_author_input
      author_input = params[:reference][:author]
      params[:reference][:author] = author_input.split(/\s*,\s*/)
    end
  end
end
