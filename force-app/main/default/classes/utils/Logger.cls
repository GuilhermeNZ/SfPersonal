/**
 * @author ercarval - TOPI
 */
public class Logger {

    public static void log ( String message ) {
        System.debug( LoggingLevel.INFO, message );
    }

    public static void error ( String message ) {
        System.debug( LoggingLevel.ERROR, message );
    }

    public static void debug ( String message ) {
        System.debug( LoggingLevel.DEBUG, message );
    }

    public static void warn ( String message ) {
        System.debug( LoggingLevel.WARN, message );
    }

}