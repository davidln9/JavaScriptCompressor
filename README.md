# JavaScriptCompressor
Take human-readable JavaScript and compress it.

This project uses the ANTLR4 IDE plugin for Eclipse. I recommend using the Eclipse IDE for Java EE developers because of the project facet properties, but it may not be necessary for pulling this.

When you clone this, be sure to set your plugin to antlr-4.x.x-complete.jar by going to properties->ANTLR4->Tool and checking "Enable project specific settings" and adding your download of the latest ANTLR release. Also you may have to specify your antlr jar file by going to properties->Java build path and choose "Add external jar"

The generated resources folder is empty on github, but it should be automatically built when you open the project by performing a save operation on the JavaScript.g4 file.
