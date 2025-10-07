# app/controllers/api/v1/products_controller.rb
module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_request!
      before_action :set_product, only: [:show, :update, :destroy]

      # GET /api/v1/products
      def index
        lat = params[:lat]
        lng = params[:lng]

        if lat.present? && lng.present? && lat.to_f.nonzero? && lng.to_f.nonzero?
          products = Product.nearby(lat.to_f, lng.to_f, params[:radius_km]&.to_f || 50).limit(100)
          render json: products.map { |p| 
            p.as_json(only: [:id, :title, :description, :price, :stock, :image_url, :latitude, :longitude])
             .merge(distance: p.try(:distance)&.to_f)
          }
        else
          products = Product.limit(100)
          render json: products.map { |p| 
            p.as_json(only: [:id, :title, :description, :price, :stock, :image_url, :latitude, :longitude])
             .merge(distance: 0.0)
          }
        end
      end

      # GET /api/v1/products/:id
      def show
        render json: @product.as_json(only: [:id, :title, :description, :price, :stock, :image_url, :latitude, :longitude])
      end

      # POST /api/v1/products
      def create
        return render json: { error: 'Forbidden' }, status: :forbidden unless current_user&.role == 'admin'
        product = Product.new(product_params)
        if product.save
          render json: product, status: :created
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/products/:id
      def update
        return render json: { error: 'Forbidden' }, status: :forbidden unless current_user&.role == 'admin'
        if @product.update(product_params)
          render json: @product
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/products/:id
      def destroy
        return render json: { error: 'Forbidden' }, status: :forbidden unless current_user&.role == 'admin'
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
  end
end

