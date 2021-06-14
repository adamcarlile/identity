$(document).ready(function(){

  $('.otp-control').find('div.control').each(function() {
    var container = $(this)
    var input = $(container).find('input')

    $(input).attr('maxlength', 1);

    $(input).on('paste', function(e) {
      var data = e.originalEvent.clipboardData.getData('text').split("")
      var inputs = $('.otp-control').find('input')
      $(data).each(function(index) {
        $(inputs[index]).val(this)
      })
    });

    $(input).on('keyup', function(e) {

      if(e.keyCode === 8 || e.keyCode === 37) {
        var prev = $(container).prev().find('input');
        
        if(prev.length) {
          $(prev).select();
        }
      } else if((e.keyCode >= 48 && e.keyCode <= 57) || (e.keyCode >= 65 && e.keyCode <= 90) || (e.keyCode >= 96 && e.keyCode <= 105) || e.keyCode === 39) {
        var next = container.next().find('input');

        if(next.length) {
          $(next).select();
        } else {
          // $(container).closest('form').submit();
        }
      }
    });
  });
})
