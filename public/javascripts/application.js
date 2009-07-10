// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

(document.getElementById) ? dom = true : dom = false;

// Admin Section
function expandCollapseDivs(ids){
	ids.each(
		function(elem){ 
			if($(elem).visible())
			{
				Effect.SlideUp(elem, {duration: 0.3});
			}else{
				Effect.SlideDown(elem, {duration: 0.3});
			}
		})
}

function cancelForm(id){
	Effect.Fade($(id), { duration: 0.2 }); 
	Effect.Fade($('dialog-background-fade'), { duration: 0.2 });
}

function updateName(type,object){
	object_id = type + "-" + object.id + "-name";
	$(object_id).innerHTML = object.name;
	Effect.Fade($('dialog-background-fade'), { duration: 0.2 });
    new Effect.Highlight(object_id, { startcolor: '#ffff99', endcolor: '#d5e5ff' });
}

function adminToggleImage(id){
	member = $(id);
	if(member.src.search('/images/admin/admin-div-element-make-admin.png') != -1){
		member.src = '/images/admin/admin-div-element-remove-admin.png';
    member.title = 'remove admin';
	}else{
		member.src = '/images/admin/admin-div-element-make-admin.png';
    member.title = 'make admin';
	}
}
// End Admin Section

function resizeFontSizeToFitParent(id){
		//size = $(id).getStyle('font-size').replace("px","")
		//alert($(id).parent);
		//if($id.offsetHeight > )
}

function keepDivOnTop(div) {
	$(div).style.top = window.pageYOffset + "px";
	$(div).style.left = window.pageXOffset + "px";

	window.setTimeout("keepDivOnTop('"+div+"')", 10); 
}

function expandMenu(){
	$('menu_expand').hide();
	$('menu_space').show();
	Effect.Appear($('menu'), { duration: 0.4 });
}

function collapseMenu(application){
	Effect.Fade($('menu'), { duration: 0.4 });
	$('menu_space').hide();
	Effect.Appear($('menu_expand'), { duration: 0.4 });
}

function x(element){
	return $(element).cumulativeOffset().left
}

function y(element){
	return $(element).cumulativeOffset().top
}

function positionCreateX(draggable, droppable){
	return (x(draggable) - (x(droppable) - window.pageXOffset) - 9);
}

function positionCreateY(draggable, droppable, nametag){
	if(nametag){
		image_offset = 88;
	}else{
		image_offset = 0;
	}
	return (y(draggable)- (y(droppable) - window.pageYOffset) + image_offset);
}

function positionUpdateX(draggable, droppable){
	return (x(draggable) - (x(droppable)));
}

function positionUpdateY(draggable, droppable, nametag){
	return (y(draggable)- (y(droppable)));
}

function timedRefresh(timeoutPeriod) {
	setTimeout("location.reload(true);",timeoutPeriod);
}

function flip(id,side){
	if(side == 'back'){
		$(id).hide();
		$(id + '-back').show();
	}else{
		$(id + '-back').hide();
		$(id).show();
	}
}

function centerTo(element, center_to){
	new Effect.Move(element, { x: ((center_to.getWidth() - element.getWidth()) / 2) , y: ((center_to.getHeight() - element.getHeight()) / 2), mode: 'absolute', duration: 0});

}

function cancel(element){
	Effect.Fade(element, { duration: 0.3 }); 
	$('adder-container').hide();
}

function setColor(id,color){
	$(id).value = color;
	$(id).setStyle({ background: '#'+color, color: '#'+color});
}

function droppable_position(){
(Droppables.drops[0].accept)
}
