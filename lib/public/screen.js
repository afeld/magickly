function replaceSrc(){
  $('#result-image').attr('src', '?src=' + $('#src-img').val());
}

$(function(){
  replaceSrc();
  $('#src-img').change(replaceSrc);
});

