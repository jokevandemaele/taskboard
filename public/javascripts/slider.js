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
			for(var i = this.current; i < this.current + show; i++)
				$(list[i]).hide();

			if((this.current + 2*show) < list.length)
				upto = this.current + 2*show
			else
				upto = list.length

			this.current = this.current + show;
			for(var i = this.current; i < upto; i++)
				$(list[i]).show();

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
			for(var i = this.current; i < list.length; i++){
				$(list[i]).hide();
			}

			from = this.current - 1
			if((this.current - show) > 0)
				this.current = this.current - show
			else
				this.current = 0
			
			for(var i = from; i >= this.current; i--){
				$(list[i]).show();
			}
			if(this.current <= 0 ){
				$(name + "_prev").hide();
			}
		}
		if((this.current + (show)) < (list.length)){
			$(name + "_next").show();
		}
		
	}
}
