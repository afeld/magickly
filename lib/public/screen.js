function updateResult(){
  var resultUrl = '?' + $('#params').val() + '&src=' + $('#src-img').val();
  $('#result-url').val(location + resultUrl);
  $('#result-image').attr('src', resultUrl);
}

$(function(){
  updateResult();
  $('#src-img').change(updateResult);
  $('#params').change(updateResult);
});

