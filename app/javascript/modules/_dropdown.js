$(document).on('turbolinks:load', function() {
  $('.dropdown').on('click.dropdown', function (evt){
    var $dropdown = $(this);
    if ($(evt.target).hasClass('dropdown-item')) {
      $dropdown.off('click.dropdown');
    }
    $dropdown.focusout(function() {
      setTimeout(function () {
        $dropdown.removeClass('is-active');
      }, 200);
    });
    $dropdown.toggleClass('is-active');
  });
});
