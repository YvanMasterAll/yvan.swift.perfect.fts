/*
* prime.js
* Prime scripts for fts, it controls pages' interactions.
*
* Created by yiqiang on 2019/04/02.
* Copyright © 2019年 yiqiang. All rights reserved.
*/

//MARK: - Global Object
function _fts(){
	this.e = this
}

let fts = {}

_fts.prototype = {
	e: this
}

fts.set = new _fts();