import haxe.ds.IntMap;
import haxe.ds.StringMap;
import js.html.ImageElement;
import js.lib.Uint8Array;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.core.math.Matrix;
import pixi.core.math.shapes.Rectangle;
import pixi.core.Pixi.BlendModes;
import pixi.core.sprites.Sprite;
import pixi.core.textures.RenderTexture;

class Level {
	static public var NEVER = 50000;

	static inline public var PB_STEEL_BAR = 0;
	static inline public var PB_STEEL_CLOUD = 1;
	static inline public var PB_PUSHER = 2;
	static inline public var PB_BOOM = 3;
	static inline public var PB_JUMPER = 4;
	static inline public var PB_STORM = 5;
	static inline public var PB_CAGE = 6;
	static inline public var PB_GENERATOR = 7;
	static inline public var PB_DRAGON = 8;
	static inline public var PB_MISSILE = 9;
	static inline public var PB_DOOR = 10;
	static inline public var PB_KILL = 11;
	static inline public var PB_DEATH = 12;

	// constants from Block.hx
	public static inline var MIN_GREEN = 1;
	public static inline var MIN_BLUE = 5;
	public static inline var MIN_PINK = 25;

	public static inline var BONUS_MAX = 3;
	public static inline var MOLECULE_MAX = 10;

	public static inline var BONUS = 10;
	public static inline var BONUS2 = 11;
	public static inline var BONUS3 = 12;
	public static inline var BALL = 13;
	public static inline var BOOM = 14;
	public static inline var SPACE = 15;
	public static inline var REDUC = 16;
	public static inline var STEEL = 17;
	public static inline var PUSHER = 18;
	public static inline var JUMPER = 19;
	public static inline var STORM = 20;
	public static inline var ITEM = 21;
	public static inline var CAGE = 22;
	public static inline var GENERATOR = 32;
	public static inline var LURE = 42;
	public static inline var DRAGON_LEFT = 43;
	public static inline var DRAGON_RIGHT = 44;
	public static inline var INSECT = 45;
	public static inline var SWAP = 46;
	public static inline var MISSILE = 47;
	public static inline var DOOR = 48;
	public static inline var DEPLETED = 49;

	public static inline var NUT = 50;
	public static inline var KILL = 51;
	public static inline var LIFE = 52;
	public static inline var DEATH = 53;
	public static inline var GLUE = 54;
	public static inline var GUARDIAN = 55;
	public static inline var MINE = 56;
	
	public static var DIR = [[1, 0], [0, 1], [-1, 0], [0, -1]];

	//public var flEdit:Bool;
	public var flLure:Bool;

	public var wx:Int;
	public var wy:Int;
	public var zid:Int;
	public var item:Bool;

	public var dst:Float;
	public var ang:Float;
	public var lvl:Int;
	public var ymax:Int;

	public var struct:StringMap<Int>;

	public var seed:mt.OldRandom;

	public var proba:Array<Int>;
	public var bonusTable:StringMap<Int>;

	public var blockCol:Uint8Array;
	public var model:StringMap<Int>;
	public var distances:Array<Float>;
	
	public var blockStats:IntMap<{count:Int}>;
	public var mineralCount:Int;
	public var screenshot:ImageElement;

	public function new(x:Int, y:Int, id:Int) {
		wx = x;
		wy = y;
		zid = id;
		
		seed = new mt.OldRandom(wx * 10000 + wy);
		distances = [];
		for (zone in ZoneInfo.list) {
			var dx = x - zone.pos[0];
			var dy = y - zone.pos[1];
			distances.push(Math.sqrt(dx * dx + dy * dy));
		}

		dst = Math.sqrt(x * x + y * y);
		ang = Math.atan2(y, x);

		lvl = Std.int(Math.pow(dst * 0.1, 0.5));
		ymax = Std.int(Math.min(12 + lvl, 17));
		
		initProba();
		
		genModel();
	}

