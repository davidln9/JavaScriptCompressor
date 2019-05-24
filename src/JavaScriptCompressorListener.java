
public class JavaScriptCompressorListener extends JavaScriptBaseListener {
	
	public JavaScriptCompressorListener() {
		System.out.println("hi");
	}
	
	@Override
	public void exitR(JavaScriptParser.RContext ctx) {
		System.out.println("Yikes");
	}

}
