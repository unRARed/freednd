$(document).on('turbolinks:load', function() {
  $.fn.dismissible = function () {
    var $that = this;
    // this is only for .notification elements
    if (!$that.hasClass('notification')) { return; }

    $that.find('.delete').click(function () {
      $(this).closest('.notification').remove();
    });
  }

  // apply dismissible functionality to any
  // rendered notifications on page load
  $('.notification').dismissible();
});
