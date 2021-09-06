package ssa.ssa;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

public class Settings {
    static Properties props =  new Properties();

    static void load() {
        try (FileInputStream file = new FileInputStream("../config/server.properties")) {
            Settings.props.load(file);
            System.out.println("Max tick time: " + Settings.props.getProperty("max-tick-time"));
        } catch (FileNotFoundException ex) {
            System.out.println(ex.getMessage());
            // Handle missing properties file errors.
        } catch (IOException ex) {
            System.out.println(ex.getMessage());
            // Handle IO errors.
        }
        // Need to do some work to close the stream.
        // Handle IO errors or log a warning.
    }
}