	function initProba() {
		proba = [];

		var NEVER = 100000.0;

		for (i in 0...30) {
			var n = NEVER;
			switch (i) {
				case PB_STEEL_BAR:
					n = Math.max(5 - (dst / 200), 2);
					if (distances[ZoneInfo.SOUPALINE] < 12)
						n = 1000;
					n *= Math.min(distances[ZoneInfo.MOLTEAR] / 50, 1);

				case PB_STEEL_CLOUD:
					n = 5;
					if (zid == ZoneInfo.SOUPALINE)
						n = NEVER;

				case PB_PUSHER:
					n = 12;
					if (dst < 6)
						n = NEVER;
					else if (dst < 20)
						n = 40;

				case PB_BOOM:
					n = 12;
					if (dst < 4)
						n = NEVER;
					if (wy < 0 || wx < 0)
						n += dst * 0.5;
					if (zid == ZoneInfo.LYCANS)
						n = 1;

				case PB_JUMPER:
					if (distances[ZoneInfo.KARBONIS] < 100 && dst > 10)
						n = 40;

				case PB_STORM:
					if (dst > 30)
						n = Math.max(60 - dst * 0.5, 4);

				case PB_CAGE:
					if (dst > 15)
						n = Math.max(50 - dst, 3);

				case PB_GENERATOR:
					if (dst > 20)
						n = Math.max(100 - dst * 0.5, 12);

				case PB_DRAGON:
					if (wy > 10)
						n = 10;
					var lim = 30;
					if (distances[ZoneInfo.POFIAK] < lim)
						n = 1 + (distances[ZoneInfo.POFIAK] / lim) * 10;

				case PB_MISSILE:
					if (dst > 4)
						n = Math.min(3 + dst * 0.1, 20);
					if (zid == ZoneInfo.LYCANS)
						n = 2;
				// if( zid == ZoneInfo.SOUPALINE ) n = NEVER;

				case PB_DOOR:
					if (dst > 13 && dst < 18)
						n = 7;
					if (dst > 58)
						n = 16;

				case PB_KILL:
					if (dst > 80) {
						n = Math.max(3, 80 * Math.abs(Main.hMod(ang - 2.504, 3.14)));
					}

				case PB_DEATH:
					if (dst > 40) {
						n = Math.max(2, 100 - Math.pow(dst * 10, 0.5));
					}

				default:
					break;
			}
			// trace("proba["+i+"] = "+n);
			proba[i] = Math.floor(n);
		}
	}

	function genModel() {
		/*// ITEM
		var id = 0;
		for (n in Cs.pi.items) {
			var item = MissionInfo.ITEMS[id];
			if (item.x == wx && item.y == wy) {
				item = True;
				break;
			}
			id++;
		}*/

		// MOLECULES LIST

		// GENERATION
		if (struct == null) {
			var to = 0;
			while (true) {
				genPrimeModel();
				var goal = getGoal();
				if (goal > 12 && isModelOpen(goal) && goal < (lvl + 1) * 100)
					break;
				if (to++ > 12) {
					forceModel();
					break;
				}
			}

			// PLACE MOLS
			var mols = [];
			while (mols.length < 20) {
				var max = 1 + seed.random(10);
				var n = Molecule.getRandomMolType(seed);
				for (i in 0...max)
					mols.push(n);
			}
			var mi = 0;
			for (x in 0...14) {
				for (y in 0...23) {
					var n = model.get('${x},${y}');
					if (n == CAGE || n == GENERATOR) {
						mi = (mi + 1) % mols.length;
						model.set('${x},${y}', n + mols[mi]);
					}
				}
			}
		} else {
			genStruct();
		}

		// trace(itemId+";"+Cs.pi.items[itemId]);
	}

