import haxe.ds.StringMap;
import js.Browser.document;
import pixi.core.graphics.Graphics;
import pixi.core.math.Matrix;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import pixi.core.textures.RenderTexture;
import pixi.core.textures.Texture;

typedef ZoneI = { // naming conflict
	id:Int,
	list:Array<Array<Int>>,
	prc:Float
}

class Star extends Sprite {
	public var c:Float;
	public var dx:Float;
	public var dy:Float;
	public var fonce:Float;
}

class Map {
	public static var BW = 20;
	public static var BH = 18;
	public static var ZONE_MARGIN = 10;
	public static var itemList:Array<Int>;

	public var XMAX:Int; // map size in zones
	public var YMAX:Int;
	public var size:Int;
	static var WW = 0; // map size in pixels
	static var HH = 0;
	public static var SX = 0; // coordinates of top left corner
	public static var SY = 0;
	public var CX = 0; // map center coordinates
	public var CY = 0;

	public var spaceColors:StringMap<Int>;
	public var zoneTable:StringMap<Int>;
	public var seedTable:StringMap<Random>;
	public var levelTable:StringMap<Level>;

	public var bmpBg:RenderTexture;
	public var spaceLayer:Graphics;
	public var planetLayer:Graphics;
	public var frame:Rectangle;
	public var itemTex:Texture;

	var zones:Array<ZoneI>;
	var stars:Array<Star>;
	
	public function new(x:Int, y:Int) {
		size = 20;
		XMAX = 2 * size + 1;
		YMAX = XMAX;
		WW = XMAX * BW;
		HH = YMAX * BH;
		
		CX = x;
		CY = y;
		SX = CX - size;
		SY = CY - size;
		
		levelTable = new StringMap();
		frame = new Rectangle(0, 0, BW, BH);
		spaceLayer = new Graphics();
		spaceLayer.alpha = 0.5;
		
		// SEED TABLE
		seedTable = new StringMap();
		for (x in 0...XMAX + ZONE_MARGIN * 2) {
			for (y in 0...YMAX + ZONE_MARGIN * 2) {
				var px = x + SX - ZONE_MARGIN;
				var py = y + SY - ZONE_MARGIN;
				var n = Std.int(px * (1000 + py) + py);
				seedTable.set('$x,$y', new Random(n));
			}
		}
		
		// ZONE TABLE
		var id = 0;
		zones = [];
		zoneTable = new StringMap();

		for (zone in ZoneInfo.list) {
			if (isZoneIn(zone.pos)) {
				var zone:ZoneI = cast {
					id: id,
					list: ZoneInfo.getSquares(id)
				}
				zones.push(zone);
				for (p in zone.list) {
					var x = p[0] - SX;
					var y = p[1] - SY;
					zoneTable.set('$x,$y', id);
				}
			};
			id++;
		}
		
		bmpBg = RenderTexture.create(WW, HH);
		
		var base = new Graphics();
		base.beginFill(Main.COL_SPACE);
		base.drawRect(0, 0, WW, HH);
		Main.draw(bmpBg, base, new Matrix());
		
		var stars = [];
		var brushLight = Sprite.from(Main.textures.get('mcLuz'));
		brushLight.anchor.set(0.5, 0.5);
		brushLight.blendMode = pixi.core.Pixi.BlendModes.ADD;
		
		// CLOUDS
		for (px in 0...XMAX + 2 * ZONE_MARGIN) {
			for (py in 0...YMAX + 2 * ZONE_MARGIN) {
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
				if (x >= 0 && x < XMAX && y >= 0 && y < YMAX) {
					var max = seed.random(3);
					for (i in 0...max) {
						stars.push([(x + seed.rand()) * BW, (y + seed.rand()) * BH, 0.2 + seed.rand() * 0.3]);
					}
				}
			}
		}

		var px = untyped Main.app.renderer.plugins.extract.pixels(bmpBg);

		// GET COLORS
		spaceColors = new StringMap();
		for (x in 0...XMAX) {
			for (y in 0...YMAX) {
				var pix = Main.getPixel(px, Std.int(x + 0.5) * BW, Std.int(y + 0.5) * BH, 41 * BW);
				spaceColors.set('$x,$y', pix);
			}
		}

		// STARS
		var brushStar = Sprite.from(Main.textures.get('Star'));
		brushStar.anchor.set(0.5, 0.5);

		for (p in stars) {
			var sc = p[2];

			var m = new Matrix();
			m.scale(sc, sc);
			m.translate(p[0], p[1]);

			Main.draw(bmpBg, brushStar, m);
		}
		
		// ASTEROIDES
		
		// PLANETS
		for (zone in zones) {
			var zi = ZoneInfo.list[zone.id];
			var brush = Sprite.from(Main.textures.get('planet${zone.id}'));
			brush.anchor.set(0.5);
			var m = new Matrix();
			m.translate((zi.pos[0] - SX) * BW, (zi.pos[1] - SY) * BH);
			
			Main.draw(bmpBg, brush, m);
		}
		
		// MERCHANTS
		var shop = Sprite.from(Main.textures.get('merchant'));
		for (x in 0...XMAX) {
			for (y in 0...YMAX) {
				var wx = SX + x;
				var wy = SY + y;
				var dst = Math.sqrt(wx * wx + wy * wy);
				var seed = seedTable.get('${x + ZONE_MARGIN},${y + ZONE_MARGIN}');
				if (seed.random(Std.int(40 + Math.pow(dst, 1.4))) == 0) {
					var m = new Matrix();
					m.translate(x * BW, y * BH);
					Main.draw(bmpBg, shop, m);
				}
			}
		}
		
		// POWERUPS

		// ITEMS
		var items = [1, 2, 3, 7, 8, 9, 10, 11, 12, 13, 61, 62, 63, 64, 65, 66, 67, 68, 69, 71, 72, 73, 75, 76, 77, 79, 81, 87, 88, 89, 90, 92, 93, 97, 98, 99, 100, 101, 110];
		itemTex = Main.textures.get('mapIcons');
		var sIndex = 0;
		for (i in items) drawIcon(i, sIndex++); // the unique icons
		for (i in 18...58) drawIcon(i, 39); // missiles
		for (i in 82...86) drawIcon(i, 40); // antimatter nuclei
		for (i in 102...110) drawIcon(i, 41); // scrolls
		for (i in 114...126) drawIcon(i, 42); // tablets
		
		var pid = Sprite.from(Main.textures.get('pid'));
		for (i in 128...170) {
			// PID pieces
			var item = MissionInfo.ITEMS[i];
			if (item.x > SX && item.x < SX + XMAX && item.y > SY && item.y < SY + YMAX) {
				var m = new Matrix();
				m.translate((item.x - SX) * BW, (item.y - SY) * BH);
				Main.draw(bmpBg, pid, m);
			}
		}

		// LINES GRID //
		var bmp = new Graphics();
		var xOffset = CX % 5;
		var yOffset = CY % 5;
		bmp.beginFill(0xFFFFFF, 0.1);
		for (x in 0...XMAX)
			if ((x + xOffset) % 5 > 1) bmp.drawRect(x * BW, 0, 1, HH);
		for (y in 0...YMAX)
			if ((y + yOffset) % 5 > 1) bmp.drawRect(0, y * BH, WW, 1);
		
		bmp.beginFill(0xFFFFFF, 0.3); // stronger lines around coordinates divisible by 5
		for (x in 0...XMAX)
			if ((x + xOffset) % 5 <= 1) bmp.drawRect(x * BW, 0, 1, HH);
		for (y in 0...YMAX)
			if ((y + yOffset) % 5 <= 1) bmp.drawRect(0, y * BH, WW, 1);

		Main.draw(bmpBg, bmp, new Matrix());
	}
	
