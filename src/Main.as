package {

import flash.display.Sprite;
import flash.text.TextField;

public class Main extends Sprite {

    private var _service:Service = null;

    public function Main() {
        var textField:TextField = new TextField();
        textField.text = "Hello, World";
        addChild(textField);

        _service = new Service();
        _service.on("sync_mine_dig_num", function (data:Object):void {

        });
    }
}
}