	function genPrimeModel() {
		flLure = false;

		// PARAMS
		var flMirror = seed.random(2) == 0;
		var flMirrorPalette = seed.random(2) == 0 && flMirror;
		var density = 1 + 3 / (lvl + 1);

		var bmp = RenderTexture.create(14, 23);

		// MASSE
		var brush = Main.textures.get('mcShape');
		var frame = new Rectangle(0, 0, 101, 101);
		var sc = 0.06;
		var ma = -2;
		var max = Std.int(4 + lvl);
		for (i in 0...max) {
			var m = new Matrix();
			// m.rotate(seed.rand()*6.28);
			var scc = (sc * (1 + seed.rand() * 0.5));
			m.scale(scc, scc);
			m.translate(ma + seed.random(14 - 2 * ma), ma + seed.random(ymax - 2 * ma));
			frame.y = 101 * seed.random(13);
			brush.frame = frame;
			var shape = Sprite.from(brush);

			Main.draw(bmp, shape, m);
		}

		var pixels = untyped Main.app.renderer.plugins.extract.pixels(bmp);

		// FILL
		model = new StringMap();

		// ymax = 23;
		for (x in 0...14) {
			for (y in 0...ymax) {
				if (Main.getPixel(pixels, x, y, 14) != 0) {
					model.set('${x},${y}', 0);
				}
			}
		}

		// LINE
		var max = lvl;
		if (zid == ZoneInfo.DOURIV || zid == ZoneInfo.GRIMORN)
			max = 0;

		for (i in 0...max) {
			var lim = 4;
			var list = getHoriLine(2 + seed.random((ymax - 2)), 0.05, 0);
			for (p in list) {
				if (model.get('${p[0]},${p[1]}') < 5) {
					model.set('${p[0]},${p[1]}', model.get('${p[0]},${p[1]}') + 1);
				}
			}
		}

		// DIG
		while (lvl >= 0 && seed.random(2) == 0) {
			var m = 3;
			var di = seed.random(4);
			var sx = m + seed.random(14 - (2 * m));
			var sy = m + seed.random(ymax - (2 * m));
			while (true) {
				var bl = model.get('${sx},${sy}');
				if (sx >= 0 && sx < 14 && sy >= 0 && sy < ymax) {
					model.set('${sx},${sy}', null);
					var d = DIR[di];
					sx += d[0];
					sy += d[1];
					if (seed.random(4) == 0) {
						di = Std.int(Main.sMod(di + (seed.random(2) * 2 - 1), 4));
					}
				} else {
					break;
				}
			}
		}

		// BORDER
		var brd = seed.random(lvl + 1);
		// if( Math.max(Math.abs(wx),Math.abs(wy)) == 3 )brd = 1;
		if (zid == ZoneInfo.DOURIV || zid == ZoneInfo.GRIMORN || zid == ZoneInfo.CILORILE)
			brd = 0;
		if (brd > 0) {
			var inc = 1;
			if (brd > 2)
				inc++;
			if (brd > 4)
				inc++;

			for (x in 0...14) {
				for (y in 0...ymax) {
					if (model.get('${x},${y}') < 5) {
						for (d in DIR) {
							var nx = x + d[0];
							var ny = y + d[1];
							if (nx >= 0 && nx < 14 && ny >= 0 && ny < ymax + 1 && model.get('${nx},${ny}') == null) {
								model.set('${x},${y}', Std.int(Math.min(model.get('${x},${y}') + inc, 5)));
								break;
							}
						}
					}
				}
			}
		}

		// FOSSE
		while (seed.random(3) == 0) {
			var list = getHoriLine(1 + seed.random(ymax - 2), 0.1);
			for (p in list)
				model.set('${p[0]},${p[1]}', null);
		}

		// BALL
		while (lvl >= 1 && seed.random(3) == 0) {
			var x = seed.random(14);
			var y = seed.random(5);
			model.set('${x},${y}', BALL);
		}

		// REDUCTRINES
		if (wy < -40 && seed.random(4) == 0) {
			var max = Std.int(Math.min(seed.random(Std.int(2 + (Math.abs(wy) * 0.05))), 10));
			genRandom(REDUC, max);
			flLure = true;
		}

		// STEEL BAR
		if (seed.random(proba[PB_STEEL_BAR]) == 0) {
			var type = null;
			if (seed.random(3) == 0)
				type = seed.random(2);
			var hmin = Math.round(Math.max(3 - (dst / 30), 1));
			var list = getHoriLine(3 + seed.random((ymax - 3)), 0.1, type, hmin + seed.random(2));
			for (p in list) {
				model.set('${p[0]},${p[1]}', STEEL);
			}
		}

		// STEEL CLOUD
		if (seed.random(proba[PB_STEEL_CLOUD]) == 0) {
			var n = Std.int(Math.min(Math.sqrt(dst * 0.25), 20));
			var max = n + seed.random(n);
			for (i in 0...max)
				genCloud(STEEL);
		}

		// BOOM
		if (seed.random(proba[PB_BOOM]) == 0) {
			var max = 0;
			while (max % 10 == 0)
				max += seed.random(11);
			genRandom(BOOM, max, 0);
		}

		// CAGE
		if (seed.random(proba[PB_CAGE]) == 0) {
			var max = 1 + seed.random(lvl + 1);
			while (seed.random(5) == 0)
				max += seed.random(max);
			genRandom(CAGE, max, 0);
		}

		// GENERATOR
		if (seed.random(proba[PB_GENERATOR]) == 0) {
			var max = 1 + seed.random(lvl);
			genRandom(GENERATOR, max, 1);
		}

		// DOOR
		if (seed.random(proba[PB_DOOR]) == 0) {
			var max = 1 + seed.random(5);
			for (i in 0...max)
				genCloud(DOOR);
			if (seed.random(8) == 0) {
				var list = getHoriLine(1 + seed.random(ymax - 2), 0.1, null, 2);
				for (p in list)
					model.set('${p[0]},${p[1]}', DOOR);
			}
		}

		// MISSILES
		if (seed.random(proba[PB_MISSILE]) == 0) {
			var max = 1 + seed.random(6);
			genRandom(MISSILE, max);
		}

		// KILL
		if (seed.random(proba[PB_KILL]) == 0) {
			var max = 1 + seed.random(Std.int(Math.pow(dst, 0.5)));
			genRandom(KILL, max);
		}

		// LIFE
		while (seed.rand() * (Math.pow(dst, 0.5) + 3) < 1) {
			var max = 1 + seed.random(2);
			genRandom(LIFE, max);
		}

		// DEATH
		while (seed.random(proba[PB_DEATH]) == 0) {
			var max = 1 + seed.random(2);
			genRandom(DEATH, max);
		}

		// ZONES MODIFS
		if (zid == null) {
			// HORILINE SPACE
			if (dst > 11 && (dst < 12 || seed.random(10) == 0)) {
				var list = getHoriLine(Std.int(ymax * 0.5), 0.1);
				for (p in list)
					model.set('${p[0]},${p[1]}', SPACE);
			}

			// REDUCTRINES TEST
			var d = distances[ZoneInfo.BALIXT];
			var lim = 15;
			if (d < lim) {
				var max = seed.random(Std.int((1 - (d / lim)) * 6) + 1);
				genRandom(REDUC, max);
				flLure = true;
			}

			// PUSHER
			if (seed.random(proba[PB_PUSHER]) == 0) {
				var n = Std.int(Math.min(Math.sqrt(dst * 0.25), 10));
				var max = n + seed.random(n);
				genRandom(PUSHER, max, null, 1);
			}

			// JUMPER
			if (seed.random(proba[PB_JUMPER]) == 0) {
				genRandom(JUMPER, 6);
			}

			// STORM
			if (seed.random(proba[PB_STORM]) == 0) {
				var ym = Std.int(Math.min(1 + dst * 0.15, ymax));
				genRandom(STORM, 1 + Std.int(Math.pow(seed.rand(), 3) * 16), null, null, ym);
				flLure = true;
			}

			// DRAGON
			if (seed.random(proba[PB_DRAGON]) == 0) {
				var max = 1 + seed.random(8);
				for (i in 0...max) {
					var n = seed.random(2);
					var ma = 5;
					var x = seed.random(14 - ma);
					var y = seed.random(ymax);
					if (n == 0)
						x += ma;
					var bl = model.get('${x},${y}');
					if (model.get('${x},${y}') != null)
						model.set('${x},${y}', DRAGON_LEFT + n);
				}
			}

			// INVERSE
			if (dst > 20 && seed.random(500) == 0) {
				genRandom(SWAP, 1 + seed.random(2));
				if (seed.random(100) == 0)
					genRandom(SWAP, 20);
			}

			// NUT
			if (dst > 30 && seed.random(300) == 0) {
				var list = getHoriLine(1 + seed.random(ymax - 2), 0.1, null, 2);
				for (p in list)
					model.set('${p[0]},${p[1]}', NUT);
			}

			// DEATH
			if (seed.random(proba[PB_DEATH]) == 0) {
				genRandom(DEATH, 1 + seed.random(2));
			}

			// GUARDIAN
			if (seed.random(16) == 0 && dst > 50) {
				genRandom(GUARDIAN, 1 + seed.random(6));
			}

			// GLUE
			if (seed.random(8) == 0 && distances[ZoneInfo.SAMOSA] < 50) {
				genRandom(GLUE, 1 + seed.random(4));
			}
		} else {
			genZoneModif();
		}

		// BONUS
		seed = new mt.OldRandom(wx * 10000 + wy);
		var n = 1;
		var lim = 1;
		if (zid == ZoneInfo.GRIMORN)
			lim = 0;
		if (zid == ZoneInfo.TIBOON)
			lim = 0;
		if (zid == ZoneInfo.DOURIV)
			lim = 2;
		if (zid == ZoneInfo.EARTH)
			lim = 8;
		if (distances[ZoneInfo.DOURIV] < 2)
			lim = 3;
		while (seed.random(n++) < lim)
			genBonusBlock(ymax);

		// LURE
		if (flLure && dst > 130) {
			if (seed.random(4) == 0) {
				genRandom(LURE, 1 + seed.random(20));
			}
			if (seed.random(8) == 0) {
				var list = getHoriLine(seed.random(ymax), 0.1, 0);
				for (p in list)
					model.set('${p[0]},${p[1]}', LURE);
			}
		}

		// MIRROR
		if (flMirror) {
			var mx = Std.int(14 * 0.5);
			for (x in 0...mx) {
				var nx = 14 - (x + 1);
				for (y in 0...ymax) {
					var n = model.get('${x},${y}');
					model.set('${nx},${y}', n);
					if (n == DRAGON_LEFT)
						model.set('${nx},${y}', DRAGON_RIGHT);
					if (n == DRAGON_RIGHT)
						model.set('${nx},${y}', DRAGON_LEFT);
				}
				// seemingly never worked to begin with
				//if (flMirrorPalette) PixelHelper.copyPixels(bmpPaint, bmpPaint, new pixi.core.math.shapes.Rectangle(x, 0, 1, 23), new pixi.core.math.Point(nx, 0));
			}
		}

		// START CROP
		if (dst < 8) {
			var crop = 1;
			if (dst < 2)
				crop++;
			if (dst < 1)
				crop++;
			for (x in 0...14) {
				for (y in 0...ymax) {
					if (x < crop || x >= 14 - crop || y < crop) {
						model.set('${x},${y}', null);
					}
				}
			}
		}

		// START CEINTURE
		if ((Math.max(Math.abs(wx), Math.abs(wy)) == 3)) {
			var list = getHoriLine(12, 0.0);
			for (p in list)
				model.set('${p[0]},${p[1]}', 1);
		}

		// OBJETS
		if (item) insertItem();
	}

