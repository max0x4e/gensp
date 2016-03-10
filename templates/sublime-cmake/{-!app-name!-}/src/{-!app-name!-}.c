#define __STDC_WANT_LIB_EXT1__ 1
#include <stdio.h>
#include "{-!App-name!-}Config.h"

int main(int argc, char * argv[]) {
	if (2 > argc) {
		printf("%s Version %d.%d\n", argv[0], {-!App-name!-}_VERSION_MAJOR, {-!App-name!-}_VERSION_MINOR);
		printf("Usage: {-!app-synopsis!-}\n");
		return 1;
	}
	return 0;
}
