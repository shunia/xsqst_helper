/**
 * Created by qingfenghuang on 2015/5/21.
 */
package me.shunia.xsqst_helper.comps {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Label extends TextField {
	    public function Label(autoResize:Boolean = true) {
	        if (autoResize) this.autoSize = TextFieldAutoSize.LEFT;
	        var fmt:TextFormat = new TextFormat();
	        fmt.color = 0;
	        fmt.font = "Microsoft YaHei";
	        this.defaultTextFormat = fmt;
			this.text = "";
	    }
	}
}
