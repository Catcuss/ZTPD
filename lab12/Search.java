package app.lucene;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.index.StoredFields;

import java.nio.file.Paths;

public class Search {

    private static final String INDEX_DIRECTORY = "./index";

    public static void main(String[] args) {
        PolishAnalyzer analyzer = new PolishAnalyzer();

            Directory directory = FSDirectory.open(Paths.get(INDEX_DIRECTORY));
            IndexReader reader = DirectoryReader.open(directory);
            IndexSearcher searcher = new IndexSearcher(reader);

            String querystr = "*:*";

            Query q = new QueryParser("title", analyzer).parse(querystr);

            int maxHits = 10;
            TopDocs docs = searcher.search(q, maxHits);
            ScoreDoc[] hits = docs.scoreDocs;

            System.out.println("Znaleziono " + hits.length + " dokumetow.");

            StoredFields storedFields = searcher.storedFields();
            for (int i = 0; i < hits.length; i++) {
                int docId = hits[i].doc;
                Document d = storedFields.document(docId);
                System.out.println(
                        (i + 1) + ". " + d.get("isbn") + "\t" + d.get("title")
                );
            }

            reader.close();
            directory.close();
    }
}
