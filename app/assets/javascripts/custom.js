console.log('in');
marker = null;

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
    console.log('deer')
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


function initMap() {

  let uluru = {lat: 44, lng: -72};
  map = new google.maps.Map(document.getElementById('map'), {
    zoom: 6,
    center: uluru,
    mapTypeId: 'terrain'
  });

  google.maps.event.addListener(map, 'click', function(event) {
     placeMarker(event.latLng);
  });
}

function removePin() {
  $('#remove_pin').on('click', function(e) {
    marker.setMap(null)
    marker = null
    $('#form_location').val('')
  })
}



function placeMarker(location) {
  console.log(location);
  if (!marker) {
    console.log('marking');
    marker = new google.maps.Marker({
      position: location,
      map: map
    });
  } else {
    console.log('setting');
    marker.setPosition(location);
  }
  updateLocation(location);
}

function updateLocation(location) {
  $('#form_location').val(JSON.stringify(location));
}

$(function() {
  validatePostForm();
  postTab();
  removePin();
})
