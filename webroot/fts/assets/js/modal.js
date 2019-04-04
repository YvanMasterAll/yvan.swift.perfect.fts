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
    let o = "modal"             //alias
    e.prototype = {
        init: function() {
            let e = this
            e.type = e.o.type
            e.parent = e.o.parent
            e.render()
        },
        remains: {},
        render: function() {
            let e = this
            if(e.type == "markdown") {
                e.templates.markdown().then(html => {
                    $(e.parent).append(html)
                    $('.c-modal.c-modal--markdown .c-button--close').on('click', function() {
                        e.destory()
                    })
                    $.each(e.remains, function(i, v) { v() })
                    e.remains = {}
                })
            }
        },
        destory: function(){
            let e = this
            if(e.type == "markdown") { $('.c-modal--markdown').remove() }
        },
        append: function(b) {   //hook
            let e = this
            if(e.type == "markdown") { e.remains.append = () => $('.c-modal.c-modal--markdown .c-modal__content').html(b) }
        },
        templates: {
            markdown: function() {
                let e = this
                return new Promise(function(r, j) {
                    e.get("/assets/templates/modal_markdown.template", r, j)
                })
            },
            get: (p, r, j) => {
                $.ajax({
                    url: p,
                    type: "get",
                    dataType: "html",
                    cache: false,
                    complete:function(XMLHttpRequest, textStatus){
                        var html = XMLHttpRequest.responseText
                        r(html)
                    },
                    error:function(XmlHttpRequest, textStatus, errorThrown){
                        j()
                    }
                })
            }
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