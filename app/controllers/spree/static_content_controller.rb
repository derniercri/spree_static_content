module Spree
  class StaticContentController < StoreController
    helper 'spree/products'
    layout :determine_layout

    def show
      filtered_path = request.path.gsub(/\/(#{SpreeGlobalize::Config.supported_locales.join('|')})/, '')
      locale =  request.path.gsub(filtered_path, '')
      @page = Spree::StaticPage.finder_scope.by_store(current_store).where('spree_page_translations.slug = ?', filtered_path).first
    end

    private

    def determine_layout
      return @page.layout if @page && @page.layout.present? && !@page.render_layout_as_partial?
      Spree::Config.layout
    end

    def accurate_title
      @page ? (@page.meta_title.present? ? @page.meta_title : @page.title) : nil
    end
  end
end
