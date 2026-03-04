extends RefCounted
class_name CardGenConst

enum CardGenEnum {
	stdatk,
	stddef,
	dblatk,
	atkall
}

const CardGenMap: Dictionary[CardGenEnum, String] = {
	CardGenEnum.stdatk: "stdatk",
	CardGenEnum.stddef: "stddef",
	CardGenEnum.dblatk: "dblatk",
	CardGenEnum.atkall: "atkall"
}