	public function forceModel() {
		model = new StringMap();
		for (x in 0...14) {
			for (y in 0...ymax)
				model.set('${x},${y}', 0);
		}
	}

	public function getGoal() {
		var obj = 0;
		for (x in 0...14) {
			for (y in 0...23) {
				if (model.get('${x},${y}') == 0)
					obj++;
			}
		}
		return obj;
	}

	// BUILD TEST
	public function isModelOpen(obj) {
		var sx = null;
		var sy = ymax - 1;
		var grid = new StringMap();
		for (x in 0...14) {
			if (sx == null && isSoft(model.get('${x},${sy}')))
				sx = x;
		}
		if (sx == null) {
			// trace("csModelOpen ERROR");
			return false;
		}

		// trace(sx);
		// return true;

		var n = getPath(sx, sy, grid, 0);
		return n == obj;
	}

	public static function isSoft(n) {
		return n != STEEL && n != SWAP && n != DOOR && !isSentinelle(n);
	}

	public static function isSentinelle(n) {
		return n == REDUC || n == STORM || n == KILL || n == GLUE || n == LURE;
	}

	function getPath(x:Int, y:Int, grid:StringMap<Bool>, profondeur) {
		if (profondeur == 240)
			return 0;

		var n = 0;
		grid.set('${x},${y}', true);
		if (model.get('${x},${y}') == 0)
			n++;
		for (d in DIR) {
			var nx = x + d[0];
			var ny = y + d[1];
			if (grid.get('${nx},${ny}') == null && nx >= 0 && nx < 14 && ny >= 0 && ny < ymax + 1) {
				if (isSoft(model.get('${x},${y}')))
					n += getPath(nx, ny, grid, profondeur + 1);
			}
		}
		return n;
	}

