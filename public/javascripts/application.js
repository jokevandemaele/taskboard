/*
 * Application acts as a singleton providing a namespace
 * for all application-specific code plus some basic functionality
 */
Application = {
  // Application settings go here
  config: {},

  env: {},

  urls: {},

  locales: {},

  // Application helpers go here
  Helpers: {},

  // Call #initialize for each defined helper
  initialize: function(options) {
    if (options.config) this.addConfig(options.config);
    if (options.env) this.addEnv(options.env);
    if (options.urls) this.addUrls(options.urls);
    if (options.locales) this.addLocales(options.locales);

    // Initialize helpers
    for (helper in Application.Helpers) {
      // Call #initialize
      if (Application.Helpers[helper].initialize) {
        Application.Helpers[helper].initialize();
      }

      // Set _moduleName attribute (used in Application#error)
      Application.Helpers[helper]._moduleName = helper;
    }
  },

  addConfig: function(config) {
    Object.extend(this.config, config);
  },

  addEnv: function(env) {
    Object.extend(this.env, env);
  },

  addUrls: function(urls) {
    Object.extend(this.urls, urls);
  },

  // Report an error
  error: function(message, module) {
    if (Application.config.displayErrors === false) {
      return false;
    }

    var scope;

    if (module && module._moduleName) {
      scope = 'in module ' + module._moduleName;
    } else {
      scope = 'unknown scope';
    }

    // Default to Firebug console error, fallback to alert()
    ((window.console && window.console.error) || window.alert)(['Application error (', scope, '): ', message].join(''));
  }
};