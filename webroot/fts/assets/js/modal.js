/*
* modal.js
* Modal Pages for fts
*
* Created by yiqiang on 2019/04/02.
* Copyright © 2019年 yiqiang. All rights reserved.
*/

(function(t) { 
	'use strict'

    function e(r) {
        this.o = t.extend({}, t.fn[o].defaults, r), this.init()
    }
    let o = "modal"
    e.prototype = {
        init: function() {
            let e = this
            e.type = e.o.type
            e.parent = e.o.parent
            e.build()
        },
        build: function() {
            let e = this
            if(e.type == "markdown") {
                $(e.parent).append(e.templates.markdown)
            }
        },
        destory: function(){
            let e = this
            if(e.type == "markdown") { $('.c-modal--markdown').remove() }
        },
        append: function(b) {
            let e = this
            if(e.type == "markdown") { $('.c-modal.c-modal--markdown > .c-modal__content').html(b) }
        },
        templates: {
            markdown: '<div class="c-modal c-modal--markdown"><div class="c-modal__content"></div></div>'
        }
    },
    t.fn[o] = function(r) {
        t.fn[o].defaults.parent = $(this)
        return new e(r)
    },
    t.fn[o].defaults = {
    	type: "modal",     //markdown
        parent: $("body")
    }
})(jQuery)