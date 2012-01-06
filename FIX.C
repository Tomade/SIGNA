#include <stdio.h>

void main() {
    FILE *fp = fopen("cards.prn", "rb");
    FILE *fpo = fopen("cards.out", "wb");

    int c;

    c = fgetc(fp);
    while (!feof(fp)) {
        fputc(c, fpo);
        if (c == 12) {
            fgetc(fp);
            fgetc(fp);
            fputc(13, fpo);
        }
        c = fgetc(fp);
    }
    fcloseall();
}


