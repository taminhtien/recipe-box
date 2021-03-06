class RecipesController < ApplicationController
  before_action :find_recipe, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :authorized_user, only: [:edit, :update, :destroy]
  # GET /users
  def index
    @recipes = Recipe.all.order("created_at DESC")
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @recipe = current_user.recipes.build
  end

  # POST /users
  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      redirect_to @recipe, notice: "Successfully created new recipe"
    elsif
      render 'new'
    end
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH /users/1
  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Successfully updated recipe"
    else
      render 'edit'
    end
  end

  # DELETE /users/1
  def destroy
    @recipe.destroy
    redirect_to root_path, notice: "Successfully deleted recipe"
  end

  private

    def find_recipe
      @recipe = Recipe.find(params[:id])
    end

    def recipe_params
      params.require(:recipe).permit(
        :title,
        :description,
        :image,
        :user_id,
        # To destroy nested models, rails uses a virtual attribute called _destroy.
        # When _destroy is set, the nested model will be deleted. If the record
        # is persisted, rails performs id field lookup to destroy the real record,
        # so if id wasn't specified, it will treat current set of parameters
        # like a parameters for a new record.
        ingredients_attributes: [:id, :name, :_destroy],
        directions_attributes: [:id, :step, :_destroy])
    end

    def authorized_user
      @recipe = current_user.recipes.find_by[id: params[:id]]
      redirect_to recipes_path, notice: "Not authorized this recipe" if @recipe.nil?
    end
end
