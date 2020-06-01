$(document).on('turbolinks:load', function() {
  if (!$('.wysiwyg').length) { return; }
  $('.wysiwyg').trumbowyg({
    btns: [
      ['viewHTML'],
      ['formatting'],
      ['strong', 'em', 'del'],
      ['superscript', 'subscript'],
      ['link'],
      ['unorderedList', 'orderedList'],
      ['horizontalRule'],
      ['fullscreen']
    ],
    svgPath: false,
    hideButtonTexts: true,
    resetCss: true
  });
})
