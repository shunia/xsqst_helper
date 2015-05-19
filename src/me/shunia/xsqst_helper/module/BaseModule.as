/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {

public class BaseModule {
    public function BaseModule() {
    }

    public function sync(cb:Function = null):void {

    }

    public function start():void {

    }

    protected function _c(cb:Function = null):void {
        if (cb != null) cb();
    }
}
}
