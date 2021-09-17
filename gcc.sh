#! /bin/sh

gcc -std=c99\
    -Wall\
    -Werror\
    -Wextra\
    -Wconversion\
    -Wfloat-conversion\
    -Wredundant-decls\
    -Wpedantic\
    -Wunused\
    -Wsign-conversion\
    -Wvla\
    -pedantic\
    -Wfloat-equal $1