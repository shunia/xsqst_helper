package {

    import flash.display.Sprite;

import me.shunia.xsqst_helper.Service;
import me.shunia.xsqst_helper.User;
import me.shunia.xsqst_helper.utils.Timer;

    public class Main extends Sprite {

        public function Main() {
            Global.service = new Service();
            Global.user = new User();

            var ui:UI = new UI();
            addChild(ui);
            Global.ui = ui;
        }

        private function use_food(foodid:int):void {
            Global.service.on("use_food", function (data:Object):void {
                Global.user.hunger += data.count;
            }, foodid);
        }

    }
}
