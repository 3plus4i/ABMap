import haxe.ds.StringMap;
import js.Browser.document;
import js.lib.Promise;
import js.lib.Uint8Array;
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
	public static var map:Map;
	
	public static var textures:StringMap<Texture>;
	
	public static function main() {
		app = new Application({ width: 820, height: 738 });
		document.getElementById("map_data").appendChild(app.view);
		
		textures = new StringMap();
		var preload = ['mcLuz', 'Star', 'wurmhole', 'merchant', 'pid', 'mapIcons', 'mcShape'];
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
		Map.filerItems();
		map = new Map(0, 0);
		app.stage.addChild(new Sprite(map.bmpBg));
		map.getLevelMap();
		app.stage.addChild(map.spaceLayer);
	}

	public static function close_welcome() {
		document.getElementById("welcome").style.display = 'none';
		//document.cookie = 'abmap_welcome=1; expires=' + expires2;
	}

	// mt.Lib
	static public function objToCol(o) {
		return (o.r << 16) | (o.g << 8) | o.b;
	}

	static public function sMod(n:Float, mod:Float) {
		if (mod == 0 || mod == null || n == null)
			return null;
		while (n >= mod)
			n -= mod;
		while (n < 0)
			n += mod;
		return n;
	}

	static public function hMod(n:Float, mod:Float) {
		if (mod == 0 || mod == null || n == null)
			return null;
		while (n > mod)
			n -= mod * 2;
		while (n < -mod)
			n += mod * 2;
		return n;
	}

	// PixelHelper
	
	static public function draw(onto:RenderTexture, object:DisplayObject, matrix:Matrix) {
		(untyped app.renderer).render(object, cast {renderTexture: onto, clear: false, transform: matrix});
	}
	static public function getPixel(pixels:Uint8Array, x:Int, y:Int, width:Int):Int {
		var pIndex = (y * width + x) * 4;

		return pixels[pIndex] << 16 | pixels[pIndex + 1] << 8 | pixels[pIndex + 2];
	}
}
