module d2d.math;

public {

}

int closestPow2(int numeral) {
	--numeral;
	int res = 1;
	while(numeral > 0) {
		numeral >>= 1;
		res <<= 1;
	}
	return res;
}