	public function genStruct() {
		model = new StringMap();
		for (x in 0...14) {
			for (y in 0...23) {
				var n = struct.get('${x},${y}');
				model.set('${x},${y}', n);
			}
		}
	}

	function getHoriLine(sy, turnCoef, ?type, ?hole) {
		// TYPE
		// null Over
		// 0 	Fill
		// 1 	Behind

		var hx = null;
		if (hole != null)
			hx = seed.random(14 - hole);

		var list = [];

		var y = sy;

		// var x = 0;
		// while( x < 14 ){
		for (x in 0...14) {
			if (hx == null || (x < hx || x >= hx + hole)) {
				if (type == null) {
					list.push([x, y]);
				} else {
					var prec = model.get('${x},${y}');
					if (prec != null) {
						if (type == 0)
							list.push([x, y]);
					} else {
						if (type == 1)
							list.push([x, y]);
					}
				}
				if (seed.rand() < turnCoef) {
					var sens = seed.random(2) * 2 - 1;
					var max = 1 + seed.random(8);
					for (i in 0...max) {
						y += sens;
						if (y < ymax && y >= 0) {
							if (type == null) {
								list.push([x, y]);
							} else {
								var prec = model.get('${x},${y}');
								if (prec != null) {
									if (type == 0)
										list.push([x, y]);
								} else {
									if (type == 1)
										list.push([x, y]);
								}
							}
						} else {
							y -= sens;
							break;
						}
					}
				}
			}
		}
		return list;
	}

	function genRandom(type, max, ?drawType, ?ma, ?ym) {
		if (ym == null)
			ym = ymax;
		if (ma == null)
			ma = 0;
		for (i in 0...max) {
			var x = ma + seed.random(14 - 2 * ma);
			var y = ma + seed.random(ym - 2 * ma);
			var n = model.get('${x},${y}');
			switch (drawType) {
				case 0:
					if (n != null)
						model.set('${x},${y}', type);
				case 1:
					if (n == null)
						model.set('${x},${y}', type);
				default:
					model.set('${x},${y}', type);
			}
		}
	}

