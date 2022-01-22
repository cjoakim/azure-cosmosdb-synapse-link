/*
 * This Java source file was generated by the Gradle 'init' task.
 */
package org.cjoakim.cosmos.mongo;

import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCursor;
import org.bson.Document;

public class App {

    public String getGreeting() {
        return "Hello World!";
    }

    public static void main(String[] args) {

        if (args.length < 1) {
            log("No command-line args; terminating...");
        }
        else {
            try {
                AppConfig.setCommandLineArgs(args);
                String function = args[0];
                AppConfig.display(false);
                String dbname;
                String cname;
                String pk;
                String id;

                switch (function) {

                    case "app_config":
                        displayAppConfig();
                        break;

                    case "find_by_pk":
                        dbname = args[1];
                        cname  = args[2];
                        pk     = args[3];
                        findByPk(dbname, cname, pk);
                        break;

                    case "find_by_id_pk":
                        dbname = args[1];
                        cname  = args[2];
                        id     = args[3];
                        pk     = args[4];
                        findByIdPk(dbname, cname, id, pk);
                        break;

                    default:
                        log("unknown main function: " + function);
                }
            }
            catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private static void displayAppConfig() {

        AppConfig.display(false);
    }

    private static void findByPk(String dbname, String cname, String pk) throws Exception {

        Mongo m = new Mongo();
        m.setDatabase(dbname);
        m.setCollection(cname);
        FindIterable<Document> documents = m.findByPk(pk);
        MongoCursor<Document> cursor = documents.iterator();
        while (cursor.hasNext()) {
            log(cursor.next().toJson());
        }
    }

    private static void findByIdPk(String dbname, String cname, String id, String pk) throws Exception {

        Mongo m = new Mongo();
        m.setDatabase(dbname);
        m.setCollection(cname);
        Document doc = m.findByIdPk(id, pk);
        if (doc == null) {
            log("zero documents");
        }
        else {
            log(doc.toJson());
        }
    }

    private static void log(String msg) {

        System.out.println(msg);
    }
}
