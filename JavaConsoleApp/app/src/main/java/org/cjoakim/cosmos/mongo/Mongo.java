package org.cjoakim.cosmos.mongo;

import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import com.mongodb.client.result.InsertOneResult;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;

import java.util.HashMap;

/**
 * This class implements CosmosDB/Mongo database operations
 *
 * Chris Joakim, Microsoft, January 2022
 */

public class Mongo {

    // Instance variables:
    private MongoClient mongoClient;
    private MongoDatabase currentDatabase;
    MongoCollection<Document> currentCollection;

    public Mongo() throws Exception {

        super();
        mongoClient = MongoClients.create(AppConfig.getMongoConnectionString());
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

    public FindIterable<Document> findByPk(String pk) {

        Bson pkFilter = Filters.eq("pk", pk);
        return this.currentCollection.find(pkFilter);
    }

    public Document findByIdPk(String id, String pk) {

        Bson idFilter = Filters.eq("_id", new ObjectId(id));
        Bson pkFilter = Filters.eq("pk", pk);
        return this.currentCollection.find(Filters.and(idFilter, pkFilter)).first();
    }

}
