/* Constructor for the Slider class 
list is the list of element id's
elements is the quantity of elements the slider will have.
show is the quantity of elements to display at a time.
*/
function Slider(list, show, name){
	this.list = list;
	this.show = show;
	this.current = 0;
	this.name = name;
	
	for (i = 0; i < show && i < list.length; i++){
		$(list[i]).show();
	}
	
	for(i = show; i < list.length; i++){
		$(list[i]).hide();
	}
	
	if(list.length > show){
		$(name + "_next").show();
	}else{
		$(name + "_next").hide();
	}
	
	$(name + "_prev").hide();
	
	this.next = function(){		
		if( (this.current + (show)) < (list.length)){ 
			$(list[this.current]).hide();
			$(list[(this.current + this.show)]).show();
			this.current++;
			if((this.current + (show)) >= (list.length)){
				$(name + "_next").hide();
			}
		}
		
		if(this.current > 0){
			$(name + "_prev").show();
		}
	}

	this.prev = function(){
		if(this.current > 0){
			$(list[(this.current + (this.show - 1))]).hide();
			$(list[(this.current -1)]).show();
			this.current--;
			if(this.current <= 0 ){
				$(name + "_prev").hide();
			}
		}
		if((this.current + (show)) < (list.length)){
			$(name + "_next").show();
		}
		
	}
}
