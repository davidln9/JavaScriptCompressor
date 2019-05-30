

public class JavaScriptCompressorListener extends JavaScriptParserBaseListener {

	private boolean eventTrace;
	public JavaScriptCompressorListener() {
		eventTrace = false;
	}
	public JavaScriptCompressorListener(boolean verbose) {
		eventTrace = verbose;
	}
	
	@Override
	public void exitProgram(JavaScriptParser.ProgramContext ctx) {
		System.out.println("Program parsed");
	}
	
	@Override
	public void exitVariableStatement(JavaScriptParser.VariableStatementContext ctx) {
		if (eventTrace) { System.out.println("listener -> exitVariableStatement"); }
		
		System.out.println(ctx.varModifier().getText());
		System.out.println(ctx.variableDeclarationList().getText());
	}
	
	@Override
	public void exitStatement(JavaScriptParser.StatementContext ctx) {
		if (eventTrace) { System.out.println("listener -> exitStatement"); }
	}
	
	@Override
	public void exitSourceElement(JavaScriptParser.SourceElementContext ctx) {
		if (eventTrace) { System.out.println("listener -> exitSourceElement"); }
	}
}
