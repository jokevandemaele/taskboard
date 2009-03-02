// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

(document.getElementById) ? dom = true : dom = false;

function keepDivOnTop(div) {
	$(div).style.top = window.pageYOffset + "px";
	$(div).style.left = window.pageXOffset + "px";

	window.setTimeout("keepDivOnTop('"+div+"')", 10); 
}

function expandMenu(application){
	$(application+'_menu_expand').hide();
	$(application+'_menu_space').show();
	Effect.Appear($(application+'_menu'), { duration: 0.4 });
}

function collapseMenu(application){
	Effect.Fade($(application+'_menu'), { duration: 0.4 });
	$(application+'_menu_space').hide();
	Effect.Appear($(application+'_menu_expand'), { duration: 0.4 });
}

function x(element){
	return $(element).cumulativeOffset().left
}

function y(element){
	return $(element).cumulativeOffset().top
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
