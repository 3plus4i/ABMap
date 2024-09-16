import haxe.ds.StringMap;
import js.Browser.document;
import js.lib.Promise;
import pixi.core.Application;
import pixi.core.display.DisplayObject;
import pixi.core.math.Matrix;
import pixi.core.sprites.Sprite;
import pixi.core.textures.RenderTexture;
import pixi.core.textures.Texture;

@:expose("Main")
class Main {
	public static var COL_SPACE = 0x000050;

	public static var app:Application;
	public static var map:ABMap;
	
	public static var textures:StringMap<Texture>;
	
	public static function main() {
		app = new Application({ width: 820, height: 738 });
		document.getElementById("map_data").appendChild(app.view);
		
		textures = new StringMap();
		var preload = ['mcLuz', 'Star', 'wurmhole', 'merchant', 'pid', 'mapIcons'];
		for (i in 0...ZoneInfo.list.length) preload.push('planet$i');
		
		Promise.all(preload.map(n -> {
			return (untyped Texture).fromURL('https://3plus4i.github.io/ABMap/images/sprites/$n.png').then(t -> {
				return {name: n, texture: t};
			});
		})).then((loaded:Array<{name:String, texture:Texture}>) -> {
			for (t in loaded) {
				textures.set(t.name, t.texture);
			}
			init();
		});
	}
	
	public static function init() {
		map = new Map(0, 0);
		app.stage.addChild(new Sprite(map.bmpBg));
	}

	public static function close_welcome() {
		document.getElementById("welcome").style.display = 'none';
		//document.cookie = 'abmap_welcome=1; expires=' + expires2;
	}
	
	static public function draw(onto:RenderTexture, object:DisplayObject, matrix:Matrix) {
		(untyped app.renderer).render(object, cast {renderTexture: onto, clear: false, transform: matrix});
	}

	static public function objToCol(o) {
		return (o.r << 16) | (o.g << 8) | o.b;
	}
}
