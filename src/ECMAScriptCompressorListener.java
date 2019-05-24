

public class ECMAScriptCompressorListener extends ECMAScriptBaseListener {

	public ECMAScriptCompressorListener() {
		
	}
	
	@Override
	public void exitSourceElements(ECMAScriptParser.SourceElementsContext ctx) {
		System.out.println("Program parsed");
	}
}
