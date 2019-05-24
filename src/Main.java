import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.antlr.v4.runtime.tree.ParseTree;

public class Main {
	public static void main(String[] args) throws Exception {
		System.out.println("hello");
		JavaScriptCompressorListener listener = new JavaScriptCompressorListener();
		
		ANTLRInputStream input = new ANTLRInputStream(System.in);
		
		JavaScriptLexer lexer = new JavaScriptLexer(input);
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		
		JavaScriptParser parser = new JavaScriptParser(tokens);
		ParseTree tree = parser.r();
		
		ParseTreeWalker walker = new ParseTreeWalker();
		
		walker.walk(listener, tree);
		
		System.out.println(tree.toStringTree());
	}
}