	function genCloud(type) {
		var x = seed.random(14);
		var y = seed.random(ymax);
		var d = DIR[seed.random(4)];
		var lmax = 2 + seed.random(4);
		for (n in 0...lmax) {
			var nx = x + d[0] * n;
			var ny = y + d[1] * n;
			if (isOut(nx, ny))
				break;
			model.set('${nx},${ny}', type);
		}
	}

	public function isOut(x, y) {
		return x < 0 || x >= 14 || y < 0 || y >= ymax;
	}

	function genZoneModif() {
		switch (zid) {
			case ZoneInfo.MOLTEAR:
				genRandom(CAGE, 10);
			case ZoneInfo.SOUPALINE:
				var list = getHoriLine(Std.int(ymax * 0.5), 0.1, 0);
				for (p in list)
					model.set('${p[0]},${p[1]}', SPACE);
			case ZoneInfo.LYCANS:
				if (seed.random(4) == 0) {
					var list = getHoriLine(Std.int(ymax * 0.5), 0.1, 0);
					for (p in list)
						model.set('${p[0]},${p[1]}', BOOM);
				}
			case ZoneInfo.SAMOSA:
				if (seed.random(2) == 0) {
					genRandom(GLUE, 1 + seed.random(16));
				}
				if (seed.random(8) == 0) {
					var list = getHoriLine(Std.int(ymax * 0.5), 0.1, 0);
					for (p in list)
						model.set('${p[0]},${p[1]}', GLUE);
				}
			case ZoneInfo.TIBOON:
			case ZoneInfo.BALIXT:
				var max = 2 + seed.random(12);
				genRandom(REDUC, max);
				flLure = true;
			case ZoneInfo.KARBONIS:
				var max = 1;
				if (distances[ZoneInfo.KARBONIS] < 1.5)
					max++;

				for (i in 0...max) {
					var list = getHoriLine(4 + seed.random(ymax - 8), 0.15);
					for (p in list)
						model.set('${p[0]},${p[1]}', JUMPER);
				}

			case ZoneInfo.SPIGNYSOS:
				genRandom(CAGE + Molecule.LIGHTER, 1 + seed.random(3));
				if (seed.random(5) == 0)
					genRandom(CAGE + Molecule.SPACER, 1 + seed.random(5));

			case ZoneInfo.POFIAK:
				genRandom(CAGE + Molecule.BUILDER, 1 + seed.random(2));
				if (seed.random(3) == 0)
					genRandom(INSECT, 1 + seed.random(4));

			case ZoneInfo.SENEGARDE:
				var c = 1 - distances[ZoneInfo.SENEGARDE] / ZoneInfo.list[ZoneInfo.SENEGARDE].pos[2];
				var max = Std.int(1 + c * 8);
				genRandom(GENERATOR, max);

			case ZoneInfo.DOURIV:
				for (i in 0...3) {
					var list = getHoriLine(2 + i * 5, 0.2, 0);
					for (p in list)
						model.set('${p[0]},${p[1]}', 4);
				}
				if (seed.random(4) == 0)
					genRandom(INSECT, 3 + seed.random(12));

			case ZoneInfo.GRIMORN:
				for (i in 0...20)
					genCloud(STEEL);

			case ZoneInfo.DTRITUS:
				genRandom(INSECT, 1 + seed.random(24));

			case ZoneInfo.NALIKORS:
				genRandom(LIFE, 1);
				genRandom(DEATH, 1 + seed.random(2));

				if (seed.random(20) == 0) {
					var list = getHoriLine(1 + seed.random(ymax - 2), 0.1, null, 2);
					for (p in list)
						model.set('${p[0]},${p[1]}', DEATH);
				}

			case ZoneInfo.HOLOVAN:
				if (seed.random(2) == 0) {
					var list = getHoriLine(1 + seed.random(ymax - 2), 0.1, null, 2);
					for (p in list)
						model.set('${p[0]},${p[1]}', KILL);
				}
				while (seed.random(2) == 0) {
					var max = 1 + seed.random(6);
					genRandom(KILL, max);
				}

			case ZoneInfo.KHORLAN:
				var n = 1;
				while (seed.rand() * n < 1) {
					var list = getHoriLine(1 + seed.random(ymax - 2), 0.1, null, 2);
					for (p in list)
						model.set('${p[0]},${p[1]}', NUT);
					n *= 2;
				}
				if (seed.random(2) == 0) {
					genRandom(CAGE + Molecule.ARMORER, 1 + seed.random(3));
				}

			case ZoneInfo.CILORILE:
				genRandom(GUARDIAN, 1 + seed.random(16));

			case ZoneInfo.TARCITURNE:
				var n = 1;
				while (seed.rand() * n < 3) {
					genCloud(STEEL);
					n++;
				}
			case ZoneInfo.CHAGARINA:
				if (seed.random(2) == 0) {
					var list = getHoriLine(1 + seed.random(ymax - 2), 0.1, null, 6);
					for (p in list)
						model.set('${p[0]},${p[1]}', DEATH);
				}
			case ZoneInfo.VOLCER:
				var max = Std.int((8 - distances[ZoneInfo.VOLCER]) * 2);
				genRandom(REDUC, max);
				genRandom(KILL, max);
				if (seed.random(2) == 0)
					genRandom(LURE, max);

			case ZoneInfo.BALMANCH:
				var max = 10 + seed.random(10);
				for (i in 0...max)
					genCloud(NUT);

				var max = 1 + seed.random(4);
				for (i in 0...2) {
					var sens = i * 2 - 1;
					for (n in 0...max) {
						var x = i * 13 - sens * seed.random(4);
						var y = seed.random(ymax);
						model.set('${x},${y}', [DRAGON_RIGHT, DRAGON_LEFT][i]);
					}
				}
				searchAndReplace(STEEL, 4);

			case ZoneInfo.FOLKET:
				var max = Std.int((3 - distances[ZoneInfo.FOLKET]) * 3);
				for (i in 0...max)
					genCloud(REDUC);

				searchAndReplace(STEEL, SPACE);
				searchAndReplace(BONUS + 1, BONUS + 1);
				searchAndReplace(BONUS + 2, BONUS + 1);
				searchAndReplace(BONUS + 3, BONUS + 1);
				searchAndReplace(BONUS, BONUS + 1);
				for (i in 1...6)
					searchAndReplace(i, SPACE);

			case ZoneInfo.EARTH:
				for (x in 0...14) {
					for (y in 0...23) {
						if (model.get('${x},${y}') != null)
							model.set('${x},${y}', 0);
					}
				}

				/*
					var max = 1;
					while(seed.random(max)==0){
						max++;
						var list = getHoriLine(1+seed.random(ymax-2),0.1, null, 2 );
						for( p in list )model.set('${p[0]},${p[1]}', GUARDIAN);
					}
				 */
		}
	}

