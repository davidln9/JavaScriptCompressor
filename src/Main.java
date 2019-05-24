import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.antlr.v4.runtime.tree.ParseTree;

public class Main {
	public static void main(String[] args) throws Exception {
		ECMAScriptCompressorListener listener = new ECMAScriptCompressorListener();
		
		ANTLRInputStream input = new ANTLRInputStream(System.in);
		
		ECMAScriptLexer lexer = new ECMAScriptLexer(input);
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		
		ECMAScriptParser parser = new ECMAScriptParser(tokens);
		parser.addErrorListener(new DiagnosticErrorListener(true));
		ParseTree tree = parser.program();
		
		ParseTreeWalker walker = new ParseTreeWalker();
		
		walker.walk(listener, tree);
		
	}
}
