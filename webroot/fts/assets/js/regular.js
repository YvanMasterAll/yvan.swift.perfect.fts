/*
* regular.js
* Application scripts for fts, it controls global layout options and implements of plugins.
*
* Created by yiqiang on 2019/04/02.
* Copyright © 2019年 yiqiang. All rights reserved.
*/

//Make sure jQuery has been loaded before regular.js.
if (typeof jQuery === "undefined") {
  throw new Error("Application requires jQuery")
}

//MARK: - Application Object
$.Fts = {}

$.Fts.options = {}

$(function () {
    "use strict";

    _init();
})

function _init() {
    let o = $.Fts.options;
    //TODO: Implement Fts Methods
}


