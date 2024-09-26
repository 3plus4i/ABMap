class Molecule {
	public static var SUM = 0;
	public static var INFOS = [
		{pb: 15, mols: [0, 1, 2]}, // SPEEDER
		{pb: 2, mols: [0, 3, 3]}, // BUILDER
		{pb: 5, mols: [4, 5, 4]}, // CLEANER
		{pb: 7, mols: [5, 1, 5]}, // SPACER
		{pb: 5, mols: [6, 2, 1]}, // ARMORER
		{pb: 40, mols: [2, 3, 6]}, // FIXER
		{pb: 10, mols: [2, 5, 2]}, // LIGHTER
	];

	public inline static var SPEEDER = 0;
	public inline static var BUILDER = 1;
	public inline static var CLEANER = 2;
	public inline static var SPACER = 3;
	public inline static var ARMORER = 4;
	public inline static var FIXER = 5;
	public inline static var LIGHTER = 6;

	static public function getRandomMolType(seed) {
		if (SUM == 0)
			for (o in INFOS)
				SUM += o.pb * 10;
		var rnd = seed.random(SUM);
		var sum = 0;
		var id = 0;
		for (o in INFOS) {
			sum += Std.int(o.pb * 10);
			if (sum > rnd)
				return id;
			id++;
		}
		return null;
	}
}
