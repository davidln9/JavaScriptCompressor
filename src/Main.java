import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.antlr.v4.runtime.tree.ParseTree;
import java.util.List;
import java.io.File;
import java.io.FileInputStream;

public class Main {
	public static void main(String[] args) throws Exception {
		
		CommandLineParser cmdLine = new CommandLineParser();
		cmdLine.parseCommandLineOptions(args);
		
		JavaScriptCompressorListener listener = new JavaScriptCompressorListener(true);
		
		ANTLRInputStream input = new ANTLRInputStream(cmdLine.getInputStream());
		
		JavaScriptLexer lexer = new JavaScriptLexer(input);
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		
		JavaScriptParser parser = new JavaScriptParser(tokens);
		
		
		parser.addErrorListener(new DiagnosticErrorListener(true));
		ParseTree tree = parser.program();
		
		ParseTreeWalker walker = new ParseTreeWalker();
		System.out.println(tokenString(tokens.getTokens()));
		
		walker.walk(listener, tree);
		

		
	}
	
	public static String tokenString(List<Token> tokens) {
		
		StringBuilder sb = new StringBuilder();
		
		int iter = 0; // keep track of DEFAULT_CHANNEL token index
		for (Token tk : tokens) {
			if (tk.getChannel() == Token.DEFAULT_CHANNEL) {
				sb.append("{Token[" + iter + "] @(" + tk.getLine() + "," +
						tk.getCharPositionInLine() + "): \'" + tk.getText() + "\'}");
				sb.append(String.format("%n"));
				iter++;
			}
		}
		return sb.toString();
	}
}
