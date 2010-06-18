(document.getElementById) ? dom = true : dom = false;

function resizeFontSizeToFit(element,container){
   font_size = element.getStyle('font-size').replace('px', '');
   line_height = element.getStyle('line-height').replace('px', '');
   elementW = element.offsetWidth;
   elementH = element.offsetHeight;
   containerW = container.offsetWidth;
   containerH = container.offsetHeight;
   while(elementW > containerW || elementH > containerH){
     font_size -= 1;
     line_height -= 1;
     element.setStyle({fontSize: font_size + 'px'});
     element.setStyle({lineHeight: line_height + 'px'});
     elementW = element.offsetWidth;
     elementH = element.offsetHeight;
     containerW = container.offsetWidth;
     containerH = container.offsetHeight;
   }
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
 return (x(draggable) - (x(droppable) - window.pageXOffset));
}

function positionCreateY(draggable, droppable, nametag){
 if(nametag){
   image_offset = 58;
 }else{
   image_offset = 0;
 }
 return (y(draggable)- (y(droppable) - window.pageYOffset) + image_offset);
}

function positionUpdateX(draggable, droppable){
 return ((draggable.left + draggable.width) - (x(droppable)));
}

function positionUpdateY(draggable, droppable){
 return (draggable.bottom - (y(droppable)));
}

function timedRefresh(timeoutPeriod) {
 setTimeout("location.reload(true);",timeoutPeriod);
}

function flip(id,side){
 if(side == 'back'){
   $(id).hide(); 
   $(id+"-flip").hide();
   $(id + '-back').show();
 }else{
   $(id + '-back').hide();
   $(id).show();
   $(id+"-flip").show();
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
