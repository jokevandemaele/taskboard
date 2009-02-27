// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

(document.getElementById) ? dom = true : dom = false;

function keepDivOnTop(div) {
	$(div).style.top = window.pageYOffset + (window.innerHeight - (window.innerHeight)) + "px";
	$(div).style.left = window.pageXOffset + (window.innerWidth - (window.innerWidth)) + "px";

	window.setTimeout("keepDivOnTop('"+div+"')", 10); 
}

function expandMenu(){
	$('taskboard_menu_expand').hide();
	$('taskboard_menu_space').show();
	Effect.Appear($('taskboard_menu'), { duration: 0.4 });
}

function collapseMenu(){
	Effect.Fade($('taskboard_menu'), { duration: 0.4 });
	$('taskboard_menu_space').hide();
	Effect.Appear($('taskboard_menu_expand'), { duration: 0.4 });
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

