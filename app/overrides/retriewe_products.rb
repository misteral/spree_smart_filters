Spree::Core::Search::Base.class_eval do
  def retrieve_products
    @products_scope = get_base_scope
    curr_page = page || 1

    #binding.pry
    @products = @products_scope.includes([:variants => :prices])
    #@products = @products_scope.includes([:master => :prices])
    unless Spree::Config.show_products_without_price
      @products = @products.where("spree_prices.amount IS NOT NULL").where("spree_prices.currency" => current_currency)
    end
    @products = @products.page(curr_page).per(per_page)
  end

  def get_base_scope
    base_scope = Spree::Product.active
    base_scope = base_scope.in_taxon(taxon) unless taxon.blank?
    base_scope = get_products_conditions_for(base_scope, keywords)
    base_scope = add_search_scopes(base_scope)
    base_scope
  end

  protected

  def add_search_scopes(base_scope)
    search = check_scopes
    # binding.pry
    search.each do |name, scope_attribute|
      scope_name = name.to_sym
      if base_scope.respond_to?(:search_scopes) && base_scope.search_scopes.include?(scope_name.to_sym)
        base_scope = base_scope.send(scope_name, *scope_attribute)
      else
        base_scope = base_scope.merge(Spree::Product.ransack({scope_name => scope_attribute}).result)
      end
    end if search
    base_scope
  end
  def check_scopes
    #binding.pry
    if search
      search.each do |name, scope_attribute|
        if name == 'price_between'
          # binding.pry
          if scope_attribute.count > 2
            search[:price_between] = scope_attribute[0..1]
          end
          #binding.pry
          if scope_attribute.map {|n| n.blank?}.include?(true)
            search.delete(:price_between)
          end
        end
      end
    end
    #binding.pry
    search
  end

end
