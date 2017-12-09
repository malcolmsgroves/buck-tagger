module PostsHelper

  def reverse_geocode(location)
    latlng_string = "#{location['lat']},#{location['lng']}"
    response = RestClient::Request.execute(
      method: :get,
      url: "https://maps.googleapis.com/maps/api/geocode/json?latlng=#{latlng_string}&key=#{ENV['GOOGLE_SERVER_KEY']}"
    )
    address = {}
    begin
      JSON.parse(response)["results"][0]["address_components"].each do |component|
        case component['types'][0]
        when 'locality'
          address[:town] = component['long_name']
        when 'administrative_area_level_2'
          address[:county] = component['long_name']
        when 'administrative_area_level_1'
          address[:state] = component['long_name']
        end
      end
    rescue
      address[:town] = 'unknown'
    end

    address
  end
end
