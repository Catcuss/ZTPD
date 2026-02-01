package app.lucene;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.en.EnglishAnalyzer;
import org.apache.lucene.analysis.pl.PolishAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.*;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.*;
import org.apache.lucene.store.ByteBuffersDirectory;
import org.apache.lucene.store.Directory;

public class Main {

    private static Document buildDoc(String title, String isbn) {
        Document doc = new Document();
        doc.add(new TextField("title", title, Field.Store.YES));
        doc.add(new StringField("isbn", isbn, Field.Store.YES));
        return doc;
    }

    public static void main(String[] args) {

        // =============================
        // ZMIANA ANALIZATORA:
        // StandardAnalyzer-> Zadanie 6-7
        // EnglishAnalyzer -> Zadanie 9
        // PolishAnalyzer -> Zadanie 11-12
        // =============================
        Analyzer analyzer = new PolishAnalyzer();

            Directory directory = new ByteBuffersDirectory();
            IndexWriterConfig config = new IndexWriterConfig(analyzer);
            IndexWriter writer = new IndexWriter(directory, config);
          
            // Zadanie 6
            //String querystr = "*:*";

            // Zadanie 7A
            //String querystr = "title:dummy";

            // Zadanie 7B
            //String querystr = "title:and";


           // Zadanie 9
           //EnglishAnalyzer jest zoptymalizowany do jezyka angieskiego
      
            // Zadanie 11
            writer.addDocument(buildDoc("Lucyna w akcji", "9780062316097"));
            writer.addDocument(buildDoc("Akcje rosną i spadają", "9780385545955"));
            writer.addDocument(buildDoc("Bo ponieważ", "9781501168007"));
            writer.addDocument(buildDoc("Naturalnie urodzeni mordercy", "9780316485616"));
            writer.addDocument(buildDoc("Druhna rodzi", "9780593301760"));
            writer.addDocument(buildDoc("Urodzić się na nowo", "9780679777489"));
      
            writer.close();
            // Zadanie 12
            IndexReader reader = DirectoryReader.open(directory);
            IndexSearcher searcher = new IndexSearcher(reader);

            // a) isbn = 9780062316097
            // String querystr = "isbn:9780062316097";

            // b) tytuł zawiera "urodzić"
            // String querystr = "urodzić";

            // c) tytuł zawiera "rodzić"
            // String querystr = "rodzić";

            // d) słowo zaczynające się od "ro"
            // String querystr = "ro*";

            // e) zawiera "ponieważ"
            // String querystr = "ponieważ";

            // f) zawiera "Lucyna" i "akcja"
            // String querystr = "Lucyna AND akcja";

            // g) zawiera "akcja", ale nie "Lucyna"
            // String querystr = "akcja NOT Lucyna";

            // h) "naturalnie" i "morderca" w odległości 2
            // String querystr = "\"naturalnie morderca\"~2";

            // i) odległość 1
            // String querystr = "\"naturalnie morderca\"~1";

            // j) odległość 0
            // String querystr = "\"naturalnie morderca\"~0";

            // k) słowo "naturalne"
            // String querystr = "naturalne";

            // l) "naturalne" z tolerancją literówki
            String querystr = "naturalne~1";

            Query query = new QueryParser("title", analyzer).parse(querystr);

            TopDocs results = searcher.search(query, 10);
            ScoreDoc[] hits = results.scoreDocs;

            System.out.println("Found " + hits.length + " matching docs.");
            StoredFields storedFields = searcher.storedFields();

            for (int i = 0; i < hits.length; i++) {
                Document d = storedFields.document(hits[i].doc);
                System.out.println(
                        (i + 1) + ". " + d.get("isbn") + "\t" + d.get("title")
                );
            }

            reader.close();
            directory.close();

    }
}
