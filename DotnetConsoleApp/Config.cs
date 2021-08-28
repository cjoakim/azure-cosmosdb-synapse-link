// Chris Joakim, Microsoft, August 2021

namespace CosmosSL {

    using System;
    using Newtonsoft.Json;

    /**
     * This class is the source of all configuration values for this application -  
     * including environment variables and command-line arguments.  It does this 
     * to support either command-line/terminal/shell or Docker container execution.   
     * With Docker, the command-line can be passed in as environment variable 'CLI_ARGS_STRING'.
     */
    public class Config{
        // Constants; environment variable names:
        public const string AZURE_CSL_REPO_DIR_MAC                = "AZURE_CSL_REPO_DIR_MAC";
        public const string AZURE_CSL_REPO_DIR_WIN                = "AZURE_CSL_REPO_DIR_WIN";
        public const string AZURE_CSL_REPO_DIR_LINUX              = "AZURE_CSL_REPO_DIR_LINUX";
        public const string AZURE_CSL_COSMOSDB_SQLDB_ACCT         = "AZURE_CSL_COSMOSDB_SQLDB_ACCT";
        public const string AZURE_CSL_COSMOSDB_SQLDB_CONN_STRING  = "AZURE_CSL_COSMOSDB_SQLDB_CONN_STRING";
        public const string AZURE_CSL_COSMOSDB_SQLDB_DBNAME       = "AZURE_CSL_COSMOSDB_SQLDB_DBNAME";
        public const string AZURE_CSL_COSMOSDB_SQLDB_CNAME        = "AZURE_CSL_COSMOSDB_SQLDB_CNAME";
        public const string AZURE_CSL_COSMOSDB_SQLDB_KEY          = "AZURE_CSL_COSMOSDB_SQLDB_KEY";
        public const string AZURE_CSL_COSMOSDB_SQLDB_URI          = "AZURE_CSL_COSMOSDB_SQLDB_URI";
        public const string AZURE_CSL_COSMOSDB_SQLDB_PREF_REGIONS = "AZURE_CSL_COSMOSDB_SQLDB_PREF_REGIONS";
        public const string AZURE_CSL_COSMOSDB_BULK_BATCH_SIZE    = "AZURE_CSL_COSMOSDB_BULK_BATCH_SIZE";
        
        // Constants; command-line and keywords:
        public const string INFILE_KEYWORD                 = "--infile";
        public const string VERBOSE_FLAG                   = "--verbose";

        // Class variables:
        private static Config singleton;

        // Instance variables:
        private string[] cliArgs = { };

        public static Config Singleton(string[] args) {  // called by Program.cs Main()
            if (singleton == null) {
                singleton = new Config(args);
            }
            return singleton;
        }

        public static Config Singleton() {  // called elsewhere
            return singleton;
        }

        private Config(string[] args) {
            cliArgs = args;  // dotnet run xxx yyy -> args:["xxx","yyy"]
        }

        public bool IsValid() {
            Console.WriteLine("Config#IsValid args: " + JsonConvert.SerializeObject(cliArgs));
            if (cliArgs.Length < 2) {
                Console.WriteLine("ERROR: empty command-line args");
                return false;
            }
            return true;
        }

        public string[] GetCliArgs() {
            return cliArgs;
        }

        public string GetRepoDir() {
            string osNameAndVersion = System.Runtime.InteropServices.RuntimeInformation.OSDescription;
            Console.WriteLine($"osNameAndVersion: {osNameAndVersion}");
            if (osNameAndVersion.Contains("Darwin")) {
                return GetEnvVar(AZURE_CSL_REPO_DIR_MAC, null);  
            }
            else if (osNameAndVersion.Contains("Win")) {
                return GetEnvVar(AZURE_CSL_REPO_DIR_WIN, null);
            }
            else {
                return GetEnvVar(AZURE_CSL_REPO_DIR_LINUX, null);
            }
        }

        public string GetCosmosConnString() {
            return GetEnvVar(AZURE_CSL_COSMOSDB_SQLDB_CONN_STRING, null);
        }

        public string GetCosmosUri() {
            return GetEnvVar(AZURE_CSL_COSMOSDB_SQLDB_URI, null);
        }

        public string GetCosmosKey() {
            return GetEnvVar(AZURE_CSL_COSMOSDB_SQLDB_KEY, null);
        }

        public string GetCosmosDbName() {
            return GetEnvVar(AZURE_CSL_COSMOSDB_SQLDB_DBNAME, null);
        }

        public string[] GetCosmosPreferredRegions() {
            string delimList = GetEnvVar(AZURE_CSL_COSMOSDB_SQLDB_PREF_REGIONS, null);
            if (delimList == null) {
                return new string[] { };
            }
            else {
                return delimList.Split(',');
            }
        }

        public string GetEnvVar(string name) {
            return Environment.GetEnvironmentVariable(name);
        }

        public string GetEnvVar(string name, string defaultValue = null) {
            string value = Environment.GetEnvironmentVariable(name);
            if (value == null) {
                return defaultValue;
            }
            else {
                return value;
            }
        }

        public string GetCliKeywordArg(string keyword, string defaultValue = null) {
            try {
                for (int i = 0; i < cliArgs.Length; i++) {
                    if (keyword == cliArgs[i]) {
                        return cliArgs[i + 1];
                    }
                }
                return defaultValue;
            }
            catch {
                return defaultValue;
            }
        }

        public bool HasCliFlagArg(string flag) {
            for (int i = 0; i < cliArgs.Length; i++) {
                if (cliArgs[i].Equals(flag)) {
                    return true;
                }
            }
            return false;
        }

        public int BulkBatchSize() {
            string val = GetEnvVar(AZURE_CSL_COSMOSDB_BULK_BATCH_SIZE, null);
            int defaultValue = 100;
            if (val == null) {
                return defaultValue;
            }
            else {
                try {
                    return Int32.Parse(val);
                }
                catch {
                    return defaultValue;
                }
            }
        }

        public bool IsVerbose() {
            for (int i = 0; i < cliArgs.Length; i++) {
                if (cliArgs[i] == VERBOSE_FLAG) {
                    return true;
                }
            }
            return false;
        }

        public void Display() {
            Console.WriteLine($"Config, args: {JsonConvert.SerializeObject(GetCliArgs())}");
        }
    }
}
