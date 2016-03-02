$(document).ready(function(){
  $('.card-title').on('click',function(){
    $(this).closest('.card').toggleClass('small').toggleClass('large');
  });
});
