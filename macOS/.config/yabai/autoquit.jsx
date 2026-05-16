#!/usr/bin/osascript -l JavaScript
var app = Application.currentApplication();
app.includeStandardAdditions = true;

delay(0.1);

var windowPIDs = new Set(
  JSON.parse(app.doShellScript("yabai -m query --windows"))
    .filter(function(w) { return w.title && w.title.length > 0; })
    .map(function(w) { return w.pid; })
);

console.log("Window PIDs:", [...windowPIDs].join(", "));

var SE = Application("System Events");
var procs = SE.processes.whose({backgroundOnly: false});
var exclude = new Set(["Finder","Dock","SystemUIServer","ControlCenter","Signal","Spotlight","Messages","Mail"]);
for (var i = 0; i < procs.length; i++) {
  var p = procs[i];

  console.log("Checking:", p.name(), "PID:", p.unixId(), "Has window?", windowPIDs.has(p.unixId()));

  if (!windowPIDs.has(p.unixId()) && !exclude.has(p.name())) {
    console.log("Quitting:", p.name(), p.bundleIdentifier());

    var bid = p.bundleIdentifier();
    if (bid) try { Application(bid).quit(); } catch(e) {}

    //app.doShellScript("/bin/kill -TERM " + p.unixId());
  }
}
