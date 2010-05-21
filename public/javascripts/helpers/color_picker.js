Application.Helpers.ColorPicker = {
  initialize: function() {
    var colors = ['00ff00', '32cd32', '228b57', '3cb371', '00fa9a', '66cdaa',
                  '9acd32', 'ffd700', 'ffff00', 'eee8aa', 'f0e68c', 'bdb76b',
                  'ff69b4', 'ff1493', 'ff7f50', 'ff6347', 'dc143c', 'ff0000',
                  'd8bfd8', 'da70d6', 'ff00ff', 'ba55d3', '9966cc', '800080',
                  'b0c4de', 'add8e6', '00bfff', '1e90ff', '0000ff', '4682b4',
                  '7b68ee', '6a5acd', '483d8b', 'c0c0c0', 'a9a9a9', '708090'];

    this.colorPicker = new Element('div').writeAttribute(
      {'id': 'color-picker'}
    ).setStyle(
      {position: 'absolute', top: 0, left: 0, display: 'none'}
    ).update(
      new Element('table').setStyle(
        {'border-spacing': '4px', 'background': 'white'}
      )
    );

    for(var i = 0; i < 6; i++) {
      var tr = new Element('tr');
      for(var j = 0; j < 6; j++) {
        var td = new Element('td').writeAttribute(
          {'class': 'color-picker-cell'}
        ).setStyle(
          {'width': '24px', 'height': '24px', 'background': '#' + colors[i * 6 + j]}
        );
        tr.appendChild(td);
      }
      this.colorPicker.down('table').appendChild(tr);
    }
  },

  _show: function() {
    this.colorPicker.setStyle({display: ''});
  },

  _hide: function() {
    this.colorPicker.setStyle({display: 'none'});
  },

  _dec2hex: function(dec) {
    var hex = Number(dec).toString(16);
    return (hex.length % 2 == 0) ? hex : '0' + hex;
  },

  _rgb2hex: function(rgb) {
    var colors = rgb.substring(4, rgb.length - 1).split(', ');
    return '' + this._dec2hex(colors[0]) + this._dec2hex(colors[1]) + this._dec2hex(colors[2]);
  },

  attach: function(parent, top, left, target) {
    var _this = this;

    this.colorPicker.setStyle({'top': top, 'left': left});
    $(parent).appendChild(this.colorPicker);

    $(document.body).observe('click', function(event) {
      var eventTarget = event.element();
      if(eventTarget.match('#' + target))
        _this._show();
      else {
        if(eventTarget.match('.color-picker-cell'))
          _this._setColor(eventTarget, $(target));
        else
          _this._hide();
      }
    });
  },

  _setColor: function(htmlObject, targetObject) {
    var color = htmlObject.getStyle('background-color');
    if(color.charAt(0) == '#')
      color = color.substr(1);
    else
      color = this._rgb2hex(color);
    $(targetObject).value = color;
    color = '#' + color;
    $(targetObject).setStyle({'color': color, 'background-color': color});
    this._hide();
  }
};

// Provide a pretty shortcut
ColorPicker = Application.Helpers.ColorPicker;

