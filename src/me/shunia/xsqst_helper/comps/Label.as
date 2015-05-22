/**
 * Created by qingfenghuang on 2015/5/21.
 */
package me.shunia.xsqst_helper.comps {
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class Label extends TextField {
    public function Label(autoResize:Boolean = true) {
        this.text = "";
        if (autoResize) this.autoSize = TextFieldAutoSize.LEFT;
        this.multiline = true;
        this.wordWrap = true;
        var fmt:TextFormat = new TextFormat();
        fmt.color = 0;
        fmt.font = "Microsoft YaHei";
        this.defaultTextFormat = fmt;
    }
}
}