	public static function filerItems() {
		itemList = new Array();
		for (mission in MissionInfo.LIST) {
			for (item in mission.startItem) {
				if (item[0] > 0) if (item[1] == MissionInfo.VISIBLE || item[1] == MissionInfo.SURPRISE) itemList.push(Std.int(item[0]));
			}
			for (item in mission.endItem) {
				if (item[0] > 0) if (item[1] == MissionInfo.VISIBLE || item[1] == MissionInfo.SURPRISE) itemList.push(Std.int(item[0]));
			}
		}
	}

	public function getLevelMap() {
		for (x in 0...XMAX) {
			for (y in 0...YMAX) {
				var level = new Level(x + SX, y + SY, zoneTable.get('$x,$y'));
				levelTable.set('$x,$y', level);
				
				level.getBlockTypeStats();
				switch (level.mineralCount) {
					case 0:
						spaceLayer.beginFill(0xFF0000);
					case v if (v < 5):
						spaceLayer.beginFill(0xFF7F00);
					case v if (v < 10):
						spaceLayer.beginFill(0xFFFF00);
					case v if (v < 25):
						spaceLayer.beginFill(0x00FF00);
					case v if (v < 50):
						spaceLayer.beginFill(0x00FF7F);
					case v if (v < 100):
						spaceLayer.beginFill(0x00FFFF);
					case v if (v < 150):
						spaceLayer.beginFill(0x00AAFF);
					case v if (v < 200):
						spaceLayer.beginFill(0x0055FF);
					case v if (v < 300):
						spaceLayer.beginFill(0x0000FF);
					case v if (v < 400):
						spaceLayer.beginFill(0x3F00FF);
					case v if (v >= 400):
						spaceLayer.beginFill(0x7F00FF);
					default:
						spaceLayer.beginFill(0x000000, 0);
						trace('ERROR: mineralCount is ${level.mineralCount} at [${x + SX}][${y + SY}]');
				}
				spaceLayer.drawRect(x * BW, y * BH, BW, BH);
			}
		}
	}
	
	function isZoneIn(pos:Array<Int>) {
		if (pos[2] == 0)
			return false;

		var xMin = SX;
		var yMin = SY;
		var XMAX = SX + XMAX;
		var YMAX = SY + YMAX;

		if (pos.length == 3) {
			xMin -= pos[2];
			yMin -= pos[2];
			XMAX += pos[2];
			YMAX += pos[2];
		} else {
			xMin -= pos[2];
			yMin -= pos[3];
		}

		var x = pos[0];
		var y = pos[1];

		return x >= xMin && x < XMAX && y >= yMin && y < YMAX;
	}
	
	function drawIcon(id:Int, sIndex:Int) {
		var item = MissionInfo.ITEMS[id];
		if (item.x > SX && item.x < SX + XMAX && item.y > SY && item.y < SY + YMAX) {
			frame.y = sIndex * BH;
			itemTex.frame = frame;
			var icon = Sprite.from(itemTex);
			var m = new Matrix();
			m.translate((item.x - SX) * BW, (item.y - SY) * BH);
			Main.draw(bmpBg, icon, m);
		}
	}

	public function showLevel() {
		var level = levelTable.get('20,20');
		document.getElementById("pic_box").appendChild(level.getImage(spaceColors.get('20,20')));
	}
}
