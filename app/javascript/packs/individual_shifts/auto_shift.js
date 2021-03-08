$(function(){
    $(".pattern").click(function(){
       var pattern = $(this).attr("value");
       var time = pattern.split(",");
       var start = time[0]
       var finish = time[1]

       $('#individual_shift_start_4i').val(start);
       $('#individual_shift_finish_4i').val(finish);
    })
})    