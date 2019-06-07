class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
    require 'open-uri'
    require 'httparty'
    word = "비비드 코튼 잉크 블러"
    api_url = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=#{word}&maxResults=10&key=AIzaSyAfwa8wirj-dip39TdVu9kD0ZlRAhs1nZ4"
    api_url = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=#{@product.product_name}&maxResults=10&key=AIzaSyAfwa8wirj-dip39TdVu9kD0ZlRAhs1nZ4"
    api_uri = URI.parse(URI.escape(api_url))
    response = HTTParty.get(api_uri)
    data = response.parsed_response
    @videos_id = []
    @titles = []
    data["items"].each do |v|
      @videos_id << v["id"]["videoId"]
    end
    
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:product_name, :price, :product_describe, :buy_link, :img)
    end
end
