
Spree::OptionValue.class_eval do
    def self.in_taxon(taxon, option_type)
      joins(variants: { product: :taxons }).where(:spree_products_taxons => {:taxon_id => taxon.self_and_descendants.pluck(:id)}).where(:option_type => option_type).distinct
    end
end
