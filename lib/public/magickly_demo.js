var Magickly = {
  $inputUrl: undefined,
  $resultUrl: undefined,
  $resultImage: undefined,
  
  inputUrl: undefined,
  
  queryParams: {},
  
  init: function(){
    this.$inputUrl = $('#input-url');
    this.$resultUrl = $('#result-url');
    this.$resultImage = $('#result-image');
    
    this.inputUrl = this.$inputUrl.val();
    
    this.$inputUrl.bind('paste', $.proxy(this.onSourceUrlEvent, this) );
    this.$inputUrl.keydown( $.proxy(this.onSourceUrlKeydown, this) );
    this.$inputUrl.change( $.proxy(this.onSourceUrlEvent, this) );
    $('input.effect[type="checkbox"]').change( $.proxy(this.onEffectToggle, this) );
    
    $('#halftone-slider').slider({
      value: 50,
      change: function(e, ui){
        Magickly.queryParams.halftone = ui.value;
        $(this).siblings('input[type="checkbox"]').attr('checked', 'true');
        Magickly.updateResultUrl.call(Magickly);
      }
    });
  },
  
  updateResultUrl: function(){
    var newSrc = window.location.href + '?src=' + this.inputUrl,
      queryString = $.param(this.queryParams);
    
    if (queryString){
      newSrc += '&' + queryString;
    }
    
    this.$resultImage.attr('src', newSrc);
    this.$resultUrl.val(newSrc);
  },
  
  onSourceUrlKeydown: function(e){
    if (e.which === 13){
      // ENTER key
      this.$inputUrl.blur();
    }
  },
  
  onSourceUrlEvent: function(){
    var newInputUrl = this.$inputUrl.val();
    if (newInputUrl !== this.inputUrl){
      this.inputUrl = newInputUrl;
      this.updateResultUrl();
    }
  },
  
  onEffectToggle: function(e){
    var $checkbox = $(e.currentTarget),
      effect = $checkbox.attr('name');
    
    if ($checkbox.is(':checked')){
      if ($checkbox.hasClass('slider-toggle')){
        var $slider = $('#' + effect + '-slider');
          sliderVal = $slider.slider('value');
        
        if (sliderVal === $slider.slider('option', 'value')){
          // default value
          this.queryParams[effect] = 'true';
        } else {
          this.queryParams[effect] = $slider.slider('value');
        }
      }
    } else {
      delete this.queryParams[effect];
    }
    
    this.updateResultUrl();
  }
}

$(function(){
  Magickly.init();
});
