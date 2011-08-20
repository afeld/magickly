var Magickly = {
  $inputUrl: undefined,
  $resultUrl: undefined,
  $resultImage: undefined,
  
  queryParams: {},
  
  init: function(){
    this.$inputUrl = $('#input-url');
    this.$resultUrl = $('#result-url');
    this.$resultImage = $('#result-image');
    
    $('input.effect[type="checkbox"]').change( $.proxy(this.onEffectToggle, this) );
  },
  
  updateResultUrl: function(){
    var newSrc = window.location.href + '?src=' + this.$inputUrl.val(),
      queryString = $.param(this.queryParams);
    
    if (queryString){
      newSrc += '&' + queryString;
    }
    
    this.$resultImage.attr('src', newSrc);
    this.$resultUrl.val(newSrc);
  },
  
  onEffectToggle: function(e){
    var $checkbox = $(e.currentTarget),
      effect = $checkbox.attr('name');
    
    if ($checkbox.is(':checked')){
      this.queryParams[effect] = true;
    } else {
      delete this.queryParams[effect];
    }
    
    this.updateResultUrl();
  }
}

$(function(){
  Magickly.init();
});
