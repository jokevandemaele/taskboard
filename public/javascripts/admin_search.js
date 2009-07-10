/* Search Class for admin section */
function Search(prefix) {
	/* Elements holds the full list of objects to find within */
	this.elements = []
	
	/* the prefix of the DOM id's to be used to filter */
	this.prefix = prefix
	
	this.addElement = function (element){
		this.elements.push(element.evalJSON());
	}
	this.alertElements = function (){
		alert(this.elements);
	}

	this.search = function (text){
		var regexp = new RegExp(text, 'im');
		found = ''
		for(var i = 0; i < this.elements.length; i++){
			element = prefix + '-' + this.elements[i].project.id;
			element_name = this.elements[i].project.name;
			if( element_name.search(regexp) != -1 ){
				if($(element).getStyle('display') == 'none')
					Effect.Appear($(element));
				if(element_name == text){
				found = element;
				}
					
			}else{
				if($(element).getStyle('display') != 'none')
					Effect.Fade(element, { duration : 0.2 });
			}
		}
		if(found != ''){
			Effect.ScrollTo(found);
			while($(found).getStyle('opacity') != 1){
			}
			Effect.Pulsate(found, {pulsates: 3, duration: 1.3});

		}
		
	}

}