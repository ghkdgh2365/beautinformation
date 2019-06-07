namespace :data do
  desc "glowpick crawling"
  task :glowpick => :environment do
    require 'open-uri'
    require 'nokogiri'
    require 'httparty'
    
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
            api_url = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=#{product.product_name}&maxResults=10&key=AIzaSyAfwa8wirj-dip39TdVu9kD0ZlRAhs1nZ4"
            api_uri = URI.parse(URI.escape(api_url))
            response = HTTParty.get(api_uri)
            data = response.parsed_response
            @videos_id = []
            data["items"].each do |v|
              @videos_id << v["id"]["videoId"]
            end
            product.buy_link = @videos_id
            product.save
        end
        
    end

  end
end