#include "screen.h"

int get_screen_offset(int col, int row){
	int offset = (row * MAX_COLS + col) * 2;
	return offset;
}

int get_cursor(){
	// The device uses its control register as an index
	// to select its internal registers, of which we are
	// interested in
	// 	reg 14: high byte of the cursor offset
	// 	reg 15: low byte of the cursor offset
	// Once we set the internal register, we can read or write the
	// data.
	port_byte_out(REG_SCREEN_CTRL, 14);
	int offset = port_byte_in(REG_SCREEN_DATA) << 8;
	port_byte_out(REG_SCREEN_CTRL, 15);
	offset += port_byte_in(REG_SCREEN_DATA);
	// The cursor offset returned by the VGA hardware is the
	// number of characters. We need to multiply by 2 to get
	// the memory offset
	return offset * 2;
}

void set_cursor(int offset){
	// Is the same as get_cursor, but now we write in the data
	// register, instead of reading
	// We need to divide the offset, for getting the number of 
	// characters
	offset /= 2;
	port_byte_out(REG_SCREEN_CTRL, 14);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
	port_byte_out(REG_SCREEN_CTRL, 15);
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xf));
}

void print_char(char character, int col, int row, char attribute_byte) {
	// Byte char pointer to video memory
	unsigned char* vidmem = (unsigned char*) VIDEO_ADDRESS;
	
	// if attribute is 0, assume default
	if(!attribute_byte) {
		attribute_byte = WHITE_ON_BLACK;
	}

	// Get offset for location
	int offset;
	// if col and row are non negativa, uses them for offset
	if(col >= 0 && row >= 0){
		offset = get_screen_offset(col, row);
	}
	else {
		offset = get_cursor();
	}

	// if we are on new line character, set offset to the end of current row,
	// so it will be advanced to the first col of the next row
	if(character == '\n') {
		int rows = offset / (2 * MAX_COLS);
		offset = get_screen_offset(79, rows);
	}
	else {
		vidmem[offset] = character;
		vidmem[offset+1] = attribute_byte;
	}

	// Update the offset for the next character cell
	offset += 2;

	set_cursor(offset);
}

void print_at(char* message, int col, int row) {
	// Update cursor if col and row not negative
	if(col >= 0 && row >= 0){
		set_cursor(get_screen_offset(col, row));
	}

	// Print each character
	int i = 0;
	while(message[i] != 0) {
		print_char(message[i++], col, row, WHITE_ON_BLACK);
	}
}

void print(char* message){
	print_at(message, -1, -1);
}

void clear_screen(){
	int row = 0;
	int col = 0;

	for(row = 0; row < MAX_ROWS; row++){
		for(col = 0; col < MAX_COLS; col++){
			print_char(' ', col, row, WHITE_ON_BLACK);
		}
	}

	set_cursor(get_screen_offset(0, 0));
}
