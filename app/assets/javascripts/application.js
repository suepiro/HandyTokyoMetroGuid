// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .
//= require underscore
//= require gmaps/google
//= require pickadate
$(function(){
  $('#start_gps').click(function(){
    navigator.geolocation.watchPosition(
      function(position){
        $('#latitude').html(position.coords.latitude); //緯度
        $('#longitude').html(position.coords.longitude); //経度

        }
    );
  });
//  $(document).ready($(function() {
 //       $('.date').pickadate()
//  }));
});
