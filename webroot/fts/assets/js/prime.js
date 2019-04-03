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
	e: null,
	result: {						//网络请求结果管理
		valid: function(code) {		//判断请求结果
			return code == 200
		},
		msg: function(code, msg) {	//响应信息
			if(code == undefined) { return msg }
			return msg == undefined ? this._msg[code]:msg
		},
		_msg: {						
			200: '请求成功'
		}
	}
}

fts = new _fts();