Application.Helpers.ModalDialog = {
  initialize: function() {
    this.visible = false;
    this.onCancel = null;

    this._initializeBackdrop();
    this._installKeyBindings();
  },

  showBackdrop: function() {
    if (this.visible) return;
    this.backdrop.appear({duration: 0.2, fps: 20, from: 0, to: 0.75});
    this.visible = true;
  },

  hideBackdrop: function() {
    if (!this.visible) return;
    this.backdrop.fade({duration: 0.2, fps: 20, from: 0.75, to: 0});
    this.visible = false;
  },

  getContentsContainer: function() {
    return this.contents;
  },

  /*
   * Opens a modal dialog with the given content and options.
   *
   * Content can be either a string or a DOM element.
   *
   * If the content contains a form, an event listener will be binded
   * on submit and the dialog will be automatically closed when after
   * the form is sent (unless the ignoreForm option is true).
   *
   * Also, if a form is present its first field will be automatically
   * selected.
   *
   * Options:
   *
   * * onCancel - a callback triggered when the dialog close button is
   *   clicked.
   *
   * * ignoreFormSubmit - if set to true, no listener will be attached to
   *   the form (if present) to automatically close the dialog.
   *
   */
  open: function(content, options) {
    this._initializeContentBox();

    options = options || {};

    this.onCancel = options.onCancel;

    this.showBackdrop();
    this.contents.update(content);

    var form = this.contents.down('form');

    if (form) {
      if (!options.ignoreFormSubmit) {
        /*
        Event.observe(form, 'submit', (function() {
          this.close();
        }).bind(this));
        */
      }

      Form.focusFirstElement(form);
    }

    this.contentBox.show();
    this.redraw();
  },

  ajaxLoad: function(url, ajaxOptions, dialogOptions) {
    ajaxOptions = ajaxOptions || {};

    if (!ajaxOptions.method) ajaxOptions.method = 'get';

    var oldOnSuccess = ajaxOptions.onSuccess;

    ajaxOptions.onSuccess = (function(transport) {
      this.open(transport.responseText, dialogOptions);
      if (oldOnSuccess) oldOnSuccess(transport);
    }).bind(this);

    return new Ajax.Request(url, ajaxOptions);
  },

  close: function() {
    this.contentBox.hide();
    this.hideBackdrop();
  },

  redraw: function() {
    var viewportDimensions = document.viewport.getDimensions();
    var scrollOffsets = document.viewport.getScrollOffsets();

    this.contentBox.setStyle({
      left: (viewportDimensions.width / 2 - this.contentBox.offsetWidth / 2) + 'px',
      top: (viewportDimensions.height / 2 - this.contentBox.offsetHeight / 2) + 'px'
    });
  },

  yes_no: function(text, yes_function, no_function){
    var container = new Element('div', {id : 'yesNoContainer', 'class' : 'yesNoContainer'});
    var question = new Element('h1').update(text);
    container.insert({bottom: question});
    var yes = new Element('div', {id: 'yes', 'class' : 'yes'});
    container.insert({bottom: yes});
    var no = new Element('div', {id: 'no', 'class' : 'no'});
    container.insert({bottom: no});    
    var clear = new Element('div', {'class' : 'clear'});
    
    // Add listeners
    yes.observe('click', function(){ ModalDialog.close(); yes_function(); });
    no.observe('click', function(){ ModalDialog.close(); });

    this.open(container);
    $('modal_dialog').down('.close_button').hide();
    
  },
  
  displayFormErrors: function(errors) {
    var errorsHTML = new Element('ul');
    var errorLi;

    errors.each(function(error) {
      errorLi = new Element('li').update(error[0] + ' ' + error[1]);
      errorsHTML.appendChild(errorLi);
    });

    var formErrorsDiv;
    if(!(formErrorsDiv = this.contentBox.down('.form_errors'))) {
      formErrorsDiv = new Element('div', {'class': 'form_errors'});
      this.contentBox.down('form').insert({top: formErrorsDiv});
    }
    formErrorsDiv.update(errorsHTML);
    formErrorsDiv.show();
  },

  _initializeBackdrop: function() {
    var backdrop = this.backdrop = new Element('div', {id : 'backdrop'}).hide();
    document.observe('dom:loaded', function() {
      document.body.appendChild(backdrop);
    });
  },

  _initializeContentBox: function() {
    if (this.contentBox) return;

    var container = this.contentBox = new Element('div', {id: 'modal_dialog'});
    container.addClassName('admin_container');
    $w('tl t tr bl b br c close_button').each(function(className) {
      container.insert(new Element('div', {'class': className}));
    });

    container.down('.close_button').writeAttribute('title', 'Close').onclick = (function() {
      if (this.onCancel) this.onCancel();
      this.close();
    }).bind(this);

    this.contents = container.down('.c');

    document.body.appendChild(container);

    // Register an on resize event to recenter the box
    Event.observe(window, 'resize', (function() {
      this.redraw();
    }).bind(this));
  },

  _installKeyBindings: function() {
    this.keyBinding = Event.observe(window, 'keydown', (function(event) {
      if (this.visible && event.keyCode == Event.KEY_ESC) {
        if (this.onCancel) this.onCancel();
        this.close();
      }
    }).bind(this));
  }
};

// Provide a pretty shortcut
ModalDialog = Application.Helpers.ModalDialog;
