$(function() {
    $('.question_txt').on("click", function() {
        var id = $(this).data('hoge');
        $("#toggle_" + id).slideToggle(); 
        $("#toggle_" + id).toggleClass("active"); 
        if($(this).next('.show_button').hasClass("closebutton")){
           $(this).next('.show_button').removeClass("closebutton");
        }else{
           $(this).next('.show_button').addClass("closebutton");
        }
    });
 });
 