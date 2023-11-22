"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const util_1 = __importDefault(require("util"));
const uuid_1 = require("uuid");
const azu_js_1 = require("azu-js");
let func = process.argv[2];
switch (func) {
    case "populateSalesContainer":
        populateSalesContainer();
        break;
    default:
        displayCommandLineExamples();
        break;
}
async function populateSalesContainer() {
    // node .\dist\index.js populateSalesContainer retail sales --new-ids --sleep-ms:50
    let dbname = process.argv[3];
    let cname = process.argv[4];
    let newIds = false;
    let load = true;
    let sleepMs = 1000;
    console.log(util_1.default.format('dbname is %s per command-line arg', dbname));
    console.log(util_1.default.format('cname is %s per command-line arg', cname));
    for (let i = 0; i < process.argv.length; i++) {
        let arg = process.argv[i];
        if (arg === '--new-ids') {
            newIds = true;
            console.log('newIds is true per command-line arg');
        }
        if (arg === '--noload') {
            load = false;
            console.log('load is false per command-line arg');
        }
        if (arg.startsWith('--sleep-ms')) {
            let tokens = arg.split(':');
            if (tokens.length === 2) {
                if (tokens[0] === '--sleep-ms') {
                    sleepMs = Number(tokens[1]);
                    console.log(util_1.default.format('sleepMs is %s per command-line arg', sleepMs));
                }
            }
        }
    }
    let cosmos = new azu_js_1.CosmosNoSqlUtil('AZURE_COSMOSDB_NOSQL_URI', 'AZURE_COSMOSDB_NOSQL_RW_KEY1');
    let fu = new azu_js_1.FileUtil();
    let infile = '../Data/sales.json';
    let lines = fu.readTextFileAsLinesSync(infile);
    //let airports : Array<object> = fu.readJsonArrayFile(infile);
    console.log(util_1.default.format('%s lines loaded from infile %s', lines.length, infile));
    for (let i = 0; i < lines.length; i++) {
        console.log('---');
        let line = lines[i];
        let doc = JSON.parse(line.trim());
        if (newIds) {
            doc['id'] = (0, uuid_1.v4)();
        }
        console.log('-');
        console.log(doc);
        if (load) {
            let createResp = await cosmos.insertDocumentAsync(dbname, cname, doc);
            let resourceJson = JSON.stringify(createResp.resource, null, 2);
            console.log(util_1.default.format('idx: %s, createResp: %s', i, resourceJson));
        }
        await new Promise(f => setTimeout(f, sleepMs));
    }
    return;
}
function displayCommandLineExamples() {
    console.log('');
    console.log("node .\\dist\\index.js populateSalesContainer retail sales --new-ids --sleep-ms:3000");
    console.log('');
}
