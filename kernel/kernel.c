
void my_function() {

}

void main(){
	// Crate a pointer to a char, and point it to the first
	// text cell of video memory
	char* video_memory = (char*) 0xb8000;
	// Put a X at the address pointed to by video_memory
	*video_memory = 'X';
	my_function();
}
