/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {
import me.shunia.xsqst_helper.User;

public class BaseModule {

    protected var _context:User = null;

    public function BaseModule() {

    }

    public function setContext(context:User):BaseModule {
        _context = context;
        return this;
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
