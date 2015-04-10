
Spree::Taxon.class_eval do

  has_many :taxons, :through => :products

  # find brands in taxon
  # def brands_in_taxon
  #   taxons.where(:taxonomy_id => Spree::Taxonomy.find_by_name('Brand')).distinct
  # end

  def min_max
    # binding.pry
    products_price = Spree::Product.in_taxon(self).available.includes(:master => :prices).references(:master => :prices).pluck('spree_prices.amount').compact
    [products_price.min.to_i, products_price.max.to_i]
  end

  def applicable_filters
    fs = []
    # fs << Spree::Core::ProductFilters.seller_filter(self)
    # fs << Spree::Core::ProductFilters.brand_filter(self)
    Spree::OptionType.in_taxon(self).each do |option_type|
      fs << Spree::Core::ProductFilters.option_filter(option_type, self)
    end
    # fs << Spree::Core::ProductFilters.simple_scopes if Spree::Core::ProductFilters.respond_to?(:simple_scopes)
    # fs << Spree::Core::ProductFilters.price_filter(self)

    fs
  end

end
