/* Constructor for the Slider class 
id_base is used to identify different sliders with the id field of the objects to slide
elements is the quantity of elements the slider will have.
show is the quantity of elements to display at a time.
*/
function Slider(id_base, elements, show){
	this.id_base = id_base;
	this.elements = elements;
	this.show = show;
	this.current = 0;
	
	for (i = 0; i < show; i++){
		$(id_base + "-" + i).show();
	}
	for(i = show; i < elements; i++){
		$(id_base + "-" + i).hide();
	}


	this.next = function(){		
		if( (this.current + (show - 1)) < (elements - 1)){ 
			$(this.id_base + "-" + this.current).hide();
			$(this.id_base + "-" + (this.current + this.show)).show();
			this.current++;
		}
	}

	this.prev = function(){
		if(this.current > 0){
			$(this.id_base + "-" + (this.current + (this.show - 1))).hide();
			$(this.id_base + "-" + (this.current -1)).show();
			this.current--;
		}
	}
}
