package org.cjoakim.cosmos.mongo;

import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import com.mongodb.client.result.InsertOneResult;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.json.JsonWriterSettings;
import org.bson.types.ObjectId;

import java.util.HashMap;

/**
 * This class implements CosmosDB/Mongo database operations
 *
 * Chris Joakim, Microsoft
 */

public class Mongo {

    // Instance variables:
    private MongoClient mongoClient;
    private MongoDatabase currentDatabase;
    private MongoCollection<Document> currentCollection;
    private JsonWriterSettings jws;

    public Mongo() throws Exception {

        super();
        mongoClient = MongoClients.create(AppConfig.getMongoConnectionString());
        jws = JsonWriterSettings.builder().indent(true).build();
    }

    public void setDatabase(String name) {

        this.currentDatabase = mongoClient.getDatabase(name);
    }

    public void setCollection(String name) {

        this.currentCollection = this.currentDatabase.getCollection(name);
    }

    public InsertOneResult insertDoc(HashMap map) {

        return this.insertDoc(new Document(map));
    }

    public InsertOneResult insertDoc(Document doc) {

        return this.currentCollection.insertOne(doc);
    }

    public FindIterable<Document> findByPk(String pk, boolean explain) {

        Bson pkFilter = Filters.eq("pk", pk);

        if (explain) {
            Document doc = this.currentCollection.find(pkFilter).explain();
            System.out.println(doc.toJson(jws));
        }
        return this.currentCollection.find(pkFilter);
    }

    public Document findByIdPk(String id, String pk, boolean explain) {

        Bson idFilter = Filters.eq("_id", id); //new ObjectId(id));
        Bson pkFilter = Filters.eq("pk", pk);

        if (explain) {
            Document doc = this.currentCollection.find(Filters.and(idFilter, pkFilter)).explain();
            System.out.println(doc.toJson(jws));
        }
        return this.currentCollection.find(Filters.and(idFilter, pkFilter)).first();
    }

    // https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb/find-request-unit-charge-mongodb#use-the-mongodb-java-driver

    public Document getLastRequestStatistics() {

        return this.currentDatabase.runCommand(new Document("getLastRequestStatistics", 1));
    }

    public double getLastRequestCharge() {

        Document stats = this.getLastRequestStatistics();
        if (stats != null) {
            return stats.getDouble("RequestCharge");
        }
        else {
            return -1.0;
        }
    }

}