	function searchAndReplace(o, n) {
		for (x in 0...14) {
			for (y in 0...23) {
				if (model.get('${x},${y}') == o)
					model.set('${x},${y}', n);
			}
		}
	}

	function genBonusBlock(ymax) {
		var max = Std.int(Math.min(2 + lvl, 4));

		var mx = 1 + seed.random(max);
		var my = 1 + seed.random(max);
		var sx = seed.random(14 - mx);
		var sy = seed.random(ymax - my);
		var po = 0;

		var bluePower = Math.max(2.5 - dst * 0.004, 1);
		var pinkPower = Math.max(3.5 - dst * 0.004, 2);

		if (seed.random(Std.int(Math.pow(mx + my + 1, bluePower))) == 0)
			po = 1;
		if (seed.random(Std.int(Math.pow(mx + my + 1, pinkPower))) == 0)
			po = 2;

		var type = 10 + po;
		// if( flDepleted )type = null;

		for (x in 0...mx) {
			for (y in 0...my) {
				model.set('${sx + x},${sy + y}', type);
			}
		}
	}

	function insertItem() {
		var ma = 4;
		var x = ma + seed.random(14 - 2 * ma);
		var y = seed.random(3);
		model.set('${x},${y}', ITEM);
		// trace(">>");
	}
	
	public function getBlockTypeStats() {
		blockStats = [for (t in [BONUS, BONUS2, BONUS3, MISSILE, LIFE]) t => {count: 0}];
		mineralCount = 0;
		for (x in 0...14) {
			for (y in 0...23) {
				switch model.get('$x,$y') {
					case BONUS:
						blockStats.get(BONUS).count++;
						mineralCount++;
					case BONUS2:
						blockStats.get(BONUS2).count++;
						mineralCount += 10;
					case BONUS3:
						blockStats.get(BONUS3).count++;
						mineralCount += 25;
					case MISSILE:
						blockStats.get(MISSILE).count++;
					case LIFE:
						blockStats.get(LIFE).count++;
				}
			}
		}
	}

