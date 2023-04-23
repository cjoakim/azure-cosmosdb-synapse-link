package org.cjoakim.cosmos.mongo;

/**
 * This class is the central point in the application for all configuration values,
 * such as environment variables, command-line arguments, and computed filesystem
 * locations.
 *
 * Chris Joakim, Microsoft
 */

public class AppConfig {

    // Constants, environment variable names:
    public static final String AZURE_COSMOSDB_MONGODB_CONN_STRING  = "AZURE_COSMOSDB_MONGODB_CONN_STRING";

    // Class variables:
    private static String[] commandLineArgs = new String[0];

    public static void display(boolean extended) {

        log("AppConfig commandLineArgs.length: " + commandLineArgs.length);
        for (int i = 0; i < commandLineArgs.length; i++) {
            System.out.println("  arg " + i + " -> " + commandLineArgs[i]);
        }
        if (extended) {
            log("AppConfig mongoConnectionString: " + getMongoConnectionString());
        }
    }

    public static void setCommandLineArgs(String[] args) {

        if (args != null) {
            commandLineArgs = args;
        }
    }

    public static boolean booleanArg(String flagArg) {

        for (int i = 0; i < commandLineArgs.length; i++) {
            if (commandLineArgs[i].equalsIgnoreCase(flagArg)) {
                return true;
            }
        }
        return false;
    }

    public static String flagArg(String flagArg) {

        for (int i = 0; i < commandLineArgs.length; i++) {
            if (commandLineArgs[i].equalsIgnoreCase(flagArg)) {
                return commandLineArgs[i + 1];
            }
        }
        return null;
    }

    public static long longFlagArg(String flagArg, long defaultValue) {

        try {
            return Long.parseLong(flagArg(flagArg));
        }
        catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static boolean isVerbose() {

        return booleanArg("--verbose");
    }

    public static String getEnvVar(String name) {

        return System.getenv(name);
    }

    public static String getMongoConnectionString() {

        return System.getenv(AZURE_COSMOSDB_MONGODB_CONN_STRING);
    }

    private static void log(String msg) {

        System.out.println(msg);
    }
}
