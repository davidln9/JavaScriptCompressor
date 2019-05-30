import java.util.ArrayList;
import java.util.List;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

public class CommandLineParser {
	
	private File inputFile = null;
	private File outputFile = null;
	
	// default constructor
	public CommandLineParser() {}
	
	
	// METHODS
	
	/**
	 * parses the command line options.
	 * Checks for input and output files
	 * @param args
	 */
	public void parseCommandLineOptions(String[] args) {
		
		for (int i = 0; i < args.length; i++) {
			if (args[i].equals("-v") || args[i].equals("--version")) {
				printVersionInfo();
			} else if (args[i].equals("-i") || args[i].equals("--input")) {
				try {
					this.setInputFile(args[i+1]);
					i++;
				} catch (IndexOutOfBoundsException e) {
					System.err.println(e.getMessage());
					e.printStackTrace();
					System.exit(-1);
				}
			} else if (args[i].equals("-o") || args[i].equals("--output")) {
				try {
					this.setOutputFile(args[i+1]);
					i++;
				} catch (IndexOutOfBoundsException e) {
					System.err.println(e.getMessage());
					e.printStackTrace();
					System.exit(-1);
				}
			}
		}
	} // END parseCommandLineArguments
	
	private void setOutputFile(String outputFile) {
		this.outputFile = new File(outputFile);
		
	}
	
	private void setInputFile(String inputFile) {
		File f = new File(inputFile);
		if (!f.exists()) {
			System.err.println("FATAL: Input file does not exist");
			System.exit(-1);
		}
		
		int state = 0;
        String extension = "";
        
        // parser for file paths to get extension
        for (int i = 0; i < inputFile.length(); i++) {
            if (state == 0) {
                if (inputFile.charAt(i) == '.') {
                    state = 1;
                }
            } else if (state == 1) {
                if (inputFile.charAt(i) == '.') {
                    extension = "";
                } else if (inputFile.charAt(i) == '/') {
                    extension = "";
                    state = 0;
                } else {
                    extension += inputFile.charAt(i);
                }
            }
        }
        
        if (!extension.equals("js")) {
        	System.err.println("FATAL: Input file must be *.js");
        	System.exit(-1);
        }
		
		this.inputFile = new File(inputFile);
		return;
	} // END setInputFile()
	
	/*
	 * Display version information to the user
	 * currently the project is not released
	 */
	private void printVersionInfo() {
		System.out.println("Development build");
		return;
	} // END printVersionInfo()]
	
	public InputStream getInputStream() {
		if (inputFile != null) {
			try {
				return new FileInputStream(inputFile);
			} catch (Exception ex) {
				ex.printStackTrace();
				System.exit(-1);
				return null;
			}
		} else {
			return System.in;
		}
	}
	
	public File getOutputFile() {
		return this.outputFile;
	}
}
