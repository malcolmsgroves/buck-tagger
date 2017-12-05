console.log('in');

function validatePostForm() {

  $("#new_deer_post").validate({
    rules: {
      'post[deer_attributes][weight]': 'required',
      'post[content]': 'required',
      'post[deer_attributes][sex]': 'required',
      'post[deer_attributes][season]': 'required',
      'post[deer_attributes][county_id]': 'required',
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

$(function() {
  console.log('initiated');
  validatePostForm();
  postTab();
})
