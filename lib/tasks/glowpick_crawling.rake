namespace :data do
  desc "glowpick crawling"
  task :glowpick => :environment do
    require 'open-uri'
    require 'nokogiri'
    
    doc = Nokogiri::HTML(open("https://www.glowpick.com/beauty/new"))
    contents = []
    contents = doc.search("meta[itemprop='url']").map { |n| 
      n['content'] 
    }
    contents.delete_at(0)
    contents.each do |contents_url|
        doc = Nokogiri::HTML(open(contents_url))
        img = doc.css(".product-image__dump").attr("src").value
        if Product.where(img: img) == nil or Product.where(img: img) == []
            product = Product.new
            product.product_name = doc.css(".product-main-info__product_name__text").inner_text
            product.price = doc.css(".product-main-info__volume_price--bold").inner_text
            product.product_describe = doc.css(".product-detail__description").inner_text
            product.img = img
            product.save
        end
    end

  end
end