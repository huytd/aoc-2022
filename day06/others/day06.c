#include <stdio.h>

int is_marker(char* input, int left, int right, int k) {
	int freq[26] = {0};
	for (int i = left; i < right; i++) {
		freq[input[i] - 'a']++;
	}
	int count = 0;
	for (int i = 0; i < 26; i++) {
		if (freq[i] == 1) count++;
	}
	return count == k;
}

int lookup(char* input, int len, int k) {
	int left = 0;
	int right = 0;
	while (right < len) {
		right++;
		if (is_marker(input, left, right, k)) {
			return right;
		}
		if (right - left >= k) {
			left++;
		}
	}
	return -1;
}

int main() {
	FILE* fp = fopen("../input.txt", "r");
	fseek(fp, 0, SEEK_END);
	long length = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	char buf[length];
	fgets(buf, length, fp);

	printf("Part 1 - Found at %d\n", lookup(buf, length, 4));
	printf("Part 2 - Found at %d", lookup(buf, length, 14));

	fclose(fp);
}
