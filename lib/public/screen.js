function replaceSrc(){
  var resultUrl = '?src=' + $('#src-img').val();
  $('#result-url').val(location + resultUrl);
  $('#result-image').attr('src', resultUrl);
}

$(function(){
  replaceSrc();
  $('#src-img').change(replaceSrc);
});

