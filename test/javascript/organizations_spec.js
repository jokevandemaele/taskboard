jQuery.noConflict();

require("spec_helper.js");
require("../../public/javascripts/prototype.js", {onload: function() {
    require("../../public/javascripts/application.js");
    require("../../public/javascripts/helpers/organizations.js");
    require("../../public/javascripts/startup.js");
}});

Screw.Unit(function(){
  describe("Organizations Helper", function(){
    // it("should setup a listener to add an organization ", function(){
    //   expect($('body').).to(equal, "hello");
    // });
    // 
    // it("accesses the DOM from fixtures/application.html", function(){
    //   expect($('.select_me').length).to(equal, 2);
    // });
  });
});

