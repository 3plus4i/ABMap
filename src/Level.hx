import haxe.ds.StringMap;

class Level {
	public static function getLevelMap() {
		var list = new StringMap();
		
		for (x in sx...(sx + size)) {
			for (y in sy...(sy + size)) {
				var seed = new mt.OldRandom(wx * 10000 + wy);
				var distances = [];
				for (zone in ZoneInfo.list) {
					var dx = x - zone.pos[0];
					var dy = y - zone.pos[1];
					distances.push(Math.sqrt(dx * dx + dy * dy));
				}

				var dst = Math.sqrt(x * x + y * y);
				var ang = Math.atan2(y, x);

				var lvl = Std.int(Math.pow(dst * 0.1, 0.5));
				var ymax = Std.int(Math.min(12 + lvl, Std.int(330 / 14) - 6));
				
			}
		}
	}
	
	function initProba(dst:Float, distances:Array<Float>, wx:Int, ) {
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
							n = Math.max(3, 80 * Math.abs(Num.hMod(ang - 2.504, 3.14)));
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
