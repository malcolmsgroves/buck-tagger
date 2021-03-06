let marker = null;

function validatePostForm() {

  $("#new_deer_post").validate({
    rules: {
      'post[deer_attributes][weight]': 'required',
      'post[content]': 'required',
      'post[deer_attributes][sex]': 'required',
      'post[deer_attributes][season]': 'required',
      'post[deer_attributes][points]': 'required',
    }
  });

  $("#new_scout_post").validate({
    rules: {
      'post[content]': 'required',
    }
  })
}

function postTab() {
  let $deer_form = $('#deer_form');
  let $scout_form = $('#scout_form');
  let $deer_tab = $('.tab#deer');
  let $scout_tab = $('.tab#scout');

  $deer_tab.on('click', function() {
    $deer_form.show()
    $scout_form.hide()
    $deer_tab.addClass('current_tab');
    $scout_tab.removeClass('current_tab');
  })

  $scout_tab.on('click', function() {
    console.log('scout')
    $scout_form.show()
    $deer_form.hide()
    $scout_tab.addClass('current_tab');
    $deer_tab.removeClass('current_tab');
  })

  $deer_tab.click();
}

function initMap(location, zoom) {
  let map = new google.maps.Map(document.getElementById('map'), {
    zoom: zoom,
    center: location,
    mapTypeId: 'terrain'
  });
  return map;
}

function renderPostMap(location) {
  let map = initMap(location, 10);

  google.maps.event.addListenerOnce(map, 'idle', function(){
    marker = null;
    google.maps.event.clearListeners(map, 'click');
    map.setCenter(location);
    placeMarker(location, map);
  });
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

function renderProfileMap(posts) {
  let map = initMap( { lat: 44, lng: -70 }, 7);
  markers = [];

  posts.forEach(function(element) {
    // element = [post, deer?]
    if(element[0].location) {
      console.log(element[0]);
      let icon = element[1] ? 'http://maps.google.com/mapfiles/ms/icons/orange-dot.png' : 'http://maps.google.com/mapfiles/ms/icons/green-dot.png';
      console.log(icon);
      let marker = new google.maps.Marker({
                    position: JSON.parse(element[0].location),
                    map: map,
                    icon: icon,
                  });

      // show post when marker is clicked
      google.maps.event.addListener(marker, 'click', function(event) {
        window.location = `/posts/${element[0].id}`;
      })
      markers.push(marker);

    }
    else {
      console.log('no location');
    }
  })
  /*
  let bounds = new google.maps.LatLngBounds();
  for (let i = 0; i < markers.length; i++) {
    bounds.extend(markers[i].getPosition());
  }

  map.fitBounds(bounds);
  */
}

function removePin() {
  $('#remove_pin').on('click', function(e) {
    marker.setMap(null)
    marker = null
    $('#form_location').val('')
  })
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

function renderAddress(address) {
  console.log(address);

  $post_header = $('.post-header');
  console.log($post_header);

  if(address.town) {
    $post_header.append(`<div><strong>Town: </strong>${address.town}</div>`);
  }
  if(address.county) {
    $post_header.append(`<div><strong>County: </strong>${address.county}</div>`);
  }
  if(address.state) {
    $post_header.append(`<div><strong>State: </strong>${address.state}</div>`);
  }

}

function notification_count() {
  console.log('counting');
  response = $.getJSON("/notifications/unread_notifications")
    .done(function(data) {
      console.log(data);
      if(data.unread) {
        $('#nav-notification').css( { color: 'red' } );
      }
    })
    .fail(function() {
      console.log('error');
    })
    .always(function() {
      console.log('complete');
    })
}

$(document).on('turbolinks:load', notification_count);