	// BUILD PALETTE
	public function genPalette() {
		// PAINT
		// var id = 0;
		var zone = {col: 0x888888, pal: [[55, 55, 55, 200, 200, 200]]}
		if (zid != null)
			zone = ZoneInfo.list[zid];

		var bmpPaint = RenderTexture.create(14, 23);
		var bg = new Graphics();
		bg.beginFill(zone.col);
		bg.drawRect(0, 0, 400, 360);
		Main.draw(bmpPaint, bg, new Matrix());
		
		var brush = Sprite.from(Main.textures.get('mcBrush'));
		brush.blendMode = pixi.core.Pixi.BlendModes.ADD;
		var sc = 0.1;
		var ma = -2;
		for (i in 0...16) {
			var m = new Matrix();
			m.scale(sc, sc);
			m.translate(ma + seed.random(14 - 2 * ma), ma + seed.random(23 - 2 * ma));

			var pr = zone.pal[seed.random(zone.pal.length)];

			var r = pr[0] + seed.random(pr[3]);
			var g = pr[1] + seed.random(pr[4]);
			var b = pr[2] + seed.random(pr[5]);

			var col = Main.objToCol({r: r, g: g, b: b});
			brush.tint = col;
			brush.alpha = 0.4;

			Main.draw(bmpPaint, brush, m);
		}

		blockCol = untyped Main.app.renderer.plugins.extract.pixels(bmpPaint);
	}

	public function getImage(col) {
		if (screenshot == null) {
			genPalette();
			var bmp = RenderTexture.create(400, 360);
			var bg = new Graphics();
			bg.beginFill(col);
			bg.drawRect(0, 0, 400, 360);
			Main.draw(bmp, bg, new Matrix());

			// CLOUDS
			var seed = new Random(wx * 1000 + wy);
			var brushLight = Sprite.from(Main.textures.get('mcLuz'));
			var sc = 6;
			for (i in 0...6) {
				var m = new Matrix();
				m.scale((0.5 + seed.rand()) * sc, (0.5 + seed.rand()) * sc);
				m.translate(seed.random(400), seed.random(360));
				var bi = 5;
				var ri = 50;
				var o = {
					r: bi + seed.random(ri),
					g: bi + seed.random(ri),
					b: bi + seed.random(ri)
				}
				Main.setPercentColor(brushLight, 100, Main.objToCol(o));
				brushLight.alpha = 0.5;
				var bl = pixi.core.Pixi.BlendModes.ADD;
				if (i % 2 == 0)
					bl = BlendModes.EXCLUSION; // 'subtract'

				brushLight.blendMode = bl;

				Main.draw(bmp, brushLight, m);
			}

			// STARS
			var brushStar = Sprite.from(Main.textures.get('Star'));
			brushStar.blendMode = ADD;
			for (i in 0...100) {
				var m = new Matrix();
				var sc = 0.2 + seed.rand() * 0.3;
				m.scale(sc, sc);
				m.translate(seed.rand() * 400, seed.rand() * 360);
				Main.draw(bmp, brushStar, m);
			}

			// PLANETS
			if (zid != null) {
				var zi = ZoneInfo.list[zid];
				var mc = Sprite.from(Main.textures.get('planet$zid'));

				var m = new Matrix();
				m.scale(20, 20);
				m.translate((zi.pos[0] - wx) * 400, (zi.pos[1] - wy) * 360);

				//Col.setColor(mc, spaceColor);
				Main.draw(bmp, mc, m);
			}

			// BLOCKS
			var blockLayer = RenderTexture.create(400, 360);
			var skinBase = Main.textures.get('baseBlocks');
			var skin = Main.textures.get('blocks');
			var frame = new Rectangle(0, 0, 28, 14);

			for (x in 0...14) {
				for (y in 0...23) {
					var type = model.get('${x},${y}');
					if (type != null) {
						var brush:Sprite;

						if (type < BONUS) {
							var color:Array<Int>;
							if (type == 0) {
								color = [Main.getPixel(blockCol, x, y, 14)];
							} else {
								color = [0x885533];
								if (type > 5) type = 5;
							}
							frame.y = type * 14;
							skinBase.frame = frame;
							brush = Sprite.from(skinBase);
							brush.tint = color[0];
						} else {
							frame.y = (type - 10) * 14;
							skin.frame = frame;
							brush = Sprite.from(skin);
						}

						var m = new Matrix();
						m.translate(4 + 28 * x, 14 * y);
						Main.draw(blockLayer, brush, m);
					}
				}
			}
			Main.draw(bmp, Sprite.from(blockLayer), new Matrix());
			screenshot = untyped Main.app.renderer.plugins.extract.image(bmp, "image/webp");
		}
		
		return screenshot;
	}
}

/*
	drawing level background
		Game.initBg() -> Module.getBmpBg()
	
	draw level layout
		Game.initLevel() -> Game.fillGrid() -> Level.genModel()
*/
