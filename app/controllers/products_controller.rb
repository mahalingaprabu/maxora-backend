# app/controllers/api/v1/products_controller.rb
class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_request!
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /api/v1/products
  def index
    # Basic: return all products
    # Later: add location-based filtering, pagination
    products = Product.all
    render json: products.as_json(only: [:id, :title, :description, :price, :stock, :image_url, :latitude, :longitude])
  end

  # GET /api/v1/products/:id
  def show
    render json: @product.as_json(only: [:id, :title, :description, :price, :stock, :image_url, :latitude, :longitude])
  end

  # POST /api/v1/products
  def create
    # For now: allow only admin users to create (simple role check)
    unless current_user.role == 'admin'
      return render json: { error: 'Forbidden' }, status: :forbidden
    end

    product = Product.new(product_params)
    if product.save
      render json: product, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/products/:id
  def update
    unless current_user.role == 'admin'
      return render json: { error: 'Forbidden' }, status: :forbidden
    end

    if @product.update(product_params)
      render json: @product
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/products/:id
  def destroy
    unless current_user.role == 'admin'
      return render json: { error: 'Forbidden' }, status: :forbidden
    end

    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
    render json: { error: 'Not Found' }, status: :not_found unless @product
  end

  def product_params
    params.require(:product).permit(:title, :description, :price, :stock, :image_url, :latitude, :longitude)
  end
end
