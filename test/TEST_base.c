#include <stdio.h>
#include <base.h>

int main(int argc, char **argv) {
	if (baseline(3) != 4) {
		goto fail;
	}
	if (baseline(4) != 4) {
		goto fail;
	}
	if (baseline(0) != 0) {
		goto fail;
	}

	printf("Success!\n");
	return 0;
fail:
	fprintf(stderr, "Failed test!\n");
	return -1;
}