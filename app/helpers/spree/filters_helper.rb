module Spree
  module FiltersHelper

    def FiltersHelper.get_applicable_filters(searcher, taxon)
      #binding.pry
      fs = []
      if searcher.properties[:search]
        products = searcher.get_base_scope
        # fs << Spree::Core::ProductFilters.seller_filter_products(products)
        fs << Spree::Core::ProductFilters.brand_filter_products(products)
        ####### for options #########
        option_types = products.map(&:option_types).flatten.uniq
        option_types.each do |option_type|
          fs << Spree::Core::ProductFilters.option_filter_products(products, option_type)
        end
        fs << Spree::Core::ProductFilters.price_filter_products(products)
        fs << Spree::Core::ProductFilters.simple_scopes
        fs
      else
        fs = taxon.applicable_filters
      end
      fs.compact
    end

    def get_filters(searcher)
    	resp = []
    	p = searcher.properties.clone
      taxon = searcher.properties[:taxon]
      url = spree.nested_taxons_path(taxon.permalink)
      resp << {'key' => taxon.name, 'value'=> seo_url(taxon.parent)}
			p.delete(:taxon)
      if p[:search]
  			search_hash = p[:search].dup
        search_hash.each do |key,values|
        	# if key == 'seller_any'
        	# 	values.each do |value1|
        	# 		clone_values = values.clone
        	# 		clone_values.delete(value1)
        	# 		p_clone = p.clone
  			 			# p_search =p[:search].dup
  	      # 		p_search[:seller_any] = clone_values
  	      # 		p_clone[:search] = p_search
  	      # 		resp << {'key' => Spree::Seller.find(value1).name , 'value'=> url+'?'+p_clone.to_query}
  	      # 	end
        	# end
          if key == 'brand_any'
            values.each do |value1|
              clone_values = values.clone
              clone_values.delete(value1)
              p_clone = p.clone
              p_search =p[:search].dup
              p_search[:brand_any] = clone_values
              p_clone[:search] = p_search
              resp << {'key' => Spree::Brand.find(value1).name , 'value'=> url+'?'+p_clone.to_query}
            end
          end
        	if key == 'price_between'
        		p_clone = p.clone
        		clone_p = p[:search].dup
        		clone_p.delete(:price_between)
        		p_clone[:search] = clone_p
        		resp << {'key' => values, 'value' =>  url+'?'+p_clone.to_query}
        	end
        	if key == 'selective_with'
        		values.each do |value1|
      				clone_values = values.clone
        			clone_values.delete(value1)
        			p_clone = p.clone
  			 			p_search =p[:search].dup
  	      		p_search[:selective_with] = clone_values
  	      		p_clone[:search] = p_search
  	      		resp << {'key' => value1, 'value' => url+'?'+p_clone.to_query}
  	      	end
        	end
        end if searcher.properties[:search]
        resp
      else
        nil
      end
    end
  end
end
