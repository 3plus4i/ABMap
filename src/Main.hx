import js.Browser.document;
import pixi.core.Application;
import pixi.core.display.DisplayObject;
import pixi.core.math.Matrix;
import pixi.core.textures.RenderTexture;

@:expose("Main")
class Main {
	public static var COL_SPACE = 0x000050;

	public static var app:Application;
	public static var map:ABMap;
	
	public static function main() {
		app = new Application({ width: 820, height: 738 });
		document.getElementById("map_data").appendChild(app.view);
		
		app.loader.baseUrl = 'images';
		app.loader.add('mcLuz', 'sprites/mcLuz.png')
			.add('Star', 'sprites/Star.png');
		app.loader.once('complete', init);
		app.loader.load();
	}
	
	public static function init() {
		map = new ABMap(0, 0);
		app.stage.addChild(cast map.bmpBg);
	}
	
	static public function draw(onto:RenderTexture, object:DisplayObject, matrix:Matrix) {
		(untyped app.renderer).render(object, cast {renderTexture: onto, clear: false, transform: matrix});
	}

	static public function objToCol(o) {
		return (o.r << 16) | (o.g << 8) | o.b;
	}
}
