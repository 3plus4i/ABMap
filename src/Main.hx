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
import pixi.interaction.InteractionEvent;

@:expose("Main")
class Main {
	public static var COL_SPACE = 0x000050;

	public static var app:Application;
	public static var map:Map;
	
	public static var textures:StringMap<Texture>;
	public static var currentLevel:String;
	
	public static function main() {
		app = new Application({ width: 820, height: 738 });
		document.getElementById("map_data").appendChild(app.view);

		app.stage.interactive = true;
		app.stage.buttonMode = true;

		document.getElementById("data_box").innerHTML = '';

		textures = new StringMap();
		var preload = ['mcLuz', 'Star', 'wurmhole', 'merchant', 'pid', 'mapIcons', 'mcShape', 'mcBrush', 'baseBlocks', 'blocks', 'asteroide'];
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
		moveMap(0, 0);
	}

	public static function close_welcome() {
		document.getElementById("welcome").style.display = 'none';
		app.stage.on("pointermove", setLevel);
		app.stage.on("pointerup", mapClick);
		//document.cookie = 'abmap_welcome=1; expires=' + expires2;
	}

	public static function setLevel(e:InteractionEvent) {
		var pos = app.stage.toLocal(e.data.global, app.stage);
		var box = document.getElementById("infobox");
		if (pos.x >= 0 && pos.x < app.stage.width && pos.y >= 0 && pos.y < app.stage.height) {
			var x = Std.int(pos.x / Map.BW);
			var y = Std.int(pos.y / Map.BH);
			var level = '$x,$y';

			if (currentLevel != level) {
				map.showLevel(x, y);
				currentLevel = level;
				var text = '[${x + map.SX}][${y + map.SY}]';
				var level = map.levelTable.get('$x,$y');
				var planet = level.zid;
				if (planet != null) text += ' ${ZoneInfo.list[planet].name}';
				box.innerHTML = text;
				document.getElementById("title_box").innerHTML = text;
				document.getElementById("mineral_box").innerHTML = '${level.mineralCount} ';
				document.getElementById("mineral").style.display = 'inline-block';
			}
			box.style.left = '${e.data.global.x + 20}px';
			box.style.top = '${e.data.global.y + 20}px';
			box.style.display = 'block';
		} else box.style.display = 'none';
	}

	public static function mapClick(e:InteractionEvent) {
		var pos = app.stage.toLocal(e.data.global, app.stage);
		if (pos.x >= 0 && pos.x < app.stage.width && pos.y >= 0 && pos.y < app.stage.height) 
			moveMap(Std.int(pos.x / Map.BW) + map.SX, Std.int(pos.y / Map.BH) + map.SY);
	}

	public static function moveMap(x:Int, y:Int) {
		app.stage.removeChildren();
		document.getElementById("pic_box").innerHTML = "";
		document.getElementById("title_box").innerHTML = "";
		document.getElementById("mineral_box").innerHTML = "";
		document.getElementById("mineral").style.display = 'none';
		document.getElementById("infobox").style.display = 'none';

		map = new Map(x, y);
		app.stage.addChild(new Sprite(map.bmpBg));
		map.getLevelMap();
		app.stage.addChild(map.spaceLayer);
		document.querySelector("title").innerHTML = 'AlphaBounce - &raquo; The Map &laquo; - [$x][$y]';
	}

	// mt.Lib
	static public function colToObj(col) {
		return {
			r: col >> 16,
			g: (col >> 8) & 0xFF,
			b: col & 0xFF
		};
	}

	static public function objToCol(o) {
		return (o.r << 16) | (o.g << 8) | o.b;
	}

	static public function setPercentColor(mc:pixi.core.sprites.Sprite, prc:Float, col, ?inc:Float, ?alpha = 100) {
		if (prc == 0) {
			mc.tint = 0xFFFFFF;
			return;
		}

		trace("FIXME");
		if (inc == null)
			inc = 0;
		var color = colToObj(col);
		var c = prc / 100;
		var ct = {_: null};
		var ct = {
			r: Std.int(c * color.r + inc),
			g: Std.int(c * color.g + inc),
			b: Std.int(c * color.b + inc),
		};
		setColor(mc, objToCol(ct));
	}

	static public function setColor(mc, col, ?dec) {
		mc.tint = col;
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
