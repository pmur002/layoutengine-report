// Do NOT have empty line at start of template, or whisker::whisker.render()
// will just return "" (!)
// Log function
dblog = function(msg) {
    console.log("++ RDOM JS: " + msg);
}
// Must load page from R server before trying to create websocket
// (otherwise violate the "Same Origin Policy")
var page = require('webpage').create();
page.onConsoleMessage = function(msg) {
    console.log(msg);
}
// Set page size
page.viewportSize = {
    width: 800,
    height: 600
};
// NOTE that phantomjs wants 127.0.0.1 not 'localhost'
// ALSO phantomjs (2) wants http: protocol explicit 
// (otherwise it appears to assume file: protocol)
page.open("http://127.0.0.1:61990/", 
          function(status) {
              if (status === "success") {
                  // Load css-selector-generator library
                  page.injectJs("/home/pmur002/R/x86_64-pc-linux-gnu-library/3.4/DOM/JS/css-selector-generator.min.js");
                  page.injectJs("/home/pmur002/R/x86_64-pc-linux-gnu-library/3.4/DOM/JS/bowser.min.js");
                  page.injectJs("/home/pmur002/R/x86_64-pc-linux-gnu-library/3.4/DOM/JS/RDOM.js");
                  // dblog("opening socket")
                  page.evaluate(
                      function(host, port, tag) { 
                          RDOM.init(host, port, tag) 
                      }, 
                      "127.0.0.1", "61990", "6");
                  // dblog("socket initialised");
                  // Kill PhantomJS when websocket closes
                  page.onCallback = function(data) { 
                      if (data.type === "RENDER") {
                          // RDOM.js has been asked to render page
                          // Set default font to match visual browsers
                          page.evaluate(function() {
                              document.body.style.fontFamily = 'sans-serif';
                          });
                          page.render(data.outfile, 
                                      { format: 'png', quality: '100' });
                      } else if (data.type === "EXIT") {
                          // RDOM.js has closed the socket connection
                          phantom.exit() 
                      }
                  };
              } else {
                  // dblog("Failed to load page");
              }
          });
