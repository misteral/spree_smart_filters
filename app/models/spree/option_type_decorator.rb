
Spree::OptionType.class_eval do
    def self.in_taxon(taxon)
      joins(products: :taxons).where(:spree_products_taxons => {:taxon_id => taxon.self_and_descendants.pluck(:id)}).distinct
    end
end
