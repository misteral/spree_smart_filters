Spree::TaxonsController.class_eval do
  helper 'spree/products'
  helper 'spree/filters'

  def show
    @taxon = Spree::Taxon.find_by_permalink!(params[:id])
    return unless @taxon
    @searcher = build_searcher(params.merge(:taxon => @taxon.id))
    # binding.pry
    if params[:search] && params[:search][:selective_simple_scope]
      @products = @searcher.retrieve_products
    else
      @products = @searcher.retrieve_products.ascend_by_master_price
    end
    respond_to do |format|
      format.js
      format.html
    end
  end

end