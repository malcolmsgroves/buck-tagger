# Buck Tagger
*The Social Network for Hunters*
A social network for deer hunters that is modeled off of Strava. Users are able to follow other users and create georeferenced posts with images and deer stats. Notable features include:
* OAuth2.0 user authentication through the Devise gem.
* Google Maps Javascript API for georeferencing posts
* Google Geocoding API for server-side reverse geocoding.
* Carrierwave file upload for post images.

## OAuth2.0 Authentication
User authentication is implemented with the Devise gem. Users can choose to either create an original account or connect their google account for authentication, in which case their profile will be initialized with default information that can be updated after account creation. Account confirmation emails are sent with the Heroku SendGrid add-on.

User authentication with OAuth2.0 in *app/models/user.rb*
```ruby
def self.find_for_google_oauth2(access_token, signed_in_resource = nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        access_token.provider = "Google"
        user = User.create(name: data["name"],
          provider: access_token.provider,
          email: data["email"],
          birthdate: "1 January 2000",
          password: Devise.friendly_token[0,20])
      end
    end
  end
```


## Google Maps Javascript API
In order to allow users to georeference their posts, the post form includes a Google Maps JS API element. Users can select a location by clicking on the map. On a click, the map listener updates a hidden field in the post form to include the latitude and longitude of the selected location.



Client-side Google Maps JS API for post georeferencing in app/assets/javascripts/custom.js
```javascript
function initMap(location, zoom) {
  let map = new google.maps.Map(document.getElementById('map'), {
    zoom: zoom,
    center: location,
    mapTypeId: 'terrain'
  });
  return map;
}

function renderFormMap(location) {
  let map = initMap(location, 7);
  google.maps.event.addListenerOnce(map, 'idle', function() {
    marker = null;
    google.maps.event.addListener(map, 'click', function(event) {
       placeMarker(event.latLng, map);
    });
    map.setCenter(location);
  });
}

function placeMarker(location, map) {
  if (!marker) {
    marker = new google.maps.Marker({
      position: location,
      map: map
    });
  } else {
    marker.setPosition(location);
  }
  updateLocation(location);
}

function updateLocation(location) {
  $('.form_location').each(function(i, obj) {
    $(this).val(JSON.stringify(location));
  });
}
```

The Google Maps API is also used to visualize post locations. In the post feed, static maps are used in order to speed up page loading. 

Static map call for posts in *app/views/posts/\_post.html.erb*
```ruby
<% if post.location %>
  <a href="<%= post_path(post) %>">
    <%= image_tag("https://maps.googleapis.com/maps/api/staticmap?zoom=12&scale=2&size=600x300&maptype=terrain&markers=color:orange%7C#{JSON.parse(post.location)['lat']},#{JSON.parse(post.location)['lng']}&key=AIzaSyDjwq7jh0cqrdKuqFlQ5GDX3ldFTbChJ8M") %>
  </a>
<% end %>
```

On the posts#show page, a Google Maps JS API is used so that the user can explore the map that contains the pinned location of the post.

Client-side visualization of post location in *app/assets/javascripts/custom.js*
```javascript
function renderPostMap(location) {
  let map = initMap(location, 10);

  google.maps.event.addListenerOnce(map, 'idle', function(){
    marker = null;
    google.maps.event.clearListeners(map, 'click');
    map.setCenter(location);
    placeMarker(location, map);
  });
}
```


