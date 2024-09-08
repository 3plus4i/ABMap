import haxe.ds.StringMap;
import pixi.core.graphics.Graphics;
import pixi.core.math.Matrix;
import pixi.core.sprites.Sprite;
import pixi.core.textures.RenderTexture;

class Star extends Sprite {
	public var c:Float;
	public var dx:Float;
	public var dy:Float;
	public var fonce:Float;
}

class ABMap {
	public static var BW = 20;
	public static var BH = 18;
	public static var ZONE_MARGIN = 10;
	
	public var xmax:Int; // map size in zones
	public var ymax:Int;
	public var size:Int;
	static var WW = 0; // map size in pixels
	static var HH = 0;
	public static var SX = 0; // coordinates of top left corner
	public static var SY = 0;
	public var CX = 0; // map center coordinates
	public var CY = 0;
	
	public var bmpBg:RenderTexture;
	public var seedTable:StringMap<Random>;
	var stars:Array<Star>;
	
	public function new(x:Int, y:Int) {
		size = 20;
		xmax = 2 * size + 1;
		ymax = xmax;
		WW = xmax * BW;
		HH = ymax * BH;
		
		CX = x;
		CY = y;
		SX = CX - size;
		SY = CY - size;
		
		// SEED TABLE
		seedTable = new StringMap();
		for (x in 0...xmax + ZONE_MARGIN * 2) {
			for (y in 0...ymax + ZONE_MARGIN * 2) {
				var px = x + SX - ZONE_MARGIN;
				var py = y + SY - ZONE_MARGIN;
				var n = Std.int(px * (1000 + py) + py);
				seedTable.set('$x,$y', new Random(n));
			}
		}
		
		bmpBg = RenderTexture.create(WW, HH);
		
		var base = new Graphics();
		base.beginFill(Main.COL_SPACE);
		base.drawRect(0, 0, WW, HH);
		Main.draw(bmpBg, base, new Matrix());
		
		var stars = [];
		var brushLight = Sprite.from(Main.app.loader.resources['mcLuz'].texture);
		brushLight.anchor.set(0.5, 0.5);
		brushLight.blendMode = pixi.core.Pixi.BlendModes.ADD;
		
		// CLOUDS
		for (px in 0...xmax + 2 * ZONE_MARGIN) {
			for (py in 0...ymax + 2 * ZONE_MARGIN) {
				var x = px - ZONE_MARGIN;
				var y = py - ZONE_MARGIN;

				x -= 5;

				// CLOUD
				var sc = 5;
				var seed = seedTable.get('${x + ZONE_MARGIN},${y + ZONE_MARGIN}');
				if (seed != null && seed.random(70) == 0) {
					var bi = 5;
					var ri = 90; // 50
					var o = {
						r: bi + seed.random(ri),
						g: bi + seed.random(ri),
						b: bi + seed.random(ri)
					}

					var m = new Matrix();
					m.scale((0.5 + seed.rand()) * sc, (0.5 + seed.rand()) * sc);
					m.translate(x * BW, y * BH);
					brushLight.tint = Main.objToCol(o);

					Main.draw(bmpBg, brushLight, m);
				}

				// STARS
				if (x >= 0 && x < xmax && y >= 0 && y < ymax) {
					var max = seed.random(3);
					for (i in 0...max) {
						stars.push([(x + seed.rand()) * BW, (y + seed.rand()) * BH, 0.2 + seed.rand() * 0.3]);
					}
				}
			}
		}

		var brushStar = Sprite.from(Main.app.loader.resources['Star'].texture);
		brushStar.anchor.set(0.5, 0.5);

		for (p in stars) {
			var sc = p[2];

			var m = new Matrix();
			m.scale(sc, sc);
			m.translate(p[0], p[1]);

			Main.draw(bmpBg, brushStar, m);
		}
	}
}
