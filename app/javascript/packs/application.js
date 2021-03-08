// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("bootstrap");
require("@fortawesome/fontawesome-free");

import '@fortawesome/fontawesome-free/js/all';
import "../stylesheets/application.scss";


$(function(){
    $("#open").click(function(){
            $("#menu").css("right","0px");    
    })

    $("#close").click(function(){
            $("#menu").css("right","-370px")
    })

    $("#copy").click(function(){
        var copyTarget = document.getElementById("CopyTarget");

        // コピー対象のテキストを選択する
        copyTarget.select();

        // 選択しているテキストをクリップボードにコピーする
        document.execCommand("Copy");

        // コピーをお知らせする
        alert("コピーできました！");
    })

    $("#navi-open").click(function(){
        $("#navi").css("left","0px");    
    })

    $("#navi-close").click(function(){
        $("#navi").css("left","-290px");
    })


})  


