function toggle_color_picker() {
  //$('admin-div-color-picker').style.display = ($('admin-div-color-picker').style.display == 'none') ? '' : 'none';
  if($('admin-div-color-picker').style.display == 'none') {
    $('admin-div-color-picker').style.display = '';
    $('admin-member-color-choose').innerHTML = 'close';
  }
  else {
    $('admin-div-color-picker').style.display = 'none';
    $('admin-member-color-choose').innerHTML = 'choose';
  }
}

function dec2hex(dec) {
  var hexits = '0123456789abcdef';
  var hex = '';
  if(dec == 0)
    return '00';
  while(dec > 0) {
    hex = hexits.charAt(dec % 16) + hex;
    dec = Math.floor(dec / 16);
  }
  if(hex.length % 2 != 0)
    hex = '0' + hex;
  return hex;
}

function rgb2hex(rgb) {
  var colors = rgb.substring(4, rgb.length - 1).split(', ');
  return '' + dec2hex(colors[0]) + dec2hex(colors[1]) + dec2hex(colors[2]);
}

function set_color(html_object, target_object) {
  var color = html_object.style.backgroundColor;
  if(color.charAt(0) == '#')
    color = color.substr(1);
  else
    color = rgb2hex(color);
  $(target_object).style.backgroundColor = $(target_object).style.color = '#' + color;
  $(target_object).value = color;
}

function generate_color_table(target_object) {
  var content = '<table><tbody>';
  var color;
  var i, j, k, colors_index = 0;
  var colors = new Array('ff0000', 'd70000', 'af0000', '870000', '5f0000', '370000',
                          'ffff00', 'd7d700', 'afaf00', '878700', '5f5f00', '373700',
                          '00ff00', '00d700', '00af00', '008700', '005f00', '003700',
                          '00ffff', '00d7d7', '00afaf', '008787', '005f5f', '003737',
                          '0000ff', '0000d7', '0000af', '000087', '00005f', '000037',
                          'ff00ff', 'd700d7', 'af00af', '870087', '5f005f', '370037'
                          );

  colors_index = 0;
  for(i = 0; i < 6; i++) {
    content += '<tr>';
    for(j = 0; j < 6; j++) {
          content += '<td onclick="set_color(this, \'' + target_object + '\'); toggle_color_picker();" style="background: #' + colors[colors_index++] + '">&nbsp;</td>';
    }
    content += '</tr>';
  }
  content += '</tbody></table>';
  return content;
}

