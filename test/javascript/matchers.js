Screw.Matchers["be_shown"] = {
  match: function(actual) {
    return actual.visible == true;
  },
  failure_message: function(expected, actual, not) {
    return 'expected ' + $.print(actual) + 'to be shown';
  }
}