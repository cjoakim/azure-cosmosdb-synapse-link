package org.cjoakim.cosmos.mongo;

/**
 * This class is the entry point to the application.
 *
 * Chris Joakim, Microsoft
 */

import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCursor;
import org.bson.Document;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.bson.json.JsonMode;
import org.bson.json.JsonWriterSettings;
import org.bson.types.ObjectId;

import java.io.IOException;
import java.util.Map;

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
                String pkattr;
                String infile;

                switch (function) {

                    case "app_config":
                        displayAppConfig();
                        break;

                    case "load_container":
                        dbname = args[1];
                        cname  = args[2];
                        pkattr = args[3];
                        infile = args[4];
                        loadContainer(dbname, cname, pkattr, infile);

                    case "find_by_pk":
                        dbname = args[1];
                        cname  = args[2];
                        pk     = args[3];
                        findByPk(dbname, cname, pk, AppConfig.booleanArg("--explain"));
                        break;

                    case "find_by_id_pk":
                        dbname = args[1];
                        cname  = args[2];
                        id     = args[3];
                        pk     = args[4];
                        findByIdPk(dbname, cname, id, pk, AppConfig.booleanArg("--explain"));
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

        AppConfig.display(true);
    }

    private static void loadContainer(String dbname, String cname, String pkattr, String infile) {

        try {
            boolean stream = AppConfig.booleanArg("--stream");
            boolean noLoad = AppConfig.booleanArg("--noLoad");
            long sleepMs = AppConfig.longFlagArg("--sleepMs", 0);  // default to 0 mmms sleep
            log("stream: " + stream + " sleepMs: " + sleepMs);

            Mongo m = new Mongo();
            m.setDatabase(dbname);
            m.setCollection(cname);

            Scanner scanner = new Scanner(new File(infile));
            ObjectMapper mapper = new ObjectMapper();
            while (scanner.hasNextLine()) {
                if (stream) {
                    if (sleepMs > 0) {
                        Thread.sleep(sleepMs);
                    }
                }
                String jsonLine = scanner.nextLine();
                Map<String, Object> map = mapper.readValue(jsonLine.strip(), Map.class);
                String pk = map.get(pkattr).toString();
                map.put("_id", new ObjectId());
                map.put("pk", pk);
                //log(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(map));
                Document doc = new Document(map);
                log(doc.toJson());
                if (!noLoad) {
                    m.insertDoc(doc);
                }
            }
            scanner.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void findByPk(String dbname, String cname, String pk, boolean explain)
            throws Exception {

        Mongo m = new Mongo();
        m.setDatabase(dbname);
        m.setCollection(cname);
        FindIterable<Document> documents = m.findByPk(pk, explain);
        MongoCursor<Document> cursor = documents.iterator();

        JsonWriterSettings jws = JsonWriterSettings.builder()
                .indent(true)
                .outputMode(JsonMode.SHELL)
                .build();

        while (cursor.hasNext()) {
            log(cursor.next().toJson(jws));
        }
        if (AppConfig.isVerbose()) {
            log("RU: " + m.getLastRequestCharge());
        }
    }

    private static void findByIdPk(String dbname, String cname, String id, String pk, boolean explain)
            throws Exception {

        Mongo m = new Mongo();
        m.setDatabase(dbname);
        m.setCollection(cname);
        Document doc = m.findByIdPk(id, pk, explain);
        if (doc == null) {
            log("zero documents");
        }
        else {
            log(doc.toJson());
        }
        if (AppConfig.isVerbose()) {
            log("Stats: " + m.getLastRequestStatistics());
            log("RU:    " + m.getLastRequestCharge());
        }
    }

    private static void log(String msg) {

        System.out.println(msg);
    }
}
