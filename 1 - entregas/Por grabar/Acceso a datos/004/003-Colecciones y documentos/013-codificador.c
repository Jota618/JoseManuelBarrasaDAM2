#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

// Función para codificar una cadena en Base64
char *base64_encode(const unsigned char *data, size_t input_length, size_t *output_length) {
    static const char encoding_table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    static const char padding_char = '=';
    size_t i, j;
    *output_length = 4 * ((input_length + 2) / 3);
    char *encoded_data = malloc(*output_length + 1);
    if (encoded_data == NULL) return NULL;

    for (i = 0, j = 0; i < input_length;) {
        uint32_t octet_a = i < input_length ? data[i++] : 0;
        uint32_t octet_b = i < input_length ? data[i++] : 0;
        uint32_t octet_c = i < input_length ? data[i++] : 0;

        uint32_t triple = (octet_a << 16) | (octet_b << 8) | octet_c;

        encoded_data[j++] = encoding_table[(triple >> 18) & 0x3F];
        encoded_data[j++] = encoding_table[(triple >> 12) & 0x3F];
        encoded_data[j++] = i > input_length + 1 ? padding_char : encoding_table[(triple >> 6) & 0x3F];
        encoded_data[j++] = i > input_length ? padding_char : encoding_table[triple & 0x3F];
    }
    encoded_data[*output_length] = '\0';
    return encoded_data;
}

// Función para decodificar una cadena en Base64
unsigned char *base64_decode(const char *data, size_t input_length, size_t *output_length) {
    static const unsigned char decoding_table[256] = {
        [0 ... 255] = 0, ['A'] = 0, ['B'] = 1, ['C'] = 2, ['D'] = 3, ['E'] = 4,
        ['F'] = 5, ['G'] = 6, ['H'] = 7, ['I'] = 8, ['J'] = 9, ['K'] = 10,
        ['L'] = 11, ['M'] = 12, ['N'] = 13, ['O'] = 14, ['P'] = 15, ['Q'] = 16,
        ['R'] = 17, ['S'] = 18, ['T'] = 19, ['U'] = 20, ['V'] = 21, ['W'] = 22,
        ['X'] = 23, ['Y'] = 24, ['Z'] = 25, ['a'] = 26, ['b'] = 27, ['c'] = 28,
        ['d'] = 29, ['e'] = 30, ['f'] = 31, ['g'] = 32, ['h'] = 33, ['i'] = 34,
        ['j'] = 35, ['k'] = 36, ['l'] = 37, ['m'] = 38, ['n'] = 39, ['o'] = 40,
        ['p'] = 41, ['q'] = 42, ['r'] = 43, ['s'] = 44, ['t'] = 45, ['u'] = 46,
        ['v'] = 47, ['w'] = 48, ['x'] = 49, ['y'] = 50, ['z'] = 51, ['0'] = 52,
        ['1'] = 53, ['2'] = 54, ['3'] = 55, ['4'] = 56, ['5'] = 57, ['6'] = 58,
        ['7'] = 59, ['8'] = 60, ['9'] = 61, ['+'] = 62, ['/'] = 63
    };
    if (input_length % 4 != 0) return NULL;

    *output_length = input_length / 4 * 3;
    if (data[input_length - 1] == '=') (*output_length)--;
    if (data[input_length - 2] == '=') (*output_length)--;

    unsigned char *decoded_data = malloc(*output_length + 1);
    if (decoded_data == NULL) return NULL;

    for (size_t i = 0, j = 0; i < input_length;) {
        uint32_t sextet_a = data[i] == '=' ? 0 & i++ : decoding_table[(int)data[i++]];
        uint32_t sextet_b = data[i] == '=' ? 0 & i++ : decoding_table[(int)data[i++]];
        uint32_t sextet_c = data[i] == '=' ? 0 & i++ : decoding_table[(int)data[i++]];
        uint32_t sextet_d = data[i] == '=' ? 0 & i++ : decoding_table[(int)data[i++]];

        uint32_t triple = (sextet_a << 18) | (sextet_b << 12) | (sextet_c << 6) | sextet_d;

        if (j < *output_length) decoded_data[j++] = (triple >> 16) & 0xFF;
        if (j < *output_length) decoded_data[j++] = (triple >> 8) & 0xFF;
        if (j < *output_length) decoded_data[j++] = triple & 0xFF;
    }
    decoded_data[*output_length] = '\0';
    return decoded_data;
}

// Función para codificar una cadena
char *codifica(const char *entrada) {
    size_t len = strlen(entrada);
    char *modificada = malloc(len + 1);
    if (!modificada) return NULL;

    for (size_t i = 0; i < len; i++) {
        modificada[i] = entrada[i] + 5;
    }
    modificada[len] = '\0';

    size_t output_length;
    char *base64_1 = base64_encode((unsigned char *)modificada, len, &output_length);
    if (!base64_1) return NULL;

    char *base64_2 = base64_encode((unsigned char *)base64_1, output_length, &output_length);
    free(base64_1);
    if (!base64_2) return NULL;

    char *base64_3 = base64_encode((unsigned char *)base64_2, output_length, &output_length);
    free(base64_2);
    if (!base64_3) return NULL;

    free(modificada);
    return base64_3;
}

// Función para decodificar una cadena
char *descodifica(const char *entrada) {
    size_t input_length = strlen(entrada);
    size_t output_length;

    unsigned char *base64_1 = base64_decode(entrada, input_length, &output_length);
    if (!base64_1) return NULL;

    unsigned char *base64_2 = base64_decode((char *)base64_1, output_length, &output_length);
    free(base64_1);
    if (!base64_2) return NULL;

    unsigned char *base64_3 = base64_decode((char *)base64_2, output_length, &output_length);
    free(base64_2);
    if (!base64_3) return NULL;

    size_t len = output_length;
    char *modificada = malloc(len + 1);
    if (!modificada) return NULL;

    for (size_t i = 0; i < len; i++) {
        modificada[i] = base64_3[i] - 5;
    }
    modificada[len] = '\0';

    free(base64_3);
    return modificada;
}

int main() {
    const char *contrasena = "Jose Vicente";
    printf("La contraseña es: %s\n", contrasena);

    char *codificado = codifica(contrasena);
    if (!codificado) {
        fprintf(stderr, "Error al codificar.\n");
        return 1;
    }
    printf("La contraseña codificada es: %s\n", codificado);

    char *descodificado = descodifica(codificado);
    if (!descodificado) {
        fprintf(stderr, "Error al decodificar.\n");
        free(codificado);
        return 1;
    }
    printf("La contraseña decodificada es: %s\n", descodificado);

    free(codificado);
    free(descodificado);

    return 0;
}

